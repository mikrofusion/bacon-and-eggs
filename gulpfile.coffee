'use strict'

gulp       = require 'gulp'
coffee     = require 'gulp-coffee'
coffeelint = require 'gulp-coffeelint'
util       = require 'gulp-util'
plumber    = require 'gulp-plumber'
concat     = require 'gulp-concat'
spawn      = require('child_process').spawn

onError = (err) ->
  util.log util.colors.red 'stream error...'
  util.log util.colors.red(JSON.stringify(err))

gulp.task 'lint', ->
  gulp.src ['src/*.coffee', 'examples/*.coffee']
    .pipe(coffeelint())
    .pipe(coffeelint.reporter())
    .pipe(coffeelint.reporter('fail'))
    .on 'error', () -> process.exit(1)

gulp.task 'compile', ['lint'], ->
  gulp.src 'src/*.coffee'
    .pipe plumber {errorHandler: onError}
    .pipe coffee bare: true
    .pipe concat 'index.js'
    .pipe gulp.dest 'dist/'

gulp.task 'server', ['compile'], ->
  node.kill() if node
  node = spawn "node", ["dist/index.js"], stdio: "inherit"
  node.on "close", (code) ->
    console.log "Error detected, waiting for changes..."  if code is 8

gulp.task 'watch', ->
  gulp.watch 'src/*.coffee', ['server']

gulp.task 'default', [ 'server', 'watch' ]
