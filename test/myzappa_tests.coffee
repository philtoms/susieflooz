vows = require 'vows'
assert = require 'assert'

capture = {}

mock fakes =
  zappa : (port,fn) -> new -> 
    @include = ->
    @use = ->
    @app = {}
    @params = {}
    @express =
      bodyParser: -> 
    @get = (rh) =>
      capture.route = rh
      for r of rh
        @params.id = r.split('/')[0]
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

    'register route':
      topic: -> capture.route
        
      'we get test/1': (topic) ->
        for r of topic
          assert.equal r, '/test/:id?'
          assert.isFunction topic[r]

    'create view':
      topic: -> capture.view
  
      'we get view': (topic) ->
        assert.equal topic.test.route, 'test'

  .run()
  