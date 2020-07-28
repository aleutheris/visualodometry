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
	//var divFramePixelsGenerated = "FramePixelsGenerated";
	var canvas = document.getElementById("canvasImagePixelsGenerated");
	var ctx = canvas.getContext("2d");
	var pixelsGenerated = {};

	/*
		app.directive("framePixelsGenerated", function() {
			var createdTemplate = "<div id=\"" + divFramePixelsGenerated + "\"></div>";
	
			return {
				template: createdTemplate
			};
		});*/

	var FrameController = function($scope, $http) {
		$scope.scale = 1;
		$scope.image = image;
		$scope.numberOfPixels = numberOfPixels;
		var mouseX = 0;
		var mouseY = 0;
		var mouseDownX = 0;
		var mouseDownY = 0;
		var imagePositionX = 0;
		var imagePositionY = 0;
		var isDraggable = false;
		var previousScale = 1;
		var canvasOffSetLeft = {};
		var canvasOffSetTop = {};

		$scope.mouseDown = function(event) {
			canvasOffSetLeft = angular.element(event.target).prop('offsetLeft');
			canvasOffSetTop = angular.element(event.target).prop('offsetTop');

			mouseDownX = event.pageX - canvasOffSetLeft - imagePositionX;
			mouseDownY = event.pageY - canvasOffSetTop - imagePositionY;

			if (mouseX >= 0 && mouseX <= image.x && mouseY >= 0 && mouseY <= image.y) {
				isDraggable = true;
			}
		};

		$scope.mouseMove = function(event) {
			if (isDraggable) {
				mouseX = event.pageX - canvasOffSetLeft;
				mouseY = event.pageY - canvasOffSetTop;

				imagePositionX = mouseX - mouseDownX;
				imagePositionY = mouseY - mouseDownY;

				renderPixelsPicture(ctx, image, pixelsGenerated, numberOfPixels, $scope.scale, previousScale, imagePositionX, imagePositionY);
			}
		};

		$scope.mouseUp = function() {
			isDraggable = false;
		};

		$scope.mouseOut = function() {
			isDraggable = false;
		};

		$scope.generate = function() {
			numberOfPixels = $scope.numberOfPixels;
			//var promise = $http.get("http://localhost:5001/vodometry/us-central1/app/x=" + image.x + "&y=" + image.y + "&numberpixels=" + numberOfPixels);
			var promise = $http.get("https://us-central1-vodometry.cloudfunctions.net/app/x=" + image.x + "&y=" + image.y + "&numberpixels=" + numberOfPixels);

			promise.then(function(response) {
				$scope.scale = 1;
				image.x = $scope.image.x;
				image.y = $scope.image.y;
				imagePositionX = 0;
				imagePositionY = 0;

				pixelsGenerated = response.data;
				renderPixelsPicture(ctx, image, pixelsGenerated, numberOfPixels, $scope.scale, previousScale, imagePositionX, imagePositionY);
				previousScale = $scope.scale;
			});
		};

		$scope.$watch("scale", function(newValue, oldValue) {
			if (newValue != oldValue) {
				renderPixelsPicture(ctx, image, pixelsGenerated, numberOfPixels, $scope.scale, previousScale, imagePositionX, imagePositionY);
				previousScale = $scope.scale;
			}
		});
	}

	app.controller("FrameController", ["$scope", "$http", FrameController]);
}());
