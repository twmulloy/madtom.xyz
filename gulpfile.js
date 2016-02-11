var gulp = require('gulp'),
  connect = require('gulp-connect'),
  concat = require('gulp-concat'),
  del = require('del'),
  gulpif = require('gulp-if');

var min = {
  script: require('gulp-uglify'),
  style: require('gulp-cssnano'),
  html: require('gulp-htmlmin')
};

var dsl = {
  stylus: require('gulp-stylus'),
  coffee: require('gulp-coffee')
};

var path = {
  src: './src',
  dist: './dist',
  bower: './bower_components'
};

var manifest = {
  scripts: [
    path.bower + '/webfontloader/webfontloader.js',
    path.bower + '/angular/angular.js',
    path.bower + '/angular-animate/angular-animate.js',
    path.src + '/script.coffee'
  ],
  styles: [
    path.src + '/style.styl'
  ],
  htmls: [
    path.src + '/head.html',
    path.src + '/body.html'
  ]
};

gulp.task('connect', function () {
  connect.server({
    root: [path.src, path.dist],
    livereload: true
  });
});

gulp.task('script', function () {
  var opts = {}

  return gulp.src(manifest.scripts)
    .pipe(gulpif(/[.]coffee$/, dsl.coffee()))
    .pipe(min.script(opts))
    .pipe(concat('script.js'))
    .pipe(gulp.dest(path.dist))
    .pipe(connect.reload());
});

gulp.task('style', function () {
  var opts = {};

  return gulp.src(manifest.styles)
    .pipe(dsl.stylus())
    .pipe(min.style(opts))
    .pipe(concat('style.css'))
    .pipe(gulp.dest(path.dist))
    .pipe(connect.reload());
});

gulp.task('html', function () {
  // https://github.com/kangax/html-minifier#options-quick-reference
  var opts = {
    removeComments: true,
    collapseWhitespace: true,
    minifyJS: true,
    minifyCSS: true,
    processScripts: ['text/ng-template']
  };

  return gulp.src(manifest.htmls)
    .pipe(min.html(opts))
    .pipe(concat('index.html'))
    .pipe(gulp.dest(path.dist))
    .pipe(connect.reload());
});

gulp.task('watch', function () {
  gulp.watch([
    path.src + '/*.js',
    path.src + '/*.coffee'
  ], ['script']
    );
  gulp.watch([
    path.src + '/*.css',
    path.src + '/*.styl'
  ], ['style']
    );
  gulp.watch([
    path.src + '/*.html'
  ], ['html']);
});

gulp.task('clean', function () {
  return del([path.dist + '/*'], function (err) {
    if (err) return;
  });
});

gulp.task('build', ['clean', 'script', 'style', 'html']);

gulp.task('default', ['build', 'connect', 'watch']);