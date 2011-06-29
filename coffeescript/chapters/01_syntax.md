<div class="back"><a href="index.html">&laquo; 目次に戻る</a></div>

#構文

この節に踏み込む前にもう一度繰り返しておくと、CoffeeScriptの構文は時々JavaScriptに似たものもありますが、それは決して上位にある言語ではなく、それゆえJavaScriptのキーワードの `function` や `var` はCoffeeScriptでは使ってはいけません。使った場合は構文エラー(SyntaxError)が返されます。CoffeeScriptを書いているときは、そのファイルは純粋にCoffeeScriptでなくてはならず、二つの言語をごちゃ混ぜにしてはいけません。

なぜ上位(superset)ではないのかというと、CoffeeScriptでは空白(whitespace)が重要な意味を持っているからです。そして一度CoffeeScriptと決めたら、チームのみんなも同様にそうしなければならず、簡素化のため、そしてよく起こるバグを減らすためにも、JavaScriptのキーワードなどを切り捨てなくてはいけません。

私がびっくりしたのは、CoffeeScriptのインタプリタそのものがCoffeeScriptで書かれているという事です。にわとりとたまごの逆説がとうとう解かれましたね :D

さて、まず基本的な事から。CoffeeScriptにはセミコロン(;)は存在しません。コンパイル時に自動的に挿入されます。セミコロンはインタプリタの[変な挙動](http://bonsaiden.github.com/JavaScript-Garden/#core.semicolon)もあってJavaScriptコミュニティでも議論の的となっていました。とにかく、ただセミコロンを省くだけでこのやっかいなことから回避できて、CoffeeScriptが必要なときに自動的に挿入してくれます。

コメントはRubyのコメントと一緒で、ハッシュ(#)から始まります。

    # A comment
    
複数行のコメントもサポートされていて、コンパイルされるJavaScriptにも反映されます。3連続のハッシュで囲みます。

<span class="csscript"></span>

    ###
      A multiline comment, perhaps a LICENSE.
    ###

それとなく触れたように、空白はCoffeeScriptは大事な要素です。実際にはタブが括弧(`{}`)の代わりになります。これはPythonの構文から影響を受けています。そして良い副作用としてコードそのものをきれいに整頓してくれますし、もしフォーマットが崩れていたらコンパイルはされません。

##変数と範囲(Scope)

CoffeeScriptはJavaScriptの主要な弱点であるグローバル変数の問題を解決します。JavaScriptでは`var`を付け忘れるだけで、いとも簡単にグローバルに変数を宣言できてしまいました。CoffeeScriptはこの問題も、グローバル変数をなくすことで解決しています。その裏では、CoffeeScriptが全体を匿名のファンクション(Anonymous function) で囲う事で、ローカルのコンテクストにとどめて、全ての変数の代入を自動的に`var`を付けてコンパイルしています。例えば、以下の簡単なCoffeeScriptの例を見てましょう。


<span class="csscript"></span>

    myVariable = "test"

右上のグレーの四角の部分をクリックしてみてください。コードがCoffeeScriptとコンパイルされたJavaScriptとに交互に変わります。このコードはページが読み込まれた後に生成された物ですので、コンパイルされたアウトプットが正確だという事が見てお分かりだと思います。

ご覧の通り、全ての変数はローカルにとどまっており、うっかりグローバルの変数を作る事は不可能です。CoffeeScriptは実際にはもう少し踏み込み、さらに上位の変数の上書きも出来ないようにしています。これによってJavaScriptデベロッパーが頻繁に直面する問題を回避することが出来るのですx

しかし、時にはグローバルな変数を作った方が便利なときもありますよね。その時は直接、グローバルオブジェクト(ブラウザの`window`)のプロパティとして、もしくは以下のようなパターンでそうする事が出来ます。

<span class="csscript"></span>

    exports = this
    exports.MyVariable = "foo-bar"
    
ルートのコンテクストにおいて、 `this` グローバルオブジェクトと同等なので、ローカルの `exports` を作っておくことで、どの変数がグローバルな変数なのか誰にでも分かりやすい書き方ができます。さらに、これは後述するCommonJSのモジュールにも関連してきます。

##関数(Function)

CoffeeScriptは分かりきった `function` ステートメントを省き、矢印 `->` をもって関数としています 。関数は、１行でもインデントを用いて複数行でも可能です。関数の最後の式が暗黙的に返されるため、関数内で明示的に `return` する場合を除いて、 `return` をタイプする必要はありません。
    
さて、次の例を見てみましょう
    
<span class="csscript"></span>

    func = -> "bar"

ご覧の通り出力された結果では、`->` が `function` に置き換わり, そして `"bar"` が自動的に返されています。

先に述べた通り、インデントが正しくなされている限り、複数文でも可能です。

<span class="csscript"></span>

    func = ->
      # An extra line
      "bar"
      
###関数の引数

引数を指定はどうでしょうか？ CoffeeScriptでは矢印の前の括弧の中に引数を指定します。

<span class="csscript"></span>

    times = (a, b) -> a * b

CoffeeScriptではデフォルトの引数を指定する事も可能です。

<span class="csscript"></span>

    times = (a = 1, b = 2) -> a * 2
    
また `...` を用いる事で複数の引数を渡す事も出来ます。

<span class="csscript"></span>

    sum = (nums...) -> 
      result = 0
      nums.forEach (n) -> result += n
      result

上の例では、 `nums` は関数に渡された全ての引数の配列です。これは普通の `arguments` オブジェクトではなく、配列になっているため `Array.prototype.splice` や `jQuery.makeArray()` に悩まされる心配はありません。

<span class="csscript"></span>

    trigger = (events...) ->
      events.splice(1, 0, this)
      this.parent.trigger.apply(events)

###関数の呼び出し

関数の呼び出しはJavaScriptと全く同じで、 `()` , `apply()` もしくは `call()` で行う事が出来ます。しかしCoffeeScriptもRubyのように少なくとも一つの引数が渡されると自動的にその関数が呼び出されます。


<span class="csscript"></span>

    a = "Howdy!"
    
    alert a
    # Equivalent to:
    alert(a)

    alert inspect a
    # Equivalent to:
    alert(inspect(a))
    
括弧はつけなくてもいいですが、どの関数が呼ばれ、どれが引数なのかをはっきりさせるためにも明示的に付けた方がいい場合もあります。最後の `inspect` の例では、 少なくとも `inspect` の呼び出しを分かりやすくするために括弧をつけることを強くお勧めします。

<span class="csscript"></span>

    alert inspect(a)

もし関数を呼び出す際に引数が一つも渡されなかった場合は、CoffeeScriptは関数を呼びたいのか、もしくはただの変数として扱いたいのか分からないので、その点においては必ず関数を呼び出すRubyの挙動とは異なっています。どちらかというとPythonの動作により似ていると言えます。この動作の違いがCoffeeScriptのエラーの原因になったりしたこともあったので、引数を持たない関数の呼び出しの取り扱いには注意し、その場合はきちんと空の括弧を付けて関数を呼ぶようにしましょう。

###関数のコンテクスト

コンテクストはJavaScriptでは様々で、特にイベントコールバックの場合はややこしくなったりするので、CoffeeScriptはこれを助けてくれるヘルパーをいくつか兼ね備えています。 一つ目は `->` の少し異なる型のふとっちょ矢印 `=>` の関数です。

Using the fat arrow instead of the thin arrow ensures that the function context will be bound to the local one. For example:
ふとっちょ矢印は細い矢印とは異なり、関数のコンテクストを常にローカルのコンテクストに保ってくれます。例えば:

<span class="csscript"></span>

    this.clickHandler = -> alert "clicked"
    element.addEventListener "click", (e) => this.clickHandler(e)

なぜこんなことをしたいのかというと、 `addEventListener()` のコールバックのコンテクストはその `element` のローカルのコンテクストに変更されるからです。つまり `this` が その `element` に置き換えられてしまうのです。もし `this` をローカルに維持しておきたい場合は、いちいち `self = this` など書かずに、ふとっちょ矢印を使いましょう

このバインディングのアイデアは jQueryの [`proxy()`](http://api.jquery.com/jQuery.proxy/) or [ES5's](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Function/bind)の `bind()`の関数から来ています。 

##オブジェクトリテラル & 配列の定義

オブジェクトリテラルはキーと値を使って、JavaScriptと全く同じように扱われます。しかし関数の呼び出しと同様に、CoffeeScriptでは括弧( `{}` )を付けなくてもかまいません。実際のところ、コンマで分けなくても、インデントと改行で済ませる事が可能です。

<span class="csscript"></span>

    object1 = {one: 1, two: 2}

    # Without braces
    object2 = one: 1, two: 2
    
    # Using new lines instead of commas
    object3 = 
      one: 1
      two: 2
    
    User.create(name: "John Smith")

同じように配列もコンマを使わなくても大丈夫ですが、角括弧( `[]` )はここでは必須となります。

<span class="csscript"></span>

    array1 = [1, 2, 3]

    array2 = [
      1
      2
      3
    ]

    array3 = [1,2,3,]
    
上記の例からも見て分かるように、CoffeeScriptは `array3` の要に、後ろに残ったコンマも取り去ってくれるので、これもブラウザ間での異なる挙動からくるエラーを防いでくれます。

##フロー制御

CoffeeScriptの「括弧を付けなくても良い仕様」は `if` や `else` でも同様です。

<span class="csscript"></span>

    if true == true
      "We're ok"
      
    if true != true then "Panic"
    
    # Equivalent to:
    #  (1 > 0) ? "Ok" : "Y2K!"
    if 1 > 0 then "Ok" else "Y2K!"
    
お分かりの通り、もし `if` 文が一行の場合はCoffeeScriptにどこでブロックが始まるのか伝えるために `then` キーワードを付けなくてはなりません。 条件式オペレータである( `?:` )はサポートされておらず、そのかわり一行で `if/else` を書く事ができます。

CoffeeScriptはRubyの表現である、後付けの `if` 文にも対応しています。

<span class="csscript"></span>

    alert "It's cold!" if heat < 5

否定表現の( `!` )を使う代わりに、 `not` キーワードを使う事も出来ます。こうする事でびっくりマークで複雑になりがちなコードをすっきりと読みやすくすることができます。

<span class="csscript"></span>

    if not true then "Panic"
    
上記の例では、`if` の否定文であるCoffeeScriptの `unless` を使う事も可能です。

<span class="csscript"></span>

    unless true
      "Panic"

`not` と同様に、CoffeeScriptでは `is` も使用可能で、これは `===` にコンパイルされます。

<span class="csscript"></span>

    if true is 1
      "Type coercian fixed!"

上の例でお気づきかもしれませんが、CoffeeScriptでは `==` を `==` に `!=` を `!==` に変換しています。私のCoffeeScriptのもっともシンプルで好きな特徴の一つです。これをする意味は何でしょうか？簡単に言えば、JavaScriptのタイプ判定が少しが変で、判定時にタイプを変更してしまい、様々なバグや変な動作の原因となっているのです。

以下の例は、[JavaScript Garden's equality section](http://bonsaiden.github.com/JavaScript-Garden/#types.equality) からの抜粋で、ここでいくつかの問題点を挙げています。

<span class="csscript"></span>

    ""           ==   "0"           // false
    0            ==   ""            // true
    0            ==   "0"           // true
    false        ==   "false"       // false
    false        ==   "0"           // true
    false        ==   undefined     // false
    false        ==   null          // false
    null         ==   undefined     // true
    " \t\r\n"    ==   0             // true
  
この課題に対する解決策は、より厳密なイコールオペレータ( `===` )を使う事です。これは普通のイコールオペレータと全く同様に判定をしてくれ、タイプ変更も起こりません。滅多な個とがない限り、この厳密なイコールオペレータを使うべきで、必要なときは明示的にタイプを変更しましょう。前に述べた通り、これはCoffeeScriptではデフォルトとなっているため、`==` も厳密な `===` に自動的に変換されます。

<span class="csscript"></span>

    if 10 == "+10" then "type coercion fail"
    
##文字列の操作

CoffeeScriptではRubyに近い文字列の操作が可能になります。 `"` (Double Quote)で囲まれた文字列は `#{}` タグを含むことが可能で、そのタグ内の表現は文字列に組み込まれます。

<span class="csscript"></span>

    favourite_color = "Blue. No, yel..."
    question = "Bridgekeeper: What... is your favourite colour?
                Galahad: #{favourite_color}
                Bridgekeeper: Wrong!
                "

上の例より、複数行の文字列も可能でいちいち `+` を付けてつなぎ合わせる必要もありません。

##配列内包表記(Array Comprehension)

配列の反復処理は、少しクラッシックで、モダンなオブジェクト指向のものに比べると、どちらかというとC言語に近いものと言えます。ES5から導入される `forEach()` によってこの状況は改善されると期待されますが、しかし反復処理ごとに関数の呼び出しが必要となるので結果的に遅くなってしまいます。このケースに対してもCoffeeScriptが美しい構文を提供してくれるのです:

<span class="csscript"></span>

    for name in ["Roger", "Roderick", "Brian"]
      alert "Release #{name}"
      
反復の回数を使いたいときは、もう一つの引数を渡して:
      
<span class="csscript"></span>

    for name, i in ["Roger the pickpocket", "Roderick the robber"]
      alert "#{i} - Release #{name}"

また一行で反復処理も可能です。

<span class="csscript"></span>

    release prisoner for prisoner in ["Roger", "Roderick", "Brian"]
    
Pythonと同様にフィルターをかける事だって出来ます。

<span class="csscript"></span>

    prisoners = ["Roger", "Roderick", "Brian"]
    release prisoner for prisoner in prisoners when prisoner[0] is "R" 

オブジェクトのプロパティの処理も `in` の代わりに `of` を使う事で簡単に扱う事が出来ます。

<span class="csscript"></span>

    names = sam: seaborn, donna: moss
    alert("#{first} #{last}") for first, last of names

<p`while` ループのCoffeeScriptにはJavaScriptと同様に使用可能ですが、CoffeeScriptでは結果の配列を返し、`Array.prototype.map()` と同じ動作をします。

<span class="csscript"></span>

    num = 6
    minstrel = while num -= 1
      num + " Brave Sir Robin ran away"

##配列

CoffeeScriptの範囲による配列の抜き出し( `slice` )はRubyから発想を得ています。範囲は最初と最後のそれぞれの位置の2つの数字で作られ、 `..` もしくは `...` で分かれています。もし範囲になにも付いていない場合は、CoffeeScriptはそれを配列として処理します。

<span class="csscript"></span>

    range = [1..5]
    
しかし、もし範囲が変数のすぐ後で指定された場合、CoffeeScriptはそれを `slice()` として変換します。
    
<span class="csscript"></span>

    firstTwo = ["one", "two", "three"][0..1]
    
この上の例では、範囲が新しい配列を返し、その配列はオリジナルの配列の最初の2つの要素を含んでいます。また、配列の特定の部分を他の配列とに入れ替える場合にも使えます。

<span class="csscript"></span>

    numbers = [0..9]
    numbers[3..5] = [-3, -4, -5]

これのいいところは、JavaScriptでは文字列に対しても `slice()` が使えるので、文字列中に特定の部分を新しい文字列として取り出す事も可能です。
    
<span class="csscript"></span>

    my = "my string"[0..2]

JavaScriptではある値が配列の中にあるかどうかの判別はいつもめんどくさい物でした。というのも `indexOf()` が全てのブラウザでサポートされていなかったからです(というかIEのことをいうてるんやけど...)。CoffeeScriptはこの課題も `in` オペレータで解決できます。

<span class="csscript"></span>

    words = ["rattled", "roudy", "rebbles", "ranks"]
    alert "Stop wagging me" if "ranks" in words 

##エイリアス & 存在確認オペレータ

CoffeeScriptはタイピングを減らすための便利なエイリアスを含んでいます。その一つは `@` です。これは、 `this` の代わりとなります。

<span class="csscript"></span>

    @saviour = true
    
もう一つは `::` で、これは `prototype` の代わりとなります。

<span class="csscript"></span>

    User::first = -> @records[0]
    
JavaScriptでは `if` で `null` をチェックする事は良くありますが、空の文字列やゼロも同時に `false` にしてしまいます。CoffeeScriptには存在確認オペレータ `?` があり変数が `null` もしくは `undefined` の時のみ `true` を返します。Rubyの `nil?` と同様です。

<span class="csscript"></span>

    praise if brian?
    
また、このオペレータを `||` オペレータの代わりとして使用する事も出来ます。

<span class="csscript"></span>

    velocity = southern ? 40
    
もしプロパティにアクセスする際に `null` を用いてチェックをしているなら、始まりの括弧の前に `?` を置く事でその手間を省く事が出来ます。これもRubyの `try` メソッドに似ています。

<span class="csscript"></span>

    blackKnight.getLegs()?.kick()

また同様にして、関数にも「関数かどうか」の判定を与える事が出来ます。

<span class="csscript"></span>

    whiteKnight.guard? us
