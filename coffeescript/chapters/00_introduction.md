<div class="back"><a href="index.html">&laquo; Back to all chapters</a></div>

#CoffeeScriptって何?

[CoffeeScript](http://coffeescript.org)とはJavaSciptに書き換えてくれる便利な言語のことです。 文法はRubyやPythonに影響を受けていて、この二つの言語の様々な特徴を備えています。 この本は、読者の方に、CoffeeScript、そのベストプラクティスを学んで頂き、素晴らしいクライアントアプリケーションを作り始めてもらいたいという意図で書かれています。この本は小さく5チャプターしかないですが、それはCoffeeScriptそのものが小さいからなのです。

この本は完全にオープンソース形式となっており、 [Alex MacCaw](http://alexmaccaw.co.uk) ([@maccman](http://twitter.com/maccman))によって書かれ、[David Griffiths](https://github.com/dxgriffiths), [Satoshi Murakami](http://github.com/satyr) や [Jeremy Ashkenas](https://github.com/jashkenas)の協力を得て書かれています。

もし誤字脱字、提案などがある場合はこの本の[GitHub ページ](https://github.com/arcturo/library)でお願いします。 ご興味のある方は [JavaScript Web Applications by O'Reilly](http://oreilly.com/catalog/9781449307530/)というリッチなクライアントサイドのJavaScriptアプリケーションに関する本も参照ください。

さて、始めましょう。ではなぜJavaScriptよりCoffeeScriptなのか？それは、まず第一に「たくさん書かなくてよい」ことが挙げられます。CoffeeScriptは非常にコンパクトで、空白が用いられているのが特徴です。私の経験では、普通のJavaScriptの⅓から½までコードを削る事が出来ます。さらに、CoffeeScriptには様々な便利な要素が備わっていて、配列の内包表記(Array Comprehension)、プロトタイプ(prototype)エイリアスやクラス(Class)などにより、今まで書いてきたコードをさらに減らす事も可能なのです。

さらに重要なのは、JavaScriptにはよく経験不足なデベロッパーつまずいてしまう多くの[隠したい事実](http://bonsaiden.github.com/JavaScript-Garden/)が存在します。CoffeeScriptはきちんとこれらを回避し、JavaScriptを良い部分だけ厳選し、おかしな部分を直してくれるのです。

CoffeeScriptはJavaScriptの上に位置するものではありません。CoffeeScriptからJavaScriptで書かれた外部のライブラリを使う事が出来る一方で、変換せずにそのままJavaScriptをCoffeeScriptに変換しようとすると文法エラー(Syntax Error)を受けてしまいます。

コンパイラはCoffeeScriptのコードを対応するJavaScriptに変換してくれるだけで、ランタイムでのインタプリテーションはありません。 勘違いしやすい落とし穴を解決していきましょう。 第一に、CoffeeScriptを書くにはJavaScriptを知っている必要があります。なぜなら、実行時にはどうしてもJavaScriptの知識が必要だからです。しかし、そうはいってもランタイムエラーは大抵見つけやすく、自身、「JavaScriptのエラーがCoffeeScriptのどこから来ているのか分からなくなった」などの問題は今までありません。 第二に、CoffeeScriptについての間違った見解としては速度の問題です。つまり、CoffeeScriptによってコンパイルされたコードは純粋なJavaScriptで書かれたものより遅いんじゃないかというものです。これもまた、実際に全く問題ではありません。CoffeeScriptは普通に書かれたJavaScriptよりむしろ速い傾向があります。

では、CoffeeScriptを使う上での不利な点はなんでしょうか？あえて挙げるとすれば、JavsScriptとあなたのコードにコンパイルするというステップが加わるということでしょうか。CoffeeScriptはきれいで読みやすいJavaScriptにコンパイルする事、サーバとの統合によって、自動的にコンパイルもしてくれるので、このステップは出来る限り小さくされています。もう一つは、新しい言語にはいつも共通する問題ですが、コミュニティがまだ小さいために既に知っている人を見つけるのが難しいといった問題もあります。ただ、CoffeeScriptは速いスピードで勢いを増してきていますし、IRCではどんな質問でも素早く返信されます。

CoffeeScriptはブラウザだけにとどまりません。[Node.js](http://nodejs.org/)のようなサーバサイドのJavaScriptにも使う事が出来ます。さらに、CoffeeScriptはRails3.1でデフォルトになったように広く用いられ、統合され始めています。CoffeeScriptの電車に飛び乗るにはいい機会ではないでしょうか？今この小さな言語を学ぶのに少しの時間を費やせば、それから節約され、生み出された多くの時間をありがたく感じると思います。

##セットアップ方法

一番手っ取り早い方法はブラウザでそのまま遊んでみる方法です。[http://coffeescript.org](http://coffeescript.org)へ飛び、 <em>Try CoffeeScript</em> タブをクリックしてください。ブラウザバージョンのCoffeeScriptコンパイラで左側に打ち込んだコードが右側にJavaScriptとして書き出されます。

さらに、自身でもこのブラウザベースのコンパイラを使うことが出来るので、[このスクリプト](http://jashkenas.github.com/coffee-script/extras/coffee-script.js) をページに埋め込み、正確な `type` でCoffeeScriptを書いてみましょう。

    <script src="http://jashkenas.github.com/coffee-script/extras/coffee-script.js" type="text/javascript" charset="utf-8"></script>
    <script type="text/coffeescript">
      # Some CoffeeScript
    </script>
    
プロダクションの段階ではブラウザをいじめるランタイムでのコンパイルは避けた方がいいので、[Node.js](http://nodejs.org)のコンパイラでCoffeeScriptファイルを変換する事が出来ます。

インストールには、もちろん最新の安定版[Node.js](http://nodejs.org)がインストールされていて、[npm](http://npmjs.org/) (the Node Package Manager)も同時にインストールされている必要があります。npmでCoffeeScriptをインストールするには、

    npm install coffee-script
    
これで `coffee` が実行可能になりました。Terminalで `coffee` と打つと、CoffeeScriptコンソールが起動し、すぐにCoffeeScriptのコードを実行する事が出来ます。コンパイルするには、 `--compile` オプションを付けて以下のようにしてください。

    coffee --compile my-script.coffee
    
`--output` オプションが指定されていない場合、CoffeeScriptは同じ名前でJavaScriptを保存します。(上記の例の場合は,  `my-script.js` ) この操作は既存のファイルを上書きしてしまうので注意してください。

見てお分かりの通り、CoffeeScriptのデフォルトの拡張子は <code>.coffee</code> となります。他の言語と同じように、[TextMate](http://macromates.com/)などのエディタで正しい文法ハイライトを付けることができます。TextMateの場合、デフォルトではCoffeeScriptに対応していないので、[こちら](https://github.com/jashkenas/coffee-script-tmbundle)からそのバンドルをインストールする事が出来ます。

このコンパイルステップが「不便…面倒や…」と感じられるかもしれませんが、そうゆうものなのです:D 後ほど自動的にCoffeeScriptをコンパイルする方法をお教えしますので、まずこの言語の文法から見てみましょう。
