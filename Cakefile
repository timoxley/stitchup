require.paths.unshift "#{__dirname}/node_modules"

require.paths.unshift __dirname + '/lib'

{print} = require 'sys'
exec = require('child_process').exec
fs = require 'fs'

compile = (callback) ->
    exec 'coffee -c -o lib src', (error, stdout, stderr) ->
        if (error != null)
            console.log('Compile Error:')
            console.log(stderr)
        else
            prepend_bin(callback)

prepend_bin = (callback) ->
    content = fs.readFile __dirname + '/lib/stitchup.js', 'utf-8', (err, content) ->
        if (err) 
            throw err
        
        newContent = "#!/usr/bin/env node \n" + content
        fs.unlinkSync(__dirname + '/lib/stitchup.js')
        fs.writeFile __dirname + '/lib/stitchup.js', newContent, 'utf8',  (err) ->
            if (err) 
                throw err
            console.log('Build Success.\n')
            callback?()

install = (callback) ->
    exec 'npm install -g .', (error, stdout, stderr) ->
       if (error != null)
         console.log('Install Error:')
         console.log(stderr)
         
       console.log(stdout)
       console.log('Install Success.') 


run_tests = (callback) ->
    exec 'jasmine-node --coffee ./test/', (error, stdout, stderr) ->
        if (error != null)
            console.log('Tests Run Error:')
            console.log(stderr)
            console.log('Perhaps you need to install jasmine-node: \'npm install -g jasmine-node\'')
         
        console.log(stdout)
        callback?()

task 'make', 'Build lib/ from src/', ->
    compile()
    

task 'install', 'Build then use npm to install stitchup as a global, executable module', ->
    invoke 'make'
    install()
       
task 'test', ->
    run_tests()
    