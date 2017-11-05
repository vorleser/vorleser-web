// Javascript for retrieving sessions state
app.ports.saveSession.subscribe(function(key) {
  window.localStorage.setItem("sessionKey", key);
});

let key = window.localStorage.getItem("sessionKey");
if (key) {
  app.ports.getSession.send(key);
}
