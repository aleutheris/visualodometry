"use strict";

var svgContainer = {};
var pixelSize = 1;
var pixelsColor = "white";


var tooltip = d3.select("#picture")
	.append("div")
	.style("position", "absolute")
	.style("visibility", "hidden")
	.text("I'm a pixel!");

var mouseHover = function() {
	d3.select("#background")
		.on("mouseover", function() { return tooltip.style("visibility", "visible"); })
		.on("mousemove", function() {
			return tooltip.style("top", (event.pageY + 50) + "px").style("left", (event.pageX + 50) + "px");
		})
		.on("mouseout", function() { return tooltip.style("visibility", "hidden"); });
}

var createPixelsGenerator = function(image) {
	svgContainer = d3.select("#picture")
		.append("svg")
		.attr("width", image.x)
		.attr("height", image.y)
		.call(d3.zoom()
			.scaleExtent([.5, 20])
			.on("zoom", function() {
				svgContainer.attr("transform", d3.event.transform)
			}))
		.append("g")
}

var renderPictureBackgroud = function(image) {
	svgContainer
		.append("rect")
		.attr("id", "background")
		.attr("x", 0)
		.attr("y", 0)
		.attr("width", image.x)
		.attr("height", image.y)
		.attr("fill", "black");
}

var renderPixel = function(x, y, length, color, id) {
	svgContainer
		.append("rect")
		.attr("id", id)
		.attr("x", x)
		.attr("y", y)
		.attr("width", length)
		.attr("height", length)
		.attr("fill", color);
}

var renderPixels = function(imageData, numberOfPixels) {
	for (var i = 0; i < numberOfPixels; i++) {
		renderPixel(imageData["pixels"][i].x, imageData["pixels"][i].y, pixelSize, pixelsColor, i);
	}
}

var renderPixelsPicture = function(image, imageData, numberOfPixels) {
	d3.select("svg").remove();

	createPixelsGenerator(image);
	renderPictureBackgroud(image);
	renderPixels(imageData, numberOfPixels);
	mouseHover();
}