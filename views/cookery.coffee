@title = 'Cookery - Susieflooz'
@description = 'Cookery musings and a whole lot of recepies'

@stylesheets = [
  {inline:'''
    header {background-image:url(../images/header/peppers.jpg);}
  '''}
]

section id:'articles', ->
  for x in @data[0..10] when x.key.indexOf('issue')>0
    article id:x.key.split('/')[1], ->
      x.article

aside id:'notes', ->
  h2 -> "Things of note"
  ul -> (@data.find (f) -> f.key=="cookery/topten")?.article
