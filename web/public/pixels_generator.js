"use strict";

var svgContainer = {};
var pixelSize = 1;
var pixelsColor = "white";
var tooltip = [];


var createTooltip = function(div, imageData, numberOfPixels) {
	for (var i = 0; i < numberOfPixels; i++) {
		tooltip[i] = d3.select("#" + div)
			.append("div")
			.style("position", "absolute")
			.style("visibility", "hidden")
			.text("(" + imageData["pixels"][i].x + "," + imageData["pixels"][i].y + ")");
	}
}

var createPixelsGenerator = function(div, image) {
	var dyncSvgPixelsGenerated = "svg" + div;

	d3.select('#' + dyncSvgPixelsGenerated).remove();

	svgContainer = d3.select("#" + div)
		.append("svg")
		.attr("id", dyncSvgPixelsGenerated)
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
		.attr("fill", "grey");
}

var renderPixel = function(x, y, length, color, id) {
	svgContainer
		.append("rect")
		.attr("id", "id" + id)
		.attr("x", x)
		.attr("y", y)
		.attr("width", length)
		.attr("height", length)
		.attr("fill", color);


}

var renderPixels = function(imageData, numberOfPixels) {
	for (var i = 0; i < numberOfPixels; i++) {
		renderPixel(imageData["pixels"][i].x, imageData["pixels"][i].y, pixelSize, pixelsColor, i);
		mouseHover(i);
	}
}

var mouseHover = function(id) {
	d3.select("#id" + id)
		.on("mouseover", function() { return tooltip[id].style("visibility", "visible"); })
		.on("mousemove", function() {
			return tooltip[id].style("top", (event.pageY + 50) + "px").style("left", (event.pageX + 50) + "px");
		})
		.on("mouseout", function() { return tooltip[id].style("visibility", "hidden"); });
}


function setPixel(imageData, x, y, r, g, b, a) {
	var index = (x + y * imageData.width) * 4;
	imageData.data[index + 0] = r;
	imageData.data[index + 1] = g;
	imageData.data[index + 2] = b;
	imageData.data[index + 3] = a;
}

var renderPixelsPicture = function(div, image, pixelsGenerated, numberOfPixels) {/*
	createTooltip(div, imageData, numberOfPixels);
	createPixelsGenerator(div, image);
	renderPictureBackgroud(image);
	renderPixels(imageData, numberOfPixels);*/


	var canvas = document.getElementById("canvas1");
	var ctx = canvas.getContext("2d");
	ctx.fillStyle = "black";
	ctx.fillRect(0, 0, image.x, image.y);

	//var imageData = ctx.createImageData(image.x, image.x);
	var imageData = ctx.getImageData(0, 0, image.x, image.y);

	for (var i = 0; i < numberOfPixels; i++) {
		setPixel(imageData, pixelsGenerated["pixels"][i].x, pixelsGenerated["pixels"][i].y, 255, 255, 255, 255);
	}

	ctx.putImageData(imageData, 0, 0);
}
