<div class="back"><a href="index.html">&laquo; Back to all chapters</a></div>

#Common CoffeeScript idioms

すべての言語にはイディオムやプラクティスのセットがあり、CoffeeScriptも例外ではありません。この節では、これらのルールをについて学び、言語の実用的な感覚を得ることができるように、比較のためにいくつかのJavaScriptが同時に表示したいと思います。


##Each

JavaScriptでは、新しく追加された [`forEach()`](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/array/foreach) か、一般的な反復処理を使う事が出来ます。ECMAScript 5で導入されたJavaScriptの最新の機能を使用したい場合、古いブラウザ向けには[shim](https://github.com/kriskowal/es5-shim)の導入をお勧めします。
    
    for (var i=0; i < array.length; i++)
      myFunction(array[i]);
      
    array.forEach(function(item, i){
      myFunction(item)
    });

`forEach()` 構文ははるかに簡潔で読みやすいですが、一方でコールバック関数が反復ごとに呼ばれているため、JavaScriptで書かれるループのよりも遅くなってしまいます。以下の例を見てみましょう。

<span class="csscript"></span>
      
    myFunction(item) for item in array
    
確かに読みやすく簡潔な構文で、コンパイル時に `for` に変換されていますね。言い換えれば、CoffeeScriptは `forEach()` とほぼ同じ表現力を提供してはいますが、その処理速度の低下には注意が必要です。
    
##Map

`forEach()` と同様に、クラシックな `for` ループに加えて、ES5では [`map()`](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/Array/map) という、ネイティブなマップ機能が導入されます。しかし `forEach()` と同様にパフォーマンスの点では注意が必要です。

    var result = []
    for (var i=0; i < array.length; i++)
      result.push(array[i].name)

    var result = array.map(function(item, i){
      return item.name;
    });

文法の節で説明したように、CoffeeScriptの内包表記は `map()` と同様の機能を果たしています。配列を返すことを明示するために、内包表記は**必ず**括弧で囲わなくてはいけません。

<span class="csscript"></span>

    result = (item.name for item in array)

##Select

ES5には [`filter()`](https://developer.mozilla.org/en/JavaScript/Reference/Global_Objects/array/filter) が導入され、配列をフィルタリングをすることができます。
    
    var result = []
    for (var i=0; i < array.length; i++)
      if (array[i].name == "test")
        result.push(array[i])

    result = array.filter(function(item, i){
      return item.name == "test"
    });

CoffeeScriptの文法では、 `when` キーワードを用いて要素を比較する事が出来ます。実際に実行する関数はスコープ漏れや変数のコンフリクトを避けるために匿名関数(Anonymous Function)が用いられます。

<span class="csscript"></span>

    result = (item for item in array when item.name is "test")

括弧を忘れてしまうと 結果は配列の最後の項目になるので忘れないように注意しましょう。CoffeeScriptの内包表現は非常に柔軟なので、以下のような場合も対応できます。

<span class="csscript"></span>

    passed = []
    failed = []
    (if score > 60 then passed else failed).push score for score in [49, 58, 76, 82, 88, 90]
    
    # Or
    passed = (score for score in scores when score > 60)

##Includes

値が配列内にあるかどうかを確認する場合、通常(もちろんこの"通常"にはIEは含まれていません)は `indexOf()` を用いる事でチェックする事が出来ます。<!-- "I don't wanna even translate this as it doesn't make any sense to support IE" which rather mind-bogglingly still requires a shim, as Internet Explorer hasn't implemented it. -->

    var included = (array.indexOf("test") != -1)

CoffeeScript has a neat alternative to this which Pythonists may recognize, namely `in`.

<span class="csscript"></span>
    
    included = "test" in array

どのようにコンパイルされているかというと、CoffeeScriptは `Array.prototype.indexOf()` を使って配列をチェックしています。しかし、この場合文字列に対しては使う事が出来ません。そのため文字列の場合は `indexOf()` を用いましょう

<span class="csscript"></span>

    included = "a long test string".indexOf("test") isnt -1

より良い例は、`-1` の比較をビット演算子をつかって代替する方法です。

<span class="csscript"></span>
    
    string   = "a long test string"
    included = !!~ string.indexOf "test"
    
##Min/Max

This technique is not specific to CoffeeScript, but I thought it useful to demonstrate anyway. `Math.max` and `Math.min` take multiple arguments, so you can easily use `...` to pass an array to them, retrieving the maximum and minimum values in the array. 

<span class="csscript"></span>

    Math.max [14, 35, -7, 46, 98]... # 98
    Math.min [14, 35, -7, 46, 98]... # -7

##And/or

CoffeeScript style guides indicates that `or` is preferred over `||`, and `and` is preferred over `&&`. I can see why, as the former is somewhat more readable. Nevertheless, the two styles have identical results.  

This preference over more English style code also applies to using `is` over `==` and `isnt` over `!=`.
    
<span class="csscript"></span>

    string = "migrating coconuts"
    string == string # true
    string is string # true
    
One extremely nice addition to CoffeeScript is the 'or equals', which is a pattern Rubyists may recognize as `||=`:
    
<span class="csscript"></span>

    hash or= {}
    
If hash evaluates to `false`, then it's set to an empty object. It's important to note here that this expression also recognizes `0`, `""` and `[]` as false. If that isn't your intention, you'll need to use CoffeeScript's existential operator which only gets activated if `hash` is `undefined` or `null`:

<span class="csscript"></span>

    hash ?= {}

##Destructuring assignments

Destructuring assignments can be used with any depth of array and object nesting, to help pull out deeply nested properties.

    someObject = { a: 'value for a', b: 'value for b' }
    { a, b } = someObject
    console.log "a is '#{a}', b is '#{b}'"

##External libraries

Using external libraries is exactly the same as calling functions on CoffeeScript libraries; since at the end of the day everything is compiled down to JavaScript. Using CoffeeScript with [jQuery](http://jquery.com) is especially elegant, due to the amount of callbacks in jQuery's API. 

<span class="csscript"></span>

    # Use local alias
    $ = jQuery

    $ ->
      # DOMContentLoaded
      $(".el").click ->
        alert("Clicked!")
    
Since all of CoffeeScript's output is wrapped in an anonymous function, we can set a local `$` alias for `jQuery`. This will make sure that even if jQuery's no conflict mode is enabled and the `$` re-defined, our script will still function as intended. 
