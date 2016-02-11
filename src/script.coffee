## Google Fonts
WebFont.load
  google:
    families: [
      'Oswald:400:latin' 
      'Dosis:500:latin'
      'Playfair+Display:400:latin'
    ]

## Google Analytics
((i, s, o, g, r, a, m) ->
  i['GoogleAnalyticsObject'] = r
  i[r] = i[r] or ->
    (i[r].q = i[r].q or []).push arguments
    return

  i[r].l = 1 * new Date
  a = s.createElement(o)
  m = s.getElementsByTagName(o)[0]
  a.async = 1
  a.src = g
  m.parentNode.insertBefore a, m
  return
) window, document, 'script', '//www.google-analytics.com/analytics.js', 'ga'

ga 'create', 'UA-10404219-5', 'auto'
ga 'send', 'pageview'

## Angular
angular.module('controllers', [])
  .controller('body', [
    '$scope'
    ($scope) ->
      console.log 'body controller'
      return
  ])
  .controller('main', [
    '$scope'
    ($scope) ->
      console.log 'main controller'
      return
  ])
    
angular.module('app', [
    'ngAnimate'
    'controllers'
  ]).run([
    '$templateCache'
    ($templateCache) ->
      templates = document.querySelectorAll 'script[type="text/ng-template"]'
      angular.forEach templates, (template) ->
        $templateCache.put template.id, template.innerHTML 
      return
  ])