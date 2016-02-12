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
angular
  .module('controllers', [])
  
  .controller('body', [
    '$scope'
    'pages'
    ($scope, pages) ->
    
      $scope.pages = pages
      
      # Build pages array to 3 items
      if pages.length is 1
        $scope.pages.push angular.copy pages[0]
        
      if pages.length is 2
        $scope.pages.unshift angular.copy pages[pages.length-1]
        
      if pages.length > 2
        $scope.pages.unshift do $scope.pages.pop
        
      $scope.page_change = (change) ->
        return if change is 0
        
        if change < 0
          $scope.pages.unshift do $scope.pages.pop
        else if change > 0
          $scope.pages.push do $scope.pages.shift
          
        $scope.$applyAsync ->
          console.log 'changed page'

      $scope.$on 'page:change', (e, page) ->
        index = $scope.pages.indexOf page
        change = index-1
        $scope.page_change(change)
      
      return
  ])
  
angular
  .module('directives', [])
  
  .directive('pageAnchor', [
    ->
      restrict: 'A'
      scope:
        page: '='
      link: (scope, el, attrs) ->
        el[0].addEventListener 'click', ->
          scope.$emit 'page:change', scope.page
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