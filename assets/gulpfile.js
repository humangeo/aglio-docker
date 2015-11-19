// gulpgile.js --- Provides targets for fetching static assets for use w/Aglio's default theme.
var path = require("path");
var gulp = require('gulp');
var googleWebFonts = require('gulp-google-webfonts');

var _target = path.join('.', 'googlewebfonts');

gulp.task('fonts', function () {
  return gulp.src('./fonts.list')
    .pipe(googleWebFonts({
      fontsDir: 'fonts',
      cssFilename: 'googlewebfonts.css'
    }))
    .pipe(gulp.dest(_target));
});

gulp.task('default', ['fonts']);
