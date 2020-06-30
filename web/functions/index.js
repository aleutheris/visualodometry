const functions = require('firebase-functions');
const express = require('express');
const shell = require('shelljs');

const app = express();
const cors = require('cors')({origin: true});
app.use(cors);


app.get('/', (req, res) => {
  var host = shell.exec('hostname');
  var json_host = {"host": host}; 
  res.end(JSON.stringify(json_host));
});

app.get('/x=:x&y=:y&numberpixels=:numberpixels', function (req, res) {
  var pixels = shell.exec('./lib/vodometry ' + req.params.x + ' ' + req.params.y + ' ' + req.params.numberpixels);
  var pixels_json = JSON.parse(pixels);
  res.end(JSON.stringify(pixels_json));
})

exports.app = functions.https.onRequest(app);
