module.exports = (store, view, cb) ->

  page = (k) -> k.indexOf('page/')==0 # filter all pages

  store.find page, (e,d) => 
    view.data = new store.data d, store.sort
    cb(e)
  