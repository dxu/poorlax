gulp        = require 'gulp'
browserify  = require 'browserify'
source      = require 'vinyl-source-stream'
watchify    = require 'watchify'
gutil       = require 'gulp-util'

gulp.task 'default', ->
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

