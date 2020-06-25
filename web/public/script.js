(function() {
	var app = angular.module("voViewer", [])
	var svgContainer = {};
	var pixelSize = 1;
	var image = {};
	image.x = 400;
	image.y = 400;
	var numberOfPixels = 200;


	var createPictureBackgroud = function(svgContainer, image) {
		var mainRectangle = svgContainer.append("rect")
			.attr("x", 0)
			.attr("y", 0)
			.attr("width", image.x)
			.attr("height", image.y)
			.attr("fill", "black");
	}

	var createPixel = function(svgContainer, x, y, length, color) {
		var rectangle = svgContainer.append("rect")
			.attr("x", x)
			.attr("y", y)
			.attr("width", length)
			.attr("height", length)
			.attr("fill", color);
	}

	var PictureController = function($scope, $http) {
		$scope.image = image;
		$scope.numberOfPixels = numberOfPixels;

		$scope.generate = function() {
			image.x = $scope.image.x;
			image.y = $scope.image.y;
			numberOfPixels = $scope.numberOfPixels;

			//var promise = $http.get("http://localhost:5001/vodometry/us-central1/app/x=" + image.x + "&y=" + image.y + "&numberpixels=" + numberOfPixels);
			var promise = $http.get("https://us-central1-vodometry.cloudfunctions.net/app/x=" + image.x + "&y=" + image.y + "&numberpixels=" + numberOfPixels);

			promise.then(function(response) {
				var imageData = response.data;

				d3.select("svg").remove();

				svgContainer = d3.select("body").append("svg")
					.attr("width", image.x)
					.attr("height", image.y);

				createPictureBackgroud(svgContainer, image);

				for (var i = 0; i < numberOfPixels; i++) {
					createPixel(svgContainer, imageData["pixels"][i].x, imageData["pixels"][i].y, pixelSize, "white");
				}
			});

		};
	}

	app.controller("PictureController", PictureController);
}());
