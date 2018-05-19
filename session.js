// Javascript for retrieving sessions state
app.ports.saveSession.subscribe(function(key) {
  window.localStorage.setItem("sessionKey", key);
});
app.ports.saveServerUrl.subscribe(function(url) {
  window.localStorage.setItem("serverUrl", url);
});

app.ports.saveLastPlayed.subscribe(function(id) {
  window.localStorage.setItem("lastPlayed", id);
});

app.ports.clearSession.subscribe(function() {
  window.localStorage.clear();
});

app.ports.requestLastPlayed.subscribe(function() {
  let lastPlayed = window.localStorage.getItem("lastPlayed");
  if (lastPlayed) {
    app.ports.getLastPlayed.send(lastPlayed);
  }
});


let serverUrl = window.localStorage.getItem("serverUrl");
let key = window.localStorage.getItem("sessionKey");
if (serverUrl && key) {
  app.ports.startupInfo.send({"loginToken": key, "serverUrl": serverUrl});
  setVolume(window.localStorage.getItem("volume"));
}
