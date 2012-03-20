vows = require 'vows'
assert = require 'assert'

capture = {}

mock fakes =
  brk : -> #require('brk') in context scope
  
  zappa : (port,fn) -> new -> 
    @get = (rh) ->
      capture.route = rh
      rh['/route'].call(this)
    @render = (v) ->
      capture.view = v
    capture.port = port
    fn.call(this)

  nstore : 
      extend : -> fakes.nstore
      new : (db, fn) -> 
        process.nextTick -> fn()
        fakes.nstore
      find : (q,fn) -> 
        fn()
  
  './lib/nstore.query' : ->
  
sut = require '../myZappa.coffee'
      
vows
  .describe('myZappa')
  .addBatch

    'setup':
      topic: 
        sut 123,"db",-> 
          @nav ['/Route']
          this.callback

       'setup ok': ->
          
  .addBatch

    'accept port':
      topic: -> capture.port
  
      'we get 123': (topic) ->
        assert.equal topic, 123

    'register route':
      topic: -> capture.route
        
      'we get route': (topic) ->
        for r of topic
          assert.equal r, '/route'
          assert.isFunction topic[r]

    'create view':
      topic: -> capture.view
  
      'we get view': (topic) ->
        assert.equal topic.route.id, 'route'

  .run()
  