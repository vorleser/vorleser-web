var node = document.getElementById('main');
var app = Elm.Main.embed(node);
var audio = new Audio();
setInterval(() => {
  sendProgress()
}, 500);

app.ports.command.subscribe(function(command) {
  if (command.command == "SetFile") {
    audio.pause();
    delete audio;
    audio = new Audio(command.arg.file);
    audio.currentTime = command.arg.position
    audio.addEventListener("canplay", () => {
      app.ports.ready.send(audio.position || 0)
    });
  } else if (command.command === "Play") {
    audio.play();
  } else if (command.command === "Pause") {
    audio.pause();
  } else if (command.command === "Unpause") {
    audio.play();
  } else if (command.command === "SetVolume") {
    audio.volume = command.arg.volume;
    return
  } else if (command.command === "Toggle") {
    if (audio.paused) {
      audio.play();
    } else {
      audio.pause()
    }
  } else if (command.command === "SkipTo") {
    audio.currentTime = command.arg.position;
  }
  sendPlaying();
})

function sendProgress() {
  // Only send progress if we actually are ready
  app.ports.progress.send(audio.currentTime)
}

function sendPlaying() {
  app.ports.playing.send(!audio.paused)
}
