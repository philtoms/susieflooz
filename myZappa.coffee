myZappa = (port,db,app) -> 

 # wrap zappa with extras, then run app in 'myZappa' context

 #helpers to convert a route to text, and then from camelCase to spaced words
 toText = (r,t) -> if r=='/' then t else r.substr(1)
 toTitle = (r,t) -> toText(r,t).replace(/([A-Z])/g, (m)->' '+m.toLowerCase())
                               .replace(/^../, (m)->m.substr(1).toUpperCase())

 nstore = require('./lib/nstore').extend(require('./lib/nstore/query')()).new db, ->
  
  zappa port, -> # passes this fn to zappa.run
    store = @store = 
      find: (k,cb) -> nstore.find k,cb
      get: (k,cb) -> nstore.get k,cb
      data: require('./lib/data')
        
    @root = __dirname
    @data = null
    viewsync = null
    appData = null
    controllers = 
      default: (require './controllers/default') || (store, route, cb) ->
        if cb
          store.find store.page, (e,d) -> cb(e,d)

    controllers.default @store
    
    @store.get 'app', (err,data) =>
      if (err) then console.log err.toString()
      @data = appData = data
      @include './lib/viewsync' 
      viewsync = @viewsync
  
    @nav = (routes) ->
      for i, r of routes
        do(i,r) =>
          r = r.toLowerCase()
          route = toText r,'index'

          try
            ctrlr = controllers[route] = (require './controllers/'+route) || controllers.default
          catch err
            ctrlr = controllers.default
          
          #use this syntax to get a variable into a key
          routeHandler = {} 
          routeHandler[r+'/:id?'] = ->

            view = {}
            view[route] =
              params: @params
              route: route
              routes: routes
              appData: appData
              toTitle: toTitle
              viewsync: viewsync

            ctrlr store, view[route], (err) =>
              if (err) then console.log err.toString()
              @render view
            
          @get routeHandler
           
    # apply 'zappa' context here
    app.apply(this)
    
zappa = require('zappa')
return module.exports = myZappa