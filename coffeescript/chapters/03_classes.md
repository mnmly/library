<div class="back"><a href="index.html">&laquo; 目次に戻る</a></div>

#クラス

JavaScriptにおけるクラスは、多くの人が敬遠しがちなコンセプトですが、あなたがこのCoffeeScriptの本を読んでいる限り、それに対する偏見はそれほど強くないと言えるでしょう。クラスは他の言語と同様にJavaScriptでも非常に便利なものでCoffeeScriptはすばらしい構文でクラスを作る事が出来ます。

CoffeeScriptはJavaScriptの `prototype` を使ってクラスが作られています。静的なプロパティとコンテクストの維持に関して簡単な構文も用意されています。簡単なクラスの生成に用意されているのは `class` キーワードです。

<span class="csscript"></span>

    class Animal
    
上の例では `Animal` はクラス名で、インスタンスを作るときに用いる名前となります。CoffeeScriptでクラスからインスタンスを作るには `new` キーワードを使い、この時にコンストラクタが呼び出されます。

<span class="csscript"></span>

    animal = new Animal

コンストラクタ(インスタンスが生成されるときに呼ばれる関数)を定義するには、シンプルに `constructor` という名前に関数を作るだけです。Rubyの `initialize` やPythonの `__init__` と同じようなものだとお考えください。

<span class="csscript"></span>

    class Animal
      constructor: (name) ->
        @name = name

実際にはCoffeeScriptはインスタンスのプロパティの設定には、共通のパターンが用意されています。 `@` を付けることでその変数はインスタンスのプロパティになり、引数に直接 `@` を付けてもまた同様です。クラスの生成の時だけでなく、普通の関数に対してもこのテクニックが使えます。下の例は上の例と結果は同じですが、今回はインスタンスプロパティを引数から直接設定しています。

<span class="csscript"></span>

    class Animal
      constructor: (@name) ->

お分かりだと思いますが、クラスの生成時に渡された引数はすぐにこのコンストラクタに渡されます。

<span class="csscript"></span>

    animal = new Animal("Parrot")
    alert "Animal is a #{animal.name}"

##インスタンスプロパティ

クラスに新たなインスタンスプロパティを追加するのも非常に簡単で、オブジェクトにプロパティを追加するのと全く同じ構文です。クラスに対して、きちんとインデントすることだけ注意しましょう。

<span class="csscript"></span>

    class Animal
      price: 5

      sell: (customer) ->
        
    animal = new Animal
    animal.sell(new Customer)

コンテクストの変更はJavaScriptでは頻繁に起こりますが、前回の構文の節でふれたように、CoffeeScriptではふとっちょ矢印 ( `=>` ) を使う事で `this` を特定のコンテクストに固定する事ができます。これによって、この関数のコンテクストは常に、その関数が作られたときのコンテクストを維持してくれます。CoffeeScriptのクラスではこのふとっちょ矢印の動作がすこし拡張され、インスタンスメソッドにふとっちょ矢印を使うとその `this` は現在のインスタンスに固定されます。 
    
<span class="csscript"></span>

    class Animal
      price: 5

      sell: =>
        alert "Give me #{@price} shillings!"
        
    animal = new Animal
    $("#sell").click(animal.sell)
    
上の例のように、このテクニックはイベントのコールバックに非常に便利です。普通 `sell()` のコンテクストは `#sell` エレメントをコンテクストとして設定されてしまいます。しかし、ふとっちょ矢印をつかうことで `sell()` のコンテクストは常にそのインスタンスに維持され、 `this.price` もインスタンスプロパティである `5` となります。

##静的プロパティ

それでは、クラスプロパティ(静的プロパティ)はどうでしょう？クラスの定義の中で `this` はクラスオブジェクトを参照しているので、つまりクラスプロパティを設定するには `this` に直接設定してやればいいのです。

<span class="csscript"></span>

    class Animal
      this.find = (name) ->      

    Animal.find("Parrot")
    
また、CoffeeScriptでは `this` のエイリアスとして `@` が用意されているので、もっと簡単にこのように書く事も出来ます。
    
<span class="csscript"></span>

    class Animal
      @find: (name) ->
      
    Animal.find("Parrot")

##継承とスーパー

継承の機能なくして、きちんとしたクラスとは言えません。CoffeeScriptはそこもきちんとカバーしています。継承をするには `extends` キーワードを使います。下の例では、 `Parrot` は `Animal` から継承しています。

<span class="csscript"></span>

    class Animal
      constructor: (@name) ->
      
      alive: ->
        false

    class Parrot extends Animal
      constructor: ->
        super("Parrot")
      
      dead: ->
        not @alive()

ここでは `super()` キーワードを使っています。どのようにこれが機能しているかというと、クラスの親の `prototype` に対して関数を呼び出しているので、現在のコンテクストが使われています。つまり、この例では、 `Parrot.__super__.constructor.call(this, "Parrot");` が呼ばれていることになります。実際には RubyやPythonの `super` と全く同じ機能を果たしていると言えます。

`constructor` をオーバーライドしない限り、CoffeeScriptはインスタンス生成時に、デフォルトで親のコンストラクタを呼び出します。

CoffeeScriptはプロトタイプの継承を使って自動的にクラスのインスタンスプロパティへと変換します。これによってクラスが常にダイナミックで、たとえ子のクラスが作られた後に、親のクラスに新しいプロパティを追加したとしても、これを親としている全ての子クラスにこのプロパティは反映されます。

<span class="csscript"></span>

    class Animal
      constructor: (@name) ->
      
    class Parrot extends Animal
    
    Animal::rip = true
    
    parrot = new Parrot("Macaw")
    alert("This parrot is no more") if parrot.rip

ここで注意すべきなのは、静的プロパティはインスタンスプロパティのようにプロトタイプを用いて継承されているのではなく、サブクラスにコピーされています。 これは、JavaScriptそのもののアーキテクチャと実装の特性であり、この問題を回避する事は非常に難しい課題となっています。

##Mixins

[Mixins](http://ja.wikipedia.org/wiki/Mixin)はCoffeeScriptでネイティブにサポートされている訳ではありませんが、下の例のように簡単に実装する事が可能です。<!-- For example, here's two functions, `extend()` and `include()` that'll add class and instance properties respectively to a class.-->

<span class="csscript"></span>

    extend = (obj, mixin) ->
      obj[name] = method for name, method of mixin        
      obj

    include = (klass, mixin) ->
      extend klass.prototype, mixin
    
    # Usage
    include Parrot,
      isDeceased: true
      
    (new Parrot).isDeceased
    
Mixinsは継承が適切ではないときに、モジュール間での共通のロジックを共有するのに優れたパターンです。一つのクラスしか追加できない継承に対して、複数のMixinを追加すことができる点はこのパターンの長所と言えます。
