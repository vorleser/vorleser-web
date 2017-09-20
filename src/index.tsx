import * as React from "react";
import * as ReactDOM from "react-dom";
import AppBar from "react-toolbox/lib/app_bar";
import ThemeProvider from "react-toolbox/lib/ThemeProvider";
import './style.scss';

async function main() {
    ReactDOM.render(
        <AppBar title="Vorleser-Web" leftIcon="menu"></AppBar>,
        document.getElementById("root")
    )
}

main();
