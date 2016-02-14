## Google Fonts
WebFont.load
  google:
    families: [
      'Oswald:400,700:latin' 
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
angular
  .module('controllers', [])
  
  .controller('body', [
    '$scope'
    '$filter'
    'pages'
    ($scope, $filter, pages) ->
      $scope.pages = pages
      
      $scope.nav_pages = []
      
      if angular.isArray pages
        $scope.nav_pages = angular.copy pages
        
      if $scope.nav_pages.length is 1
        $scope.nav_pages.push angular.copy pages[0]
        
      if $scope.nav_pages.length is 2
        $scope.nav_pages.push angular.copy pages[1]
        
      if $scope.nav_pages.length > 2
        $scope.nav_pages.unshift do $scope.nav_pages.pop
      
      rotate = (arr, change) ->
        return if change is 0
        
        if change is -1
          arr.unshift do arr.pop
        else if change is 1
          arr.push do arr.shift 
          
        do $scope.$apply
      
      $scope.$on 'nav:rotate', (e, direction) ->
        return unless direction is 'right' or direction is 'left'
        rotate $scope.nav_pages, if direction is 'right' then -1 else 1
      
      $scope.$on 'nav:change', (e, scope) ->
        rotate $scope.nav_pages, scope.$index - 1
    
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
      # controller:  [
      #   '$scope'
      #   ($scope) ->
      #     return
      # ]
      link: (scope, el, attrs, ctrl) ->
       
        # Slick methods
        
        $(el).on 'swipe', (e, slick, direction) ->
          scope.$emit 'nav:rotate', direction

        # $(el).on 'beforeChange', (e, slick, current, next) ->
        #   console.log 'before', arguments 
         
        # $(el).on 'afterChange', (e, slick, current) ->
        #   console.log 'after', arguments
          
        next = ->
          $(el).slick 'slickNext'
          
        scope.$on 'slick:next', next
          
        back = ->
          $(el).slick 'slickPrev'
          
        scope.$on 'slick:back', back
          
        go = (e, index) ->
          $(el).slick 'slickGoTo', index
          
        scope.$on 'slick:go', go
            
        # Custom helpers
        scope.$on 'slick:anchor', (e, anchor_scope) ->
          if anchor_scope.$index is 0
          	do back
          else if anchor_scope.$index is 2
            do next
            
        $timeout ->
          $(el).slick
            centerMode: true
            centerPadding: '8%'
            lazyLoad: 'ondemand'
            infinite: true
            arrows: false
            speed: 500
            useTransform: true
            cssEase: 'cubic-bezier(0.645, 0.045, 0.355, 1)' # $easeInOutCubic
            
            
        return
  ])
  
  .directive('slickAnchor', [
    '$timeout'
    ($timeout) ->
      restrict: 'A'
      link: (scope, el, attrs) ->
        el.on 'click', (e) ->
          scope.$root.$broadcast 'slick:anchor', scope
          scope.$emit 'nav:change', scope

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
  ,
    name: 'contact'
    title: 'Contact'
    templateUrl: 'contact.html'
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