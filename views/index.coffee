id='page/cookery/'+@params.id
head=(@data.find (f) -> f.key==id) || {}
headerImg = head.headerImg ?='chutney'

@title = 'Susieflooz - Personal Scrapbook'
@description = 'My scrapbook blog about food, cooking, gardening and things of note'
@stylesheets = [
  {inline:"
    header {background-image:url(../images/header/#{headerImg}.jpg);}
  "}
]

section id:'articles', ->
  for x in @data[0..10] when x.key.indexOf('topten')<0
    article id:x.key.replace(/\//g,'-'), ->
      x.article

aside id:'notes', ->
  h2 -> "Things of note"
  text (@data.find (f) -> f.key=="page/index/topten")?.article

