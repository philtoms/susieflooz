myZappa = (port,db,app) -> 

 # wrap zappa with extras, then run app in 'myZappa' context

 #helpers to convert a route to text, and then from camelCase to spaced words
 toRoute = (r) -> if (s=r.toLowerCase().split(':')).length==1 
                    '/'+s[0]+'/' 
                  else 
                    if s[1]=='index' then '/' else '/'+s[1]+'/'
 toName  = (r) -> if (s=r.toLowerCase().split(':')).length==1 then s[0] else s[1]
 toTitle = (r) -> r.split(':')[0].replace(/([A-Z])/g, (m)->' '+m.toLowerCase())
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
    models = 
      default: (require './models/default') || (store, route, cb) ->
        if cb
          store.find store.page, (e,d) -> cb(e,d)

    models.default @store
    
    @store.get 'app', (err,data) =>
      if (err) then console.log err.toString()
      @data = appData = data
      @include './lib/viewsync' 
      viewsync = @viewsync
  
    @nav = (routes) ->
      for t,i in routes
        routes[i] = 
          route: toRoute t
          name:  toName t
          title: toTitle t

        r=routes[i]
        do(r) =>
          
          try
            model = models[r.name] = (require './models/'+r.name) || models.default
          catch err
            model = models.default
          
          #use this syntax to get a variable into a key
          routeHandler = {} 
          routeHandler[r.route+':id([0-9]+)?'] = ->
            view = {}
            view[r.name] =
              params: @params
              route: r.name
              routes: routes
              appData: appData
              viewsync: viewsync

            model store, view[r.name], (err) =>
              if (err) then console.log err.toString()
              @render view
            
          @get routeHandler
           
    # apply 'zappa' context here
    app.apply(this)
    
zappa = require('zappa')
return module.exports = myZappa