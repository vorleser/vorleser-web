import * as React from "react";
import * as ReactDOM from "react-dom";
import Button from 'material-ui/Button';
import AppBar from 'material-ui/AppBar';
import IconButton from 'material-ui/IconButton';
import TextField from 'material-ui/TextField';
import MenuIcon from 'material-ui-icons/Menu';
import './style.scss'
import { inject } from 'mobx-react';

@inject("login")
class LoginForm extends React.Component<undefined, undefined> {
    render() {
        return (
            <form noValidate>
                <TextField
                    id="email"
                    label="email"
                    type="email"
                    fullWidth={ true }
                    margin="normal"
                />
                <TextField
                    id="password"
                    fullWidth={ true }
                    label="password"
                    type="password"
                    margin="normal"
                />
                <Button raised color="primary" className="lol">
                    Login!
                </Button>
            </form>
        )
    }
}

export default LoginForm;
