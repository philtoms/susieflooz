vows = require 'vows'
assert = require 'assert'

capture = {}

mock fakes =
  zappa : (port,fn) -> new -> 
    capture.app = this

    @include = ->
    @use = ->
    @app = {}
    @params = {}
    @express =
      bodyParser: -> 
    @get = (rh) ->
      capture.app.params.id=1
      for r of rh
        capture.routeHandler = rh
        rh[r].call(this)
    @render = (v) ->
      capture.view = v
    capture.port = port
    fn.call(this)

  './lib/data': -> {}

  nstore: -> fakes['./lib/nstore']
  './lib/nstore' : 
      extend : -> fakes.nstore()
      new : (db, fn) -> 
        process.nextTick -> fn()
        fakes.nstore()
      get : (key, fn) ->
        fn()
      find : (q,fn) -> 
        fn()
  
  './lib/nstore/query' : ->
  
sut = require '../myZappa.coffee'
      
vows
  .describe('myZappa')
  .addBatch

    'setup':
      topic: 
        sut 123,"db",-> 
          @nav ['/Test']
          this.callback

       'setup ok': ->

  .addBatch

    'accept port':
      topic: -> capture.port
  
      'we get 123': (topic) ->
        assert.equal topic, 123

    'register route handler':
      topic: -> capture.routeHandler
        
      'Should register function keyed by route': (topic) ->
        for r of topic
          assert.equal r, '/test/:id?'
          assert.isFunction topic[r]

    'route to view':
      topic: -> capture.view
      
      'should create view model for route': (topic) ->
        assert.equal topic.test.route, 'test'
        assert.equal topic.test.routes[0], '/Test'
        assert.equal topic.test.params.id, 1
        
    'a camelCase route': 
      topic: -> capture.view.test.toTitle("/ACamelCaseView")
    
      'should generate a title with leading Capital and spaces': (topic) ->
        assert.equal topic, 'A camel case view'
  .run()
  