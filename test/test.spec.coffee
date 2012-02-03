exec = require('child_process').exec
fs = require 'fs'
assert = require 'assert'

describe "stitchup", ->
  beforeEach (done) ->
    require('child_process').exec 'mkdir -p ./test/tmp', (error, stdout, stderr) ->
      console.log error.message if error?
      done()
    
  afterEach (done) ->
    require('child_process').exec 'rm -Rf ./test/tmp', (error, stdout, stderr) ->
      console.log error.message if error?
      done()

        
  it 'displays usage', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee', (error, stdout, stderr) ->
      assert.ok(error)
      assert.ok(/Usage:/.test(stderr))
      done()
  
  it 'displays missing', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee', (error, stdout, stderr) ->
      assert.ok(error)
      assert.ok(/Not enough non-option arguments: got 0, need at least 1/.test(stderr))
      done()

  it 'compiles commonjs coffeescript modules', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/a.js ./test/fixtures/a', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)
      bundle = require('./tmp/a.js')
      assert.ok(bundle)
      
      assert.equal(bundle.require('a'), 'whoo')
      done()

  it 'compiles with no -s', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/a.js ./test/fixtures/a', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)
      bundle = require('./tmp/a.js')
      assert.ok(bundle)

      assert.equal(bundle.require('a'), 'whoo')
      done()
  it 'compiles multiple sources with no -s', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/ab.js ./test/fixtures/a ./test/fixtures/b', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)
       
      bundle = require('./tmp/ab.js')
      assert.ok(bundle)

      assert.ok(bundle.require('a'), 'whoo')
      assert.ok(bundle.require('b'), 'whaarr')
      done()
  it 'compresses output', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/a.1.js ./test/fixtures/a', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)
      
      require('child_process').exec 'wc -l ./test/tmp/a.1.js', (error, stdout, stderr) ->
        assert.ok(/0 .\/test\/tmp\/a\.1\.js/.test(stdout))
        done()
    
  it 'doesn\'t compress output in development mode', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/a.2.js -m DEVELOPMENT ./test/fixtures/a', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)

      require('child_process').exec 'wc -l ./test/tmp/a.2.js', (error, stdout, stderr) ->
        assert.ok(/\.\/test\/tmp\/a\.2\.js/.test(stdout))
        assert.ok(!(/0 \.\/test\/tmp\/a\.2\.js/.test(stdout)))
        done()
  it 'compiles nested coffeescript commonjs modules', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/b.js ./test/fixtures/b', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)

      bundle = require('./tmp/b.js')
      assert.ok(bundle)
      assert.throws(
              ->
                bundle.require('a')
            ,/module 'a' not found/)
      
      assert.equal(bundle.require('b'), 'whaarr')
      assert.equal(bundle.require('nesting/nesting'), 'whooo')
      done()
  it 'compiles commonjs javascript modules', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/c.js ./test/fixtures/c', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)

      bundle = require('./tmp/c.js')
      assert.ok(bundle)
      
      assert.equal(bundle.require('c'), 'wheee')
      done()
    
  it 'doesn\'t expose anything from libs with no exports', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/d.js ./test/fixtures/d', (error, stdout, stderr) ->
      assert.ok(!error)
      assert.ok(!stderr)

      bundle = require('./tmp/d.js')
      d = bundle.require('d')
      assert.deepEqual(d, {})
      done()
    
  it 'displays an error if you try to compile an non-existant invalid file', (done) ->
    require('child_process').exec 'coffee ./src/stitchup.coffee -o ./test/tmp/d.js ./test/fixtures/invalid', (error, stdout, stderr) ->
      assert.ok(error)
      assert.ok(/AssertionError: Invalid source file given\./.test(stderr))
      done()
