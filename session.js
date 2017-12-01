var node = document.getElementById('main');
var app = Elm.Main.embed(node);
var audio = new Audio();
setInterval(() => {
  sendProgress()
}, 500);

// Javascript for retrieving sessions state
app.ports.saveSession.subscribe(function(key) {
  window.localStorage.setItem("sessionKey", key);
});
app.ports.saveServerUrl.subscribe(function(key) {
  window.localStorage.setItem("serverUrl", key);
});


let serverUrl = window.localStorage.getItem("serverUrl");
let key = window.localStorage.getItem("sessionKey");
if (serverUrl && key) {
  app.ports.startupInfo.send({"loginToken": key, "serverUrl": serverUrl});
}
