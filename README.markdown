#Browser-side require(), minifier & packager for CommonJS modules

Easily package and minify Javascript & Coffeescript CommonJS modules using this handy commandline tool (even for non-NodeJS projects).

CommonJS modules in the supplied directory are minified into a single javascript file, and can be imported inside the browser via synchronous `require()`. 

StitchUp wraps the amazing stitch library https://github.com/sstephenson/stitch Thanks heaps sstephenson.

Minification is provided by the uglify library https://github.com/mishoo/UglifyJS/

##Installation
    $ npm install -g stitchup

##Usage

### Stitch up CommonJS modules located in `app` to `public/bundle.js` 
    $ stitchup -s app -o public/bundle.js

### Compile in development (uncompressed) mode
    $ stitchup -s app -o public/bundle.js -m DEVELOPMENT
    
### Load modules via synchronous require()

    # Stitch up modules in the ./app directory as ./public/bundle.js:          
    $ stitchup -s ./app -o ./public/bundle.js      
          
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
    $ stitchup -s ./app -o ./public/app.js
    Compiled ./public/app.js.
    $ cd public/
    $ python -m "SimpleHTTPServer"
    Serving HTTP on 0.0.0.0 port 8000 ...
    Navigate to 0.0.0.0:8000 via your web browser and you should see that stitchup is working

## Future

  * Ability to 'watch' a directory and automatically recompile

