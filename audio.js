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
    audio.volume = command.arg.volume || 1
    audio.addEventListener("canplay", () => {
      app.ports.ready.send(audio.position || 0)
    });
  } else if (command.command === "Stop") {
    audio.pause()
    audio = new Audio()
  } else if (command.command === "Play") {
    audio.play();
  } else if (command.command === "Pause") {
    audio.pause();
  } else if (command.command === "Unpause") {
    audio.play();
  } else if (command.command === "SetVolume") {
    setVolume(command.arg.volume);
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

function setVolume(volume) {
  audio.volume = volume
  app.ports.volume.send(audio.volume)
  window.localStorage.setItem("volume", volume);
}

function sendProgress() {
  app.ports.progress.send(audio.currentTime || 0)
}

function sendPlaying() {
  app.ports.playing.send(!audio.paused)
}
