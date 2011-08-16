exec = require('child_process').exec
fs = require 'fs'

describe "stitchup", ->
  beforeEach ->
    require('child_process').exec 'mkdir -p ./test/tmp', (error, stdout, stderr) ->
      console.log error.message if error?
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
    
  afterEach ->
    require('child_process').exec 'rm -Rf ./test/tmp', (error, stdout, stderr) ->
      console.log error.message if error?
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()

        
  it 'displays usage', ->
    require('child_process').exec 'stitchup', (error, stdout, stderr) ->
      expect(error).toBeTruthy()
      expect(stderr).toContain('Usage:')
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
  
  it 'displays missing', ->
    require('child_process').exec 'stitchup', (error, stdout, stderr) ->
      expect(error).toBeTruthy()
      expect(stderr).toContain('Not enough non-option arguments: got 0, need at least 1')
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()

  it 'compiles commonjs coffeescript modules', ->
    require('child_process').exec 'stitchup -o ./test/tmp/a.js ./test/fixtures/a', (error, stdout, stderr) ->
      expect(error).toBeFalsy()
      expect(stderr).toBeFalsy()
      bundle = require('./tmp/a.js')
      expect(bundle).toBeTruthy()
      
      expect(bundle.require('a')).toEqual('whoo')
      
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
  it 'compiles with no -s', ->
    require('child_process').exec 'stitchup -o ./test/tmp/a.js ./test/fixtures/a', (error, stdout, stderr) ->
      expect(error).toBeFalsy()
      expect(stderr).toBeFalsy()
      bundle = require('./tmp/a.js')
      expect(bundle).toBeTruthy()

      expect(bundle.require('a')).toEqual('whoo')

      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
  it 'compiles multiple sources with no -s', ->
     require('child_process').exec 'stitchup -o ./test/tmp/ab.js ./test/fixtures/a ./test/fixtures/b', (error, stdout, stderr) ->
       expect(error).toBeFalsy()
       expect(stderr).toBeFalsy()
       
       bundle = require('./tmp/ab.js')
       expect(bundle).toBeTruthy()

       expect(bundle.require('a')).toEqual('whoo')
       expect(bundle.require('b')).toEqual('whaarr')
       
       jasmine.asyncSpecDone()
     jasmine.asyncSpecWait()
  it 'compresses output', ->
    require('child_process').exec 'stitchup -o ./test/tmp/a.1.js ./test/fixtures/a', (error, stdout, stderr) ->
      expect(error).toBeFalsy()
      expect(stderr).toBeFalsy()
      
      require('child_process').exec 'wc -l ./test/tmp/a.1.js', (error, stdout, stderr) ->
        expect(stdout).toContain('0 ./test/tmp/a.1.js')
      
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
    
  it 'doesn\'t compress output in development mode', ->
    require('child_process').exec 'stitchup -o ./test/tmp/a.2.js -m DEVELOPMENT ./test/fixtures/a', (error, stdout, stderr) ->
      expect(error).toBeFalsy()
      expect(stderr).toBeFalsy()

      require('child_process').exec 'wc -l ./test/tmp/a.2.js', (error, stdout, stderr) ->
        expect(stdout).toContain('./test/tmp/a.2.js')
        expect(stdout).not.toContain('0 ./test/tmp/a.2.js')
      
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
  
  it 'compiles nested coffeescript commonjs modules', ->
    require('child_process').exec 'stitchup -o ./test/tmp/b.js ./test/fixtures/b', (error, stdout, stderr) ->
      expect(error).toBeFalsy()
      expect(stderr).toBeFalsy()
      bundle = require('./tmp/b.js')
      expect(bundle).toBeTruthy()
      expect(
              ->
                bundle.require('a')
            ).toThrow("module 'a' not found")
      
      expect(bundle.require('b')).toEqual('whaarr')
      expect(bundle.require('nesting/nesting')).toEqual('whooo')
      
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
  
  it 'compiles commonjs javascript modules', ->
    require('child_process').exec 'stitchup -o ./test/tmp/c.js ./test/fixtures/c', (error, stdout, stderr) ->
      expect(error).toBeFalsy()
      expect(stderr).toBeFalsy()
      bundle = require('./tmp/c.js')
      expect(bundle).toBeTruthy()
      
      expect(bundle.require('c')).toEqual('wheee')
      
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
    
  it 'doesn\'t expose anything from libs with no exports', ->
    require('child_process').exec 'stitchup -o ./test/tmp/d.js ./test/fixtures/d', (error, stdout, stderr) ->
      expect(error).toBeFalsy()
      expect(stderr).toBeFalsy()
      bundle = require('./tmp/d.js')
      d = bundle.require('d')
      expect(d).toEqual({})
      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()
    
  it 'displays an error if you try to compile an non-existant invalid file', ->
    require('child_process').exec 'stitchup -o ./test/tmp/d.js ./test/fixtures/invalid', (error, stdout, stderr) ->
      expect(error).toBeTruthy()
      expect(stderr).toContain('AssertionError: Invalid source file given.')

      jasmine.asyncSpecDone()
    jasmine.asyncSpecWait()    

    