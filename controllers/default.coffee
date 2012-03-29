module.exports = (store, view, cb) ->
 
  # default sort and page key...
  store.sort = ( s1,s2) -> Date.parse(s2.date) - Date.parse(s1.date)
  store.page = (key) -> key.indexOf('page/'+view.route)==0 

  if cb
    store.find store.page, (e,d) ->
      view.data = new store.data d, store.sort
      cb(e)
  