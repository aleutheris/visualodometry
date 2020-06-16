const functions = require('firebase-functions');
const express = require('express');
const shell = require('shelljs');

const app = express();
const cors = require('cors')({origin: true});
app.use(cors);


app.get('/', (req, res) => {
  const date = new Date();
  const hours = (date.getHours() % 12) + 1; // London is UTC + 1hr;
  // [START_EXCLUDE silent]
  res.set('Cache-Control', `public, max-age=${secondsLeftBeforeEndOfHour(date)}`);
  // [END_EXCLUDE silent]
  res.send(`
  <!doctype html>
    <head>
      <title>Time</title>
      <link rel="stylesheet" href="/style.css">
      <script src="/script.js"></script>
    </head>
    <body>
      <p>In London, the clock strikes: <span id="bongs">${'BONG '.repeat(hours)}</span></p>
      <button onClick="refresh(this)">Refresh</button>
    </body>
  </html>`);
});

app.get('/api', (req, res) => {
  const date = new Date();
  const hours = (date.getHours() % 12) + 1; // London is UTC + 1hr;
  // [START_EXCLUDE silent]
  // [START cache]
  res.set('Cache-Control', `public, max-age=${secondsLeftBeforeEndOfHour(date)}`);
  // [END cache]
  // [END_EXCLUDE silent]
  res.json({bongs: 'BONG '.repeat(hours)});
});

function secondsLeftBeforeEndOfHour(date) {
  const m = date.getMinutes();
  const s = date.getSeconds();
  return 3600 - (m*60) - s;
}

app.get('/id1=:id1&id2=:id2', function (req, res) {
  var myvar = shell.exec('./vodometry ' + req.params.id1 + ' ' + req.params.id2);
  res.send(myvar);
})


exports.app = functions.https.onRequest(app);


exports.helloWorld = functions.https.onRequest((request, response) => {
  var myvar = shell.exec('./vodometry cenas maradas bla ble');
  response.send(myvar);
});
