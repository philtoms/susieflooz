module.exports = (store, view, cb) ->

  page = (k) -> k.indexOf('page/')==0 # filter all pages

  store.find page, (e,d) => 
    data = new store.data d, store.sort
    
    view.data = 
      headerImg: 'chutney'
      articles: data.find (f) -> f.key.indexOf("/topten")<0
      notes: data.first (f) -> f.key.indexOf("/topten")>0

    cb(e)
  