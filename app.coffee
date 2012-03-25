susieflooz = (port) ->
 require('./myZappa') port, 'blog.db', ->

  @io.set 'log level', 1
  app = this

  @nav [
    '/': (k) -> k.indexOf('page/')==0 # filter all pages
    '/Cookery'
    '/Gardening'
    '/ContactMe'
    ]
    ,(s1,s2) -> 
      Date.parse(s2.date) - Date.parse(s1.date)

  @post '/sendform' : ->
    require('./lib/sendmail').send.call(this, @request,app.data.email)
    @redirect '/'
 
  @js '/googlea.js': '''
      var _gaq = _gaq || [];
    _gaq.push(['_setAccount', googleId]);
    _gaq.push(['_trackPageview']);
  
    (function() {
      var ga = document.createElement('script'); ga.type = 'text/javascript'; ga.async = true;
      ga.src = ('https:' == document.location.protocol ? 'https://ssl' : 'http://www') + '.google-analytics.com/ga.js';
      var s = document.getElementsByTagName('script')[0]; s.parentNode.insertBefore(ga, s);
    })();
  '''

module.exports = susieflooz
