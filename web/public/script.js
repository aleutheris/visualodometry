(function() {
	"use strict";

	var app = angular.module("voViewer", []);

	function include(file) {
		var script = document.createElement('script');
		script.src = file;
		script.type = 'text/javascript';
		script.defer = true;

		document.getElementsByTagName('head').item(0).appendChild(script);
	}

	include("pixels_generator.js");


	var image = {};
	image.x = 400;
	image.y = 400;
	var numberOfPixels = 200;
	var divFramePixelsGenerated = "FramePixelsGenerated";
	var divFramePixelsGeneratedAndTransformed = "FramePixelsGeneratedAndTransformed";


	app.directive("framePixelsGenerated", function() {
		var createdTemplate = "<div id=\"" + divFramePixelsGenerated + "\"></div>";

		return {
			template: createdTemplate
		};
	});

	app.directive("framePixelsGeneratedAndTransformed", function() {
		var createdTemplate = "<div id=\"" + divFramePixelsGeneratedAndTransformed + "\"></div>";

		return {
			template: createdTemplate
		};
	});


	var FrameController = function($scope, $http) {
		$scope.image = image;
		$scope.numberOfPixels = numberOfPixels;

		$scope.generate = function() {
			image.x = $scope.image.x;
			image.y = $scope.image.y;
			numberOfPixels = $scope.numberOfPixels;

			var promise = $http.get("http://localhost:5001/vodometry/us-central1/app/x=" + image.x + "&y=" + image.y + "&numberpixels=" + numberOfPixels);
			//var promise = $http.get("https://us-central1-vodometry.cloudfunctions.net/app/x=" + image.x + "&y=" + image.y + "&numberpixels=" + numberOfPixels);

			promise.then(function(response) {
				var pixelsGenerated = response.data;
				renderPixelsPicture(divFramePixelsGenerated, image, pixelsGenerated, numberOfPixels);
				//renderPixelsPicture(divFramePixelsGeneratedAndTransformed, image, imageData, numberOfPixels);
			});
		};
	}

	app.controller("FrameController", ["$scope", "$http", FrameController]);
}());
