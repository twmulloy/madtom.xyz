# Intial load flag
loaded = false

# Delay helper
delay = do ->
  timer = 0
  (callback, ms=0) ->
    clearTimeout timer
    timer = setTimeout callback, ms
    return

w = do $(window).width

window.onresize = ->
  # Fix for resize trigger mobile scroll
  width = do $(@).width
  return if loaded and width is w
  w = width

  document.body.classList.add 'resize'

  delay ->
    # Slick
    # Fix for dynamic height
    slick = $ '[slick]'
    if slick.slick?
      slick = slick.slick 'getSlick'
      slick.$list.height ''
    document.body.classList.remove 'resize'
  , 500

  return

## Google Fonts
WebFont.load
  google:
    families: [
      'Oswald:700:latin'
      'Dosis:600:latin'
      'Playfair+Display:400,700:latin'
      'Poiret+One::latin'
    ]

  active: ->
    $('h1', '#main .page .content > header').slabText
      fontRatio: 0.25
      minCharsPerLine: 8
      resizeThrottleTime: 250

    do window.onresize.call

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

  opts =
    styles: [
      {
        'featureType': 'all'
        'elementType': 'labels.text.fill'
        'stylers': [{ 'color': '#1b1919' }]
      }
      {
        'featureType': 'all'
        'elementType': 'labels.text.stroke'
        'stylers': [{ 'color': '#fbf9f1' }]
      }
      {
        'featureType': 'all'
        'elementType': 'labels.icon'
        'stylers': [{ 'visibility': 'off' }]
      }
      {
        'elementType': 'geometry'
        'stylers': [{ 'visibility': 'off' }]
      }
      {
        'featureType': 'road'
        'elementType': 'geometry'
        'stylers': [
          { 'visibility': 'on' }
          { 'color': '#1b1919' }
        ]
      }
      {
        'featureType': 'landscape'
        'stylers': [{ 'visibility': 'off' }]
      }
      {}
    ]

  maps = [
    {
      el: document.getElementById 'venue'
      coords: [
        lat: 47.6536064
        lng: -122.3284513
      ]
    },{
      el: document.getElementById 'hyatt8'
      coords: [
        lat: 47.6138053
        lng: -122.3363746
      ]
    },{
      el: document.getElementById 'eats'
      zoom: 12,
      coords: [
        # Shiki
        {
          lat: 47.6258826
          lng: -122.359353
        },
        # Pike Place
        {
          lat: 47.6097271
          lng: -122.3465704
        },
        # RockCreek
        {
          lat: 47.6595047
          lng: -122.3517322
        },
      ]
    },{
      el: document.getElementById 'places'
      zoom: 11,
      coords: [
        # Lake Union
        {
          lat: 47.6336462
          lng: -122.3379969
        },
        # Pike Place
        {
          lat: 47.6097271
          lng: -122.3465704
        },
        # Seattle Center
        {
          lat: 47.622042
          lng: -122.3541892
        },
        # Green Lake
        {
          lat: 47.6778049
          lng: -122.3422588
        },
        # Seattle Ferry Terminal
        {
          lat: 47.6024983
          lng: -122.3401822
        },
        # Sculpture Park
        {
          lat: 47.6165162
          lng: -122.3576973
        },
      ]
    }
   ]

  @maps = {}

  i = 0
  while i < maps.length
    map = maps[i]
    id = map.el.id
    @maps[id] =
      el: map.el
      gmap: new google.maps.Map map.el,
        center: map.coords[0]
        zoom: if map.zoom? then map.zoom else 14
        backgroundColor: 'rgba(0,0,0,0)'
        disableDefaultUI: true
        zoomControl: false
        maxZoom: 16
        minZoom: 10
        styles: opts.styles
      markers: []

    gmap = @maps[id].gmap

    google.maps.event.addListenerOnce gmap, 'idle', ->
      map.el.classList.add 'map-loaded'
      do window.onresize.call

    j = 0
    while j < map.coords.length
      coord = map.coords[j]
      @maps[id].markers.push new google.maps.Marker
        position: coord
        map: gmap
        icon: 'data:image/png;base64,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'
      ++j
    ++i



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
  .module('filters', [])

  .filter('page', [
    '$filter'
    ($filter) ->
      (input, prop, direction) ->
        return unless angular.isArray input
        length = input.length - 1
        current = $filter('filter')(input, current: true)[0]
        return if angular.isUndefined current
        index = input.indexOf current
        next = index + 1
        next = 0 if next > length
        back = index - 1
        back = length if back < 0
        index = if direction is 'back' then back else next
        input[index][prop]
  ])

angular
  .module('controllers', [])

  .controller('body', [
    '$scope'
    '$filter'
    'pages'
    ($scope, $filter, pages) ->
      $scope.pages = pages

      $scope.$watch 'pages', (current, previous) ->
        $scope.page_back = $filter('page') $scope.pages, 'simple', 'back'
        $scope.page_next = $filter('page') $scope.pages, 'simple'
      , true

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
            document.body.classList.remove 'slide'
            $current = $(slick.$slides[current])
            $current.siblings().height do $current.height
            scope.pages[slick.currentSlide].current = true
            do scope.$applyAsync

          $el.on 'init', (e, slick) ->
            after e, slick, slick.currentSlide

          $el.on 'beforeChange', (e, slick, current, next) ->
            document.body.classList.add 'slide'
            slick.$slides.height ''
            scope.pages[slick.currentSlide].current = false

          $el.on 'afterChange', after

          # $el.on 'swipe', (e, slick, direction) ->

          mousemove = (e) ->
            document.body.classList.add 'drag'

          mousedown = (e) ->
            $(@).one('mouseup mouseleave touchend touchcancel', mouseup).on('mousemove touchmove', mousemove)

          mouseup = (e) ->
            $(@).off 'mousemove touchmove'
            document.body.classList.remove 'drag'

          $el.on 'mousedown touchstart', mousedown

          $el.slick
            centerMode: true
            centerPadding: '7.5vw'
            lazyLoad: 'progressive'
            infinite: true
            arrows: false
            speed: 600
            useTransform: true
            cssEase: 'cubic-bezier(0.645, 0.045, 0.355, 1)' # $easeInOutCubic
            adaptiveHeight: true
            mobileFirst: true
            touchThreshold: 3

          el.on 'click touchstart', (e) ->
            element = e.target
            if element.className is 'cover'
              slick = $el.slick 'getSlick'
              current_w = slick.$slides[slick.currentSlide].offsetWidth
              if e.clientX > current_w
                $el.slick 'slickNext'
              else if e.clientX < current_w
                $el.slick 'slickPrev'

              document.body.classList.remove 'hover-next'
              document.body.classList.remove 'hover-back'

          el.on 'mouseover', (e) ->
            element = e.target
            if element.className is 'cover'
              slick = $el.slick 'getSlick'
              current_w = slick.$slides[slick.currentSlide].offsetWidth
              if e.clientX > current_w
                document.body.classList.add 'hover-next'
              else if e.clientX < current_w
                document.body.classList.add 'hover-back'

          el.on 'mouseout', (e) ->
            element = e.target
            if element.className is 'cover'
              document.body.classList.remove 'hover-next'
              document.body.classList.remove 'hover-back'


        $timeout setup

        return
  ])

angular
  .module('app', [
    'ngAnimate'
    'ngSanitize'
    'filters'
    'controllers'
    'directives'
  ])

  .constant('pages', [
    name: 'home'
    simple: 'About'
    title: 'Madeline &amp; Thomas'
    templateUrl: 'home.html'
  ,
    name: 'visitors'
    simple: 'Accommodations'
    title: 'Visiting Seattle'
    templateUrl: 'visitors.html'
  ,
    name: 'registry'
    simple: 'Wedding Registries'
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


window.onload = ->
  loaded = true
