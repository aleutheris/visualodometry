const listUsers = document.getElementById('listUsers')

var request2 = new XMLHttpRequest()
request2.open('GET', 'http://localhost:8081/listUsers', true)
request2.onload = function() {
  var data = JSON.parse(this.response)
  if (request2.status === 200) 
  {
    listUsers.innerHTML = data.user1.name;
  } 
  else 
  {
    listUsers.innerHTML = 'An error occurred during your request: ' +  request2.status + ' ' + request2.statusText;
  }
}

request2.send()


/*const root1 = document.getElementById('root1')

var request1 = new XMLHttpRequest()
request1.open('GET', 'https://api.ipify.org?format=json', true)
request1.onload = function() {
  var data = JSON.parse(this.response)
  if (request1.status === 200) 
  {
    root1.innerHTML = JSON.parse(request1.responseText).ip;
  } 
  else 
  {
    root1.innerHTML = 'An error occurred during your request: ' +  request1.status + ' ' + request1.statusText;
  }
}
*/
