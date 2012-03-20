@include = ->
  rename = require('fs').rename
  @on 'connection': ->
    console.log 'connect' 
 
  root=@root
  @post '/upload' : ->
    file = @request.files.Filedata
    dest = root+'/public/images/'+(@body.path ? '')+file.name
    console.log dest
    rename root+'/'+file.path, dest
    @send('Success!')

  store = @store
  @on sync: ->
    data = @data
    store.get @data.id, (e,d,k) ->
      if !d || d.article!=data.article
        store.save data.id,{article:data.article,date:data.date},->
          console.log "updated " + data.id

  @client '/viewsync.js': ->
    io = this
    @connect()
    $ ->

      cmdBar = $("<div id='cmdbar'><input id='file_upload' name='file_upload' type='file'><a href='#new'>New article</a><a href='#save'>Save this article</a><a href='#cancel'>Cancel</a></div>");
      cmdBar.hide().appendTo('body')

      savedRange=false
      saveSelection = ->
        if window.getSelection
          savedRange = window.getSelection().getRangeAt(0)
        else if document.selection #ie
          savedRange = document.selection.createRange()

      restoreSelection = (area) ->
        if !savedRange 
          area.focus()
          saveSelection()
        area.focus()
        if savedRange != null
          if window.getSelection
            s = window.getSelection()
            if s.rangeCount > 0 
                s.removeAllRanges()
            s.addRange(savedRange)
          else 
            if document.createRange
              window.getSelection().addRange(savedRange);
            else 
              if document.selection #ie
                savedRange.select()
                
        savedRange=false

      viewsync = new class

        $('#file_upload').uploadify
          'uploader'  : '/scripts/uploadify/uploadify.swf'
          'script'    : '/upload'
          'cancelImg' : '/scripts/uploadify/cancel.png'
          'scriptData': 'path':'gallery/'
          'auto'      : true
          'onComplete':(event, ID, fileObj, response, data) ->
            contentEdit true
            onUpload(article,fileObj.name)
      
        left=37
        up=38
        right=39
        down=40
        inEdit=false
        article=null
        articleDate=null
        section=null
        empty=''
        unchanged=''
        focusTag={};
        root=$('body')[0].id

        toggle: (e) ->
          if e.altKey or inEdit

            e.preventDefault()

            focusTag[e.target.tagName]=$ e.target
            
            if e.altKey && !inEdit
              saveSelection()
              article=$(e.target).closest('article')
              section = article.closest("section")
              unchanged = article.html()
              article.before cmdBar.show()
              contentEdit true
              inEdit=true;
              
        command: (e) ->
          switch e.target.href?.split('#')[1]
            when "save"
              contentEdit false
              io.emit sync: {id:root+'/'+article[0].id,article:article.html(),date:articleDate} 
              
            when "cancel"
              if article.html() == empty
                article.remove()
              else
                article.html(unchanged)
              contentEdit false          

            when "new"
              contentEdit false
              id = section.find("article").length+1
              section.prepend articleTemplate id
              article = $("#"+id)
              article.before cmdBar.show()
              $('html, body').animate({scrollTop:article.offset().top,500}, =>
                  contentEdit true
                  empty = article.html()
              )

          return false;
          
        move: (e) ->
          if focusTag.IMG 
            float=false
            switch e.keyCode
              when left then float = {float:"left"}
              when right then float = {float:"right"}
              else focusTag={}
            if float
              focusTag.IMG.css(float).focus().click()
              e.preventDefault()
                
        contentEdit = (editable) ->
          edit = article.find(".edit")
          if editable
            edit.attr("contentEditable",true)
            articleDate = article.find("time")[0].id;
            restoreSelection edit
          else
            edit.removeAttr("contentEditable")
            inEdit=false
            cmdBar.hide()

    #events
      $('body').click (e) -> viewsync.toggle e
      $('#cmdbar').click (e) -> viewsync.command e
      $('body').keypress (e) -> viewsync.move e
      