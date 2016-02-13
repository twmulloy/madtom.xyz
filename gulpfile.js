var gulp = require('gulp'),
  connect = require('gulp-connect'),
  concat = require('gulp-concat'),
  del = require('del'),
  gulpif = require('gulp-if'),
  fileinclude = require('gulp-file-include');

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
    path.bower + '/angular-sanitize/angular-sanitize.js',
    path.bower + '/jquery/dist/jquery.js',
    path.bower + '/slick-carousel/slick/slick.js',
    path.src + '/script.coffee'
  ],
  styles: [
    path.bower + '/slick-carousel/slick/slick.css',
    path.src + '/style.styl'
  ],
  htmls: [
    path.src + '/head.html',
    path.src + '/body.html'
  ]
};

gulp.task('connect', function () {
  connect.server({
    root: path.dist,
    livereload: true
  });
});

gulp.task('html', ['assets'], function () {
  return gulp.src(manifest.htmls)
    .pipe(fileinclude({
      prefix: '@@',
      basepath: path.dist
    }))
    .pipe(min.html({
      removeComments: true,
      collapseWhitespace: true,
      minifyJS: true,
      minifyCSS: true,
      processScripts: ['text/ng-template'] 
    }))
    .pipe(concat('index.html'))
    .pipe(gulp.dest(path.dist))
    .pipe(connect.reload());
});

gulp.task('clean', function () {
  return del([path.dist + '/*'], function (err) {
    if (err) return;
  });
});

gulp.task('build', ['clean', 'html']);

gulp.task('style', function () {
  return gulp.src(manifest.styles)
    .pipe(gulpif(/[.]styl$/, dsl.stylus()))
    .pipe(min.style({}))
    .pipe(concat('style.css'))
    .pipe(gulp.dest(path.dist));
});

gulp.task('script', function () {    
  return gulp.src(manifest.scripts)
    .pipe(gulpif(/[.]coffee$/, dsl.coffee()))
    .pipe(min.script({}))
    .pipe(concat('script.js'))
    .pipe(gulp.dest(path.dist));
});

gulp.task('assets', ['style', 'script']);

gulp.task('watch', function () {
  return gulp.watch([
    path.src + '/*.css',
    path.src + '/*.styl',
    path.src + '/*.js',
    path.src + '/*.coffee',
    path.src + '/*.html'
  ], ['html']);
});

gulp.task('default', ['build', 'connect', 'watch']);