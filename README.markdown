#Browser-side require(), minifier & packager for CommonJS modules

Easily compress and package Javascript or Coffeescript CommonJS modules using this handy commandline tool (even for non-NodeJS projects!).

All common JS modules in the supplied directory will be compressed and compiled into a single javascript file (default: application.js). 

##Usage
### StitchUp CommonJS modules located in 'app' to public/app.js 
    $ stitchup -s app -o public/app.js

### Compile in development (uncompressed) mode
    $ stitchup -s app -o public/app.js -m DEVELOPMENT

##Modules will be available through synchronous require():

    # On any webpage
    var myModule = require('myModule')
    myModule.doStuff() 


###  Run the provided example:
	$ git clone git://github.com/secoif/StitchUp.git
	Cloning into StitchUp...
	$ cd StitchUp
	$ cd example
	$ stitchup -s ./app -o ./public/app.js
	Compiled ./public/app.js.
	$ cd public/
	$ python -m "SimpleHTTPServer"
	Serving HTTP on 0.0.0.0 port 8000 ...
	(Navigate to 0.0.0.0:8000 via your web browser and you should see that stitchup is working)


###Future

  * Ability to 'watch' a directory and automatically recompile


StitchUp wraps the amazing stitch library https://github.com/sstephenson/stitch Thanks heaps to sstephenson.
