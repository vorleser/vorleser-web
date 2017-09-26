import * as React from "react";
import * as ReactDOM from "react-dom";
import Button from 'material-ui/Button';
import AppBar from 'material-ui/AppBar';
import IconButton from 'material-ui/IconButton';
import MenuIcon from 'material-ui-icons/Menu';
import './style.scss';
import 'typeface-roboto';
import LoginForm from './ui/login/login';

async function main() {
    ReactDOM.render(
        <LoginForm />,
        document.getElementById("root")
    )
}

main();
