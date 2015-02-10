gulp        = require 'gulp'
browserify  = require 'browserify'
source      = require 'vinyl-source-stream'
watchify    = require 'watchify'
gutil       = require 'gulp-util'

gulp.task 'default', ->
