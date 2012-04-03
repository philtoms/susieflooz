module.exports = (store, view, cb) ->
  # default sort and page key...
  page = 'page/'+view?.route
  store.sort = ( s1,s2) -> Date.parse(s2.date) - Date.parse(s1.date)
  store.page = (key) -> key.indexOf(page)==0 

  if !cb then return
  
  defaultHeaderImg = 
    cookery:'peppers'
    gardening:'gardenwall'
    
  store.find store.page, (e,d) ->
    data = new store.data d, store.sort
    
    id=page+'/'+view.params.id
    head=(data.first (f) -> f.key==id) || {}
    headerImg = head.headerImg ?= defaultHeaderImg[view.route] ?='chutney'

    view.data = 
      headerImg: headerImg
      articles: data.find (f) -> f.key.indexOf(page+"/topten")<0
      notes: data.first (f) -> f.key==page+"/topten"

    cb(e)
  