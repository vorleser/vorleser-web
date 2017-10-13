run:
	elm-make src/Main.elm --debug --output elm.js
	python -m http.simple 9901

build:
	elm-make src/Main.elm --debug --output elm.js

release:
	elm-make src/Main.elm --output elm.js
