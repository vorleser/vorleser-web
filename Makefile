watch:
	watchexec --ignore css -r --signal SIGKILL make run

run:
	elm-make src/Main.elm --debug --output elm.js
	python -m http.server 9901

build:
	elm-make src/Main.elm --yes --debug --output elm.js

release:
	elm --version
	elm-make src/Main.elm --yes --output elm.js
