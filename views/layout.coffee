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
#    link rel: 'stylesheet', href: '/scripts/uploadify/uploadify.css'
#    script src:'/modernizr.js'
#    script src:'http://ajax.aspnetcdn.com/ajax/modernizr/modernizr-1.7-development-only.js'
    script src:'/scripts/head.js'
    text @viewsync()
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
      footer id:'scrapbook', -> 'Scrapbook &copy; 2012 Pts'
