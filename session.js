// Javascript for retrieving sessions state
app.ports.saveSession.subscribe(function(key) {
  window.localStorage.setItem("sessionKey", key);
});
app.ports.saveServerUrl.subscribe(function(key) {
  window.localStorage.setItem("serverUrl", key);
});

let key = window.localStorage.getItem("sessionKey");
if (key) {
  app.ports.getSession.send(key);
}
let serverUrl = window.localStorage.getItem("serverUrl");
if (serverUrl) {
  app.ports.getServerUrl.send(serverUrl);
}
