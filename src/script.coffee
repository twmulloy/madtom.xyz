## Google Fonts
WebFont.load

  google:
    families: [
      'Oswald:400,700:latin' 
      'Dosis:400,500,700:latin'
      'Playfair+Display:400,700:latin'
    ]
    
  active: ->
    $(window).trigger 'resize'

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
angular
  .module('controllers', [])
  
  .controller('body', [
    '$scope'
    '$filter'
    'pages'
    ($scope, $filter, pages) ->
      $scope.pages = pages
      return
  ])
  
angular
  .module('directives', [])
  
  .directive('slick', [
    '$timeout'
    '$window'
    ($timeout, $window) ->
      restrict: 'A'
      scope:
        pages: '='
      link: (scope, el, attrs, ctrl) ->
      
        delay = do ->
          timer = 0
          (callback, ms) ->
            clearTimeout timer
            timer = setTimeout(callback, ms)
            return
      
        setup = ->
      
          $el = $(el)
          
          # Slick methods
          after = (e, slick, current) ->
            $current = $(slick.$slides[current])
            $current.siblings().height do $current.height 
            
          $el.on 'init', (e, slick) ->
            after e, slick, slick.currentSlide
            
          $el.on 'beforeChange', (e, slick, current, next) ->
            slick.$slides.height ''
     
          $el.on 'afterChange', after
          
          # $el.on 'swipe', (e, slick, direction) ->

          $el.slick
            centerMode: true
            centerPadding: '10vw'
            lazyLoad: 'ondemand'
            infinite: true
            arrows: false
            speed: 600
            useTransform: true
            cssEase: 'cubic-bezier(0.645, 0.045, 0.355, 1)' # $easeInOutCubic
            adaptiveHeight: true
            mobileFirst: true
            
          $($window).on 'resize', (e) ->
            delay ->
              slick = $el.slick 'getSlick'
              slick.$list.height ''
            , 100
            
        $timeout setup

        return
  ])

angular
  .module('app', [
    'ngAnimate'
    'ngSanitize'
    'controllers'
    'directives'
  ])
 
  .constant('pages', [
    name: 'home'
    title: 'Madeline &amp; Thomas'
    templateUrl: 'home.html'
  ,
    name: 'visitors'
    title: 'Visiting Seattle'
    templateUrl: 'visitors.html'
  ,
    name: 'registry'
    title: 'Registries'
    templateUrl: 'registry.html'
  ])
  
  .config([
    ->
      return
  ])
  
  .run([
    '$templateCache'
    ($templateCache) ->
      templates = document.querySelectorAll 'script[type="text/ng-template"]'
      angular.forEach templates, (template) ->
        $templateCache.put template.id, template.innerHTML 
      return
  ])