@title = 'Susieflooz - Personal Scrapbook'
@description = 'My scrapbook blog about food, cooking, gardening and things of note'

@stylesheets = [
  {inline:'''
  '''}
]

section id:'articles', ->
  for x in @data[0..10] when x.key.indexOf('issue')>0
    article id:x.key.split('/')[1], ->
      x.article

aside id:'notes', ->
  h2 -> "Things of note"
  ul -> (@data.find (f) -> f.key=="index/topten")?.article

