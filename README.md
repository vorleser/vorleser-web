# Vorleser-web

Vorleser-web is a web front-end for [vorleser-server](https://github.com/hatzel/vorleser-server).
Both the server and this front-end are currently in development.

## Setup

Just execute `make run`, this will build the project using `elm-make` and use Python's built in HTTP server to serve the resulting files.

If you want the page to automatically rebuild on changes you will need to install `watchexec`.
The preferred way is to do this using cargo: `cargo install watchexec`.
