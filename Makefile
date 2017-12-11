watch:
	watchexec --ignore css -r --signal SIGKILL make run

run:
	elm-make src/Main.elm --debug --output elm.js
	python -m http.server 9901

build:
	elm-make src/Main.elm --debug --output elm.js

release:
	elm-make src/Main.elm --output elm.js --yes
