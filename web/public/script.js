(function(){
var app = angular.module("githubViewer", [])

var MainController = function($scope)
{
  $scope.message = "Hello Angular";
}

app.controller("MainController", MainController);

}());




/*
function refresh(_this) {
  // Disable the button and remove current BONGS text.
  _this.disabled = true;
  document.getElementById('bongs').innerHTML = '...';

  // Prepare an ajax request to use the API to get the current BONGS from the API.
  var request = new XMLHttpRequest();
  request.onreadystatechange = function() {
    if (request.readyState === 4) {
      // Re-enable the button.
      _this.disabled = false;
      var bongsContainer = document.getElementById('bongs');
      if (request.status === 200) {
        // Replace the BONG text with the response from the API.
        bongsContainer.innerHTML = JSON.parse(request.responseText).bongs;
      } else {
        bongsContainer.innerHTML = 'An error occurred during your request: ' +  request.status + ' ' + request.statusText;
      }
    }
  }
  request.open('Get', '/api');

  // Start the ajax request.
  request.send();
}*/

const bongs = document.getElementById('bongs')

var request2 = new XMLHttpRequest()
request2.open('GET', 'http://localhost:5001/vodometry/us-central1/app/x=30&y=40&numberpixels=10', true)
request2.onload = function() {
  if (request2.status === 200) 
  {
    bongs.innerHTML = this.response;
  } 
  else 
  {
    bongs.innerHTML = 'An error occurred during your request: ' +  request2.status + ' ' + request2.statusText;
  }
}

request2.send()