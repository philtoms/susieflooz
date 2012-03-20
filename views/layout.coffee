doctype 5
html lang:'en', ->
  head ->
    meta charset:'utf-8'
    meta name:'description', content:@description
    meta name:'keywords', content:@keywords
    #meta name:'viewport', content:'user-scalable=no'
    meta name:'google-site-verification', content:'XP3TLQI7dFpP_gMFBgpGcs0Xamm4ETkYNURfh7OPHwg'
    title @title if @title
    link rel: 'stylesheet', href: 'http://fonts.googleapis.com/css?family=IM+Fell+DW+Pica+SC' 
    link rel: 'stylesheet', href: 'style/basestyle.css'
    link rel: 'stylesheet', href: '/scripts/uploadify/uploadify.css'

#    script src:'/modernizr.js'
    script src:'http://ajax.aspnetcdn.com/ajax/modernizr/modernizr-1.7-development-only.js'
    script src:'https://ajax.googleapis.com/ajax/libs/jquery/1.7.1/jquery.min.js'
    script src:'/socket.io/socket.io.js'
    script src:'/zappa/zappa.js'
    script src:'/scripts/uploadify/jquery.uploadify.min.js'
    script src:'/scripts/uploadify/swfobject.js'
    script src:'./viewsync.js'
    text '''<script>
        articleTemplate = function(id){
          var article = document.createElement("article");
          var header = document.createElement("header");
          var h2 = document.createElement("h2");
          var time = document.createElement("time");
          var div = document.createElement("div");
          var p = document.createElement("p");
          var clear = document.createElement("div");
          article.id=id;
          article.appendChild(header);
          article.appendChild(div);
          article.appendChild(clear);
          header.appendChild(h2);
          header.appendChild(time);
          div.className="body";
          div.appendChild(p);
          h2.className="edit";
          h2.innerHTML = "Title...";
          p.className="left edit";
          p.innerHTML = "Article...";
          time.id=d.toDateString();
          var d = new Date();
          var mmm = ["Jan","Feb","Mar","Apr","May","Jun","Jul","Aug","Sep","Oct","Nov","Dec"];
          time.innerHTML = d.getDate() + " " + mmm[d.getMonth()] + " " + d.getFullYear().toString().substr(2);
          clear.className="clear";
          return article;
        }
        onUpload=function(article,fileName){
          img = "<img class='edit' src='/images/gallery/{name}' />".replace(/{name}/g,fileName);
          $(".body",article).prepend(img);
        }
    </script>''' 

    if @scripts
      for s in @scripts
        if typeof s is 'object'
            text "<script>#{s.inline}</script>" 
        else  
          script(src: s + '.js')
    if @script
      if typeof @script is 'object'
          text "<script>#{@script.inline}</script>" 
      else  
        script(src: @script + '.js')
    if @stylesheets
      for s in @stylesheets
        if typeof s is 'object'
          style s.inline 
        else  
          link rel: 'stylesheet', href: s + '.css'
    link(rel: 'stylesheet', href: @stylesheet + '.css') if @stylesheet
    style @style if @style
    if @iehack
      text '<!--[if lt IE 9]>'
      style @iehack
      text '<![endif]-->'

  body id:@id, ->
    div id:'body', ->
      header ->
        h1 "Issue No #{@data[0].issue}"

      nav ->
        ul ->
          for r in @nav
            li -> 
              a href:r.toLowerCase(), -> @toTitle(r,'Articles')
              
      text @body
        
      footer 'Scrapbook &copy; 2012 Pts'
    script src: @tailscript + '.js' if @tailscript
