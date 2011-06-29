<div class="back"><a href="index.html">&laquo; Back to all chapters</a></div>

#Creating Application

さてここまでCoffeeScriptの構文をみてきたので、実際にCoffeeScriptのアプリケーションを作ってみましょう。この節では初心者でも熟練者でも分かりやすいように解説していきます。純粋なJavaScriptのデベロッパーの方にも学んでいただけるでしょう。

デベロッパーのみなさんがクライアントサイドのアプリケーションを作るときになると、デザインパターンなどは忘れ去られてしまい結果的には管理しづらいスパゲッティコードになってしまっています。アプリケーションのアーキテクチャは非常に重要なポイントで、シンプルなフォームバリデーション以上のものをCoffeeScript/JavaScriptで作ろうと思えば、[MVC](http://en.wikipedia.org/wiki/Model%E2%80%93view%E2%80%93controller)のような何らかのアプリケーションのアーキテクチャパターンを用いることをお勧めします。

大規模の管理可能なアプリケーションを作る秘訣は、モジュールからなるカップルされていないコンポーネントの連なりをつくることにあります。アプリケーションのロジックを出来る限り包括的なものにとどめ、適切に抽象化することが重要です。おすすめの本として挙げられるのは、[JavaScript Web Applications](http://oreilly.com/catalog/9781449307530/)があり、おすすめのフレームワークとして[Backbone](http://documentcloud.github.com/backbone/) や [Spine](https://github.com/maccman/spine)も挙げられます。今回の節ではCommonJSモジュールを使ってアプリケーションを作っていきたいと思います。

##Structure & CommonJS

ではそのCommonJSモジュールとは何なんでしょうか？ CommonJSは使ったことないけど、[NodeJS](http://nodejs.org/)は使ったことがあるという方であれば、実はもうCommonJSを使っているのです。CommonJSモジュールは最初はサーバサイドのJavaScriptライブラリを書くのに開発されたもので、ローディングや名前空間、スコープの問題を解決するために作られました。またどのJavaScriptアプリケーションでも準拠できるようにできています。[Rhino](http://www.mozilla.org/rhino/)向けに書かれたライブラリをNodeでも動くようにすることが目的でした。最終的にはこのアイデアはクライアント側に戻ってきて、今では[RequireJS](http://requirejs.org) や [Yabble](https://github.com/jbrantly/yabble) などのクライアントサイドでモジュールが使えるようになるライブラリも開発されてきました。

モジュールはあなたの書いたコードがローカルの名前空間で動き、また `require()` によって読み込まれた他のモジュールも使うことができ、かつ、モジュールのプロパティを `module.exports` でエクスポートすることもできます。ではもう少し踏み込んでみてみましょう。

###Requiring files

`require()` で他のライブラリ・モジュールを読み込むことが出来ます。モジュール名を引数に渡し、読み込みが成功するとそのモジュールをオブジェクトとして返します。

    var User = require("models/user");
    
同期のrequireのサポートはまだ議論中ですが、主要なローダーライブラリや直近のCommonJSの[提案](http://wiki.commonjs.org/wiki/Modules/AsynchronousDefinition)ではおおよそ解決されています。もしここで使われているStitchとは違った他のオプションを使いたい場合は、ご自身で調べてみるのもいいでしょう。

###Exporting properties

デフォルトでは、 `require()` ではモジュールのプロパティを見ることができません。もし特定のプロパティをアクセス可能にするには `module.export` に設定する必要があります。

    // random_module.js
    module.exports.myFineProperty = function(){
      // Some shizzle
    }
    
モジュールが読み込まれたときには `myFineProperty`　がアクセス可能になっているはずです。

    var myFineProperty = require("random_module").myFineProperty;

##Stitch it up

ソースコードをCommonJSモジュールとして扱うのは非常に分かりやすく簡単なのですが、ではこれをどうしてクライアントサイドで使えばいいのでしょうか？私個人の選択としてはそんなに知られていない[Stitch](https://github.com/sstephenson/stitch)を使いたいと思います。このライブラリは[Prototype.js](http://www.prototypejs.org)の作者であるSam Stephensonによって開発され、モジュールに関わる問題をエレガントに解決してくれています。ダイナミックにdependencyを解決するより、Stitchは単純に全てのJavaScriptを一つにまとめてくれ、それらをCommonJSの魔法をかけてくれるのです。いい忘れていたかもしれませんが、StitchはCoffeeScriptだけでなく、JSテンプレート、[LESS CSS](http://lesscss.org) や [Sass](http://sass-lang.com)もコンパイルしてくれるのです！

手始めとして、まずStitchをインストールしましょう。もちろん[Node.js](http://nodejs.org/) と [npm](http://npmjs.org/)はインストールしておいてください。

    npm install stitch
    
さてアプリケーションのストラクチャを作ってみましょう。もし[Spine](https://github.com/maccman/spine)を使っている場合は、[Spine.App](http://github.com/maccman/spine.app)で自働化できますが、そうでない場合は手動でしましょう。私の場合は通常 `app` フォルダにアプリケーション関連のコードを置き、`lib` フォルダに一般的なライブラリ群を、静的なファイルなどその他のファイルは `public` に置いています。

    app/controllers
    app/views
    app/models
    app/lib
    lib
    public
    public/index.html
    public/css
    public/css/views

そしてStitchサーバを立ち上げます。`server.js` を以下のコードで保存してみましょう。

    #!/usr/bin/env node
    var stitch  = require('stitch'),
        express = require('express'),
        util    = require('util'),
        argv    = process.argv.slice(2);

    var package = stitch.createPackage({
      // Specify the paths you want Stitch to automatically bundle up
      paths: [__dirname + '/lib', __dirname + '/app'],
      
      // Specify your base libraries
      dependencies: [
        __dirname + '/lib/json2.js',
        __dirname + '/lib/shim.js',
        __dirname + '/lib/jquery.js',
        __dirname + '/lib/jquery.tmpl.js',
        __dirname + '/lib/spine.tmpl.js',
        __dirname + '/lib/spine.js'
      ]
    });

    var app = express.createServer();

    app.configure(function() {
      app.set('views', __dirname + '/views');
      // Compile Less CSS files
      app.use(express.compiler({ src: __dirname + '/public', enable: ['less'] }));
      app.use(app.router);
      // Set the static route, in this case `public`
      app.use(express.static(__dirname + '/public'));
      // And invoke Stitch when application.js is requsted
      app.get('/application.js', package.createServer());
    });

    var port = argv[0] || process.env.PORT || 9294;
    util.puts("Starting server on port: " + port);
    app.listen(port);

さて、あと少しです！ここで `server.js` をNodeで走らせると、Stitchサーバが立ち上がるでしょう。では `app` フォルダに `app.coffee` を作りましょう。このファイルが私たちのアプリケーションをブーストラップしてくれるファイルになります。

<span class="csscript"></span>

    module.exports = App =
      init: ->
        # Bootstrap this mofo
        
では次はメインページになる `index.html` です。もしシングルページアプリケーションにする場合は、このページ唯一ユーザに見られるページとなります。これは静的なページなので `public` フォルダに置いておきましょう。 
  
    <!DOCTYPE html>
    <html>
    <head>
      <meta charset=utf-8>
      <title>Application</title>
      <link rel="stylesheet" href="/css/application.css" type="text/css" charset="utf-8">
      <!-- Require the main Stitch file -->
      <script src="/application.js" type="text/javascript" charset="utf-8"></script>
      <script type="text/javascript" charset="utf-8">
        jQuery(function(){
          var App = require("app");
          window.App = App.init({el: $("body")});      
        });
      </script>
    </head>
    <body>
    </body>
    </html>

ページが読み込まれると、インラインのjQueryコールバックが `app.coffee` を読み込み(ファイルは自動的にコンパイルされます)、そして `init()` が呼ばれます。たったこれだけでCommonJSモジュールを走らせ、HTTPサーバも立ち上げ、さらにはCoffeeScriptもコンパイルしてくれるのです。もし他のモジュールを読み込みたい場合は、単に `require()` を呼ぶだけです。

<span class="csscript"></span>

    # models/user.coffee
    module.exports = class User
      constructor: (@name) ->
      
    # app.coffee
    User = require("models/user")

##JavaScript templates

クライアントサイドにロジックを移すときは、ある種のテンプレートライブラリが必要になってきます。JavaScriptテンプレートはサーバサイドのテンプレートと非常に似たもので、それがサーバ側で生成されていないことを除けば、RubyのERBやPythonのTextInterpolationと同じです。デフォルトとして、Stitchは[eco](https://github.com/sstephenson/eco)というテンプレートライブラリを使うことが出来ます。もし、他のテンプレートライブラリを使いたい場合でも、Stitchにカスタムコンパイラを追加し、特定のエクステンションをコンパイルすることもできるので安心してください。

例として、[jQuery.tmpl](http://api.jquery.com/jquery.tmpl/)ライブラリのサポートを追加してみましょう。

    stitch.compilers.tmpl = function(module, filename) {
      var content = fs.readFileSync(filename, 'utf8');
      content = ["var template = jQuery.template(", JSON.stringify(content), ");", 
                 "module.exports = (function(data){ return jQuery.tmpl(template, data); });\n"].join("");
      return module._compile(content, filename);
    };

お気づきのように、上のコードでは `module.exports` に呼ばれるとテンプレートをレンダリングする関数が当ててあります。では、`views/users/show.tmpl` にテンプレートを作ってみましょう。
    
    <label>Name: ${name}</label>
    
`tmpl` コンパイラハンドラーを定義したので、Stitchは自動的にテンプレートをコンパイルしそれを `application.js` に追加します。
    
    require("views/users/show")(new User("name"))
    
##Bonus - 30 second deployment with Heroku

[Heroku](http://heroku.com/)は素晴らしいホスティングでサーバとスケーリングを全て管理してくれ、すばらしいJavaScriptアプリケーションをホストしてくれるなど、エキサイティングなサービスをしてくれます。このチュートリアルを動かすにはHerokuでアカウントを作る必要がありますが、ベーシックプランは完全に無料なので試してみてください。一般的にはRubyのホスティングとして使われていますが、HorokuはCederスタックをリリースしてNodeも動かすことが出来るようになりました。

最初に `Procfile` を作りましょう。このファイルはHerokuにこのアプリケーションについての情報を伝えてくれるファイルとなります。

    echo "web: node server.js" > Procfile

アプリケーションのディレクトリにローカルのgitレポジトリを作りましょう。

    git init
    git add .
    git commit -m "First commit"    
    
そして、このアプリケーションをデプロイするには、 `heroku` gem を使います。(もしインストールされていないなら、`gem install heroku` でインストールしましょう。)

    heroku create myAppName --stack cedar
    git push heroku master
    heroku ps:scale web=1
    heroku open
    
これでおしまいです。ほんっとに、これだけです`:D` Nodeアプリケーションのホスティングはこれまでになく簡単になりましたね。
