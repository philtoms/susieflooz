myZappa = (port,db,app) -> 

 # wrap zappa with extras, then run app in 'myZappa' context

 #helpers to convert a route to text, and then from camelCase to spaced words
 toText = (r,t) -> if r=='/' then t else r.substr(1)
 toTitle = (r,t) -> toText(r,t).replace(/([A-Z])/g, (m)->' '+m.toLowerCase())
                               .replace(/^../, (m)->m.substr(1).toUpperCase())

 data = require('./lib/data')
 store = require('./lib/nstore').extend(require('./lib/nstore/query')()).new db, ->
  
  zappa port, -> # passes this fn to zappa.run
    
    @use @express.bodyParser({uploadDir:'./public/uploads'}), @app.router, 'static', 'cookies'
 
    @store = store

    @nav = (routes, sort) ->
      for i, r of routes
        do(i,r) =>
          if typeof r is 'object'
            for k,v of r
              r = k
              page = v
          else page = null

          routes[i]=r
          r = r.toLowerCase()

          routeHandler = {} #use this syntax to get a variable into a key
          
          routeHandler[r] = ->
            id = toText r,'index'
            page ?= (key) -> key.indexOf(id)==0
            
            store.find page, (e,d) =>
              if (e) then console.log e.toString()
              view = {}
              view[id] =
                id: id
                data: new data d, sort
                tailscript: '/googlea'
                nav: routes
                toTitle: toTitle
              
              @render view
            
          @get routeHandler
           
    # apply 'zappa' context here
    app.apply(this)
    
zappa = require('zappa')
return module.exports = myZappa