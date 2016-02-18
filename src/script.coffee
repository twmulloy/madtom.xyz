## Google Fonts
WebFont.load
  google:
    families: [
      'Oswald:400,700:latin' 
      'Dosis:400,500,700:latin'
      'Playfair+Display:400,700:latin'
    ]
    
  active: ->
  
    $('h1', '#main .page .content > header').slabText
      fontRatio: 0.25
      maxFontSize: 128
      minCharsPerLine: 6
      resizeThrottleTime: 50
      
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

## Google Maps
window.gmap = ->
  @maps = 
    venue: new google.maps.Map document.getElementById('venue'),
      center:
        lat: 47.6536064
        lng: -122.3284513
      zoom: 15
      
  google.maps.event.addListenerOnce @maps.venue, 'idle', ->
    $(window).trigger 'resize'

  return


((i, s, o, g, r, a, m) ->
  a = s.createElement(o)
  m = s.getElementsByTagName(o)[0]
  a.async = 1
  a.defer = 1
  a.src = "#{g}?key=#{r}&callback=gmap"
  m.parentNode.insertBefore a, m
  return
) window, document, 'script', '//maps.googleapis.com/maps/api/js', 'AIzaSyCz4VPG2h30MSBb6drUPG_OkTcLFtT1i0U'

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
    ($timeout) ->
      restrict: 'A'
      scope:
        pages: '='
      link: (scope, el, attrs) ->

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
            centerPadding: '7.5vw'
            lazyLoad: 'ondemand'
            infinite: true
            arrows: false
            speed: 600
            useTransform: true
            cssEase: 'cubic-bezier(0.645, 0.045, 0.355, 1)' # $easeInOutCubic
            adaptiveHeight: true
            mobileFirst: true
            # variableWidth: false  
              
          el.on 'click', (e) ->
            element = e.target
            if element.className is 'cover'
              slick = $el.slick 'getSlick'
              current_w = slick.$slides[slick.currentSlide].offsetWidth
              if e.clientX > current_w
                $el.slick 'slickNext'
              else if e.clientX < current_w
                $el.slick 'slickPrev'
  
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
  
  
delay = do ->
  timer = 0
  (callback, ms) ->
    clearTimeout timer
    timer = setTimeout(callback, ms)
    return
    
gmaps = ->
  # Google Maps
  # Fix for map not rendering in n > 1 column (Chrome)
  maps = document.querySelectorAll "#venue"
  i = 0
  while i < maps.length
    map = maps[i]
    gmap = @maps[map.id]
    
    clone = document.getElementById "#{map.id}-clone"
    unless clone
      clone = map.cloneNode false
      clone.id += '-clone'
      clone.classList.add 'map-clone'
      clone.style.display = 'inline-block'
      map.parentNode.insertBefore clone, map
      
    style = window.getComputedStyle clone
    rect = do clone.getBoundingClientRect
    o_left = clone.parentNode.parentNode.parentNode.getBoundingClientRect().left
    o_top = window.pageYOffset - parseInt style.marginTop, 10

    container = document.getElementById "#{map.id}-container"
    unless container
      container = document.createElement map.tagName
      container.id = "#{map.id}-container"
      container.classList.add 'map-container'
      container.style.position = 'absolute'
      container.style.overflow = 'hidden'
      map.style.margin = 0
      map.style.padding = 0
      map.style.width = '100%'
      map.style.height = '100%'
      map.parentNode.insertBefore container, map
      container.appendChild map

    container.style.width = style.width
    container.style.height = style.height
    container.style.top = rect.top + o_top + 'px'
    container.style.left = rect.left - o_left + 'px'
    
    # Refresh Google Map
    center = do gmap.getCenter
    google.maps.event.trigger gmap, 'resize'
    gmap.setCenter center
    
    ++i
    
$(window).on 'resize', (e) -> 

  document.body.classList.add 'resize'
  
  delay ->
    # Slick
    # Fix for dynamic height
    slick = $('[slick]').slick 'getSlick'
    slick.$list.height ''

    do gmaps
    
    document.body.classList.remove 'resize'
    
  , 100