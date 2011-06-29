<!DOCTYPE html>
<html>
<head>
<meta charset=utf-8>
<meta name="description" content="ちっちゃいCoffeeScriptの本">
<meta name="keywords" content="coffeescript,javascript,book,tutorials">
<title>ちっちゃいCoffeeScriptの本</title>
<link rel="stylesheet" href="site/site.css" type="text/css" charset="utf-8">
<script src="site/jquery.js" type="text/javascript" charset="utf-8"></script>      
</head>
<body>
<div id="container">
  <header>
    <h1><a href="index.html">ちっちゃいCoffeeScriptの本</a></h1>
  </header>
  
  <div id="content">
    <ol class="pages">
    {{#pages}}
      <li><a href="{{href}}">{{name}}</a></li>
    {{/pages}}
    </ol>
  </div>
</div>
</body>
</html>
