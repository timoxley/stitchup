#!/usr/bin/env node 
(function() {
  var argv, assert, fs, mode, outfile, package, sources, stitch;
  argv = process.argv.slice(2);
  stitch = require('stitch');
  fs = require('fs');
  assert = require('assert');
  argv = require('optimist').usage('Usage: stitchup -s SOURCES [-o OUTFILE] [-m MODE]').wrap(80).option('outfile', {
    alias: 'o',
    desc: 'Write the stitched bundle to this file',
    "default": 'application.js'
  }).option('sources', {
    alias: 's',
    desc: 'paths to compile, eg ./lib'
  }).option('mode', {
    alias: 'm',
    desc: 'use -m DEVELOPMENT to compile uncompressed js',
    "default": 'PRODUCTION'
  }).demand('sources').argv;
  mode = argv.mode;
  outfile = argv.outfile;
  sources = argv.sources;
  package = stitch.createPackage({
    paths: [sources]
  });
  package.compile(function(err, source) {
    var ast, final_code, jsp, pro;
    assert.ok(source, 'Invalid source file given.');
    if (mode !== "DEVELOPMENT") {
      jsp = require("uglify-js").parser;
      pro = require("uglify-js").uglify;
      ast = jsp.parse(source);
      ast = pro.ast_mangle(ast);
      ast = pro.ast_squeeze(ast);
      final_code = pro.gen_code(ast);
      source = final_code;
    }
    return fs.writeFile(outfile, source, function(err) {
      if (err) {
        throw err;
      }
      return console.log('Compiled ' + outfile + '.');
    });
  });
}).call(this);
