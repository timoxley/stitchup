/*
	File: example/app/app.controller.js
	This file is require()'d by script on the destination page
*/
module.exports = {
	init: function() {
		var stitchedModel = require('awesome.model');
		console.log('loaded model...');
		if (stitchedModel.is_working) {
			$('#status').html('working')
			console.log('model appears to be working!');
			console.log(stitchedModel);
		}
	}
}