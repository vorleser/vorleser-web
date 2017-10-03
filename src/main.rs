extern crate domafic;
use domafic::tags::{button, div, h1, form, input, attributes, Tag};
use domafic::AttributeValue::{Str, OwnedStr, Bool};
use domafic::listener::on;
use domafic::{DomNode, DomNodes, DomValue, KeyValue, Listeners};

// If rendering client-side with asm.js or WebAssembly:
#[cfg(target_os = "emscripten")]
use domafic::web_render::{run, JsIo};
#[cfg(target_os = "emscripten")]
use domafic::KeyIter;

#[derive(Debug)]
struct State {
    login_state: LoginState,
    view: AppView
}

#[derive(Debug)]
enum AppView {
    Login
}

#[derive(Debug)]
struct LoginState {
    username: String,
    password: String,
}

#[derive(Debug)]
enum Msg {
    Increment,
    Decrement,
    Submit,
    UpdateUsername(String),
    UpdatePassword(String),
    None
}


impl State {
    fn new() -> Self {
        State {
            login_state: LoginState{username: "".to_owned(), password: "".to_owned()},
            view: AppView::Login
        }
    }
}


fn main() {
    let mut state = LoginState{username: "".to_owned(), password: "".to_owned()};
    let render = |login: &LoginState| {
        div ((
            input((
                attributes([
                    ("type", Str("text")),
                    ("placeholder", Str("Username")),
                    ("autofocus", Bool(true)),
                    ("value", OwnedStr(login.username.to_owned())),
                ]),
                (
                    on("input", |event|
                        if let Some(target_value) = event.target_value {
                            Msg::UpdateUsername(target_value.to_owned())
                        } else { Msg::None }
                    ),
                )
            )),
            input((
                attributes([
                    ("type", Str("password")),
                    ("placeholder", Str("Password")),
                    ("value", OwnedStr(login.password.to_owned())),
                ]),
                (
                    on("input", |event|
                        if let Some(target_value) = event.target_value {
                            Msg::UpdatePassword(target_value.to_owned())
                        } else { Msg::None }
                    ),
                )
            )),
            input((
                attributes([
                    ("type", Str("button")),
                ]),
                (
                    on("click", |event|
                        Msg::Submit
                    ),
                )
            ))
        ))
    };

    let update = |state: &mut LoginState, msg: Msg, _: KeyIter, _: &JsIo<Msg>| {
        match msg {
            Msg::UpdateUsername(ref name) => state.username = name.to_owned(),
            Msg::UpdatePassword(ref pw) => state.password = pw.to_owned(),
            Msg::Submit => println!("Do HTTTP here"),
            _ => {}
        };
    };

    // If rendering server-side:
    #[cfg(not(target_os = "emscripten"))]
    println!("HTML: {}", render(&mut state));

    // If rendering client-side with asm.js or WebAssembly:
    #[cfg(target_os = "emscripten")]
    run("body", &update, &render, state);
}
