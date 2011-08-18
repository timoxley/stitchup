#Browser-side require(), minifier & packager for CommonJS modules

Easily use Javascript & Coffeescript CommonJS modules in the browser using this handy commandline tool, even for non-NodeJS projects.

A directory of [CommonJS modules](http://wiki.commonjs.org/wiki/Modules/1.0) is minified into a single javascript file, and each module can be exposed on demand in the browser via synchronous `require()`. 

StitchUp wraps the amazing stitch library https://github.com/sstephenson/stitch Thanks heaps sstephenson.

Minification is provided by the uglify library https://github.com/mishoo/UglifyJS/

##Installation
    $ npm install -g stitchup

##Usage

### Stitch up CommonJS modules located in `app` to `public/bundle.js` 
    $ stitchup -o public/bundle.js app

### Compile in development (uncompressed) mode
    $ stitchup -o public/bundle.js -m DEVELOPMENT app
    
### Load modules via synchronous require()

    # Stitch up modules in the ./app directory as ./public/bundle.js:          
    $ stitchup -o ./public/bundle.js ./app     
          
    # Load the bundle on your website:
    <script src="/bundle.js"></script>
    <script>
        $(function() {
            var app = require('controllers/app');
            app.init();
        })
    </script>

    # Use require() to reference modules from modules:
    module.exports = {
        init: function() {
            var myCar = require('models/cars');
            myCar.drive();
        }
    }

### Run the provided example:
    $ git clone git://github.com/secoif/StitchUp.git
    Cloning into StitchUp...
    $ cd StitchUp
    $ cd example
    $ stitchup -o ./public/app.js ./app
    Compiled ./public/app.js.
    $ cd public/
    $ python -m "SimpleHTTPServer"
    Serving HTTP on 0.0.0.0 port 8000 ...
    Navigate to 0.0.0.0:8000 via your web browser and you should see that stitchup is working

## Future

  * Ability to 'watch' a directory and automatically recompile

