gulp        = require 'gulp'
browserify  = require 'browserify'
source      = require 'vinyl-source-stream'
watchify    = require 'watchify'
gutil       = require 'gulp-util'
less        = require 'gulp-less'
plumber     = require 'gulp-plumber'

###
# LESS compilation
###
gulp.task 'less', ->
  lessFilePath = "./styles.less"
  gulp.src lessFilePath
    .pipe plumber()
    .pipe less().on('error', gutil.log)
    .pipe gulp.dest("./dist")

gulp.task 'default', ->
  ###
  # Coffeescript compilation
  ###
  bundle = browserify
    debug: true
    entries: ["./scripts.coffee"]
    extensions: ['.coffee']
  .transform 'coffeeify'

  bundle = watchify bundle
  bundle.bundle().on 'error', gutil.log
    .pipe source("scripts.js")
    .pipe gulp.dest("./dist")
  bundle.on 'update', ->
    bundle.bundle().on 'error', gutil.log
      .pipe source("scripts.js")
      .pipe gulp.dest("./dist")

  gulp.watch './*.less', ['less']
