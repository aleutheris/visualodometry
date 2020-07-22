"use strict";

var svgContainer = {};
var pixelSize = 1;
var pixelsColor = "white";
var tooltip = [];


function setPixel(ctx, x, y) {
	ctx.beginPath();
	ctx.fillStyle = "white";
	ctx.rect(x, y, 1, 1);
	ctx.fill();
}

var renderPixelsPicture = function(ctx, image, pixelsGenerated, numberOfPixels, scale, previousScale, positionX, positionY) {
	var relativeScale = scale / previousScale;

	ctx.clearRect(0, 0, image.x, image.y);
	ctx.beginPath();
	
	positionX /= scale;
	positionY /= scale;

	ctx.scale(relativeScale, relativeScale);
	ctx.fillStyle = "black";

	ctx.rect(positionX, positionY, image.x, image.y);
	ctx.fill();

	for (var i = 0; i < numberOfPixels; i++) {
		setPixel(ctx, positionX + pixelsGenerated["pixels"][i].x, positionY + pixelsGenerated["pixels"][i].y);
	}
}
