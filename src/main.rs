extern crate domafic;
use domafic::tags::{button, div, h1, form, input, attributes, Tag};
use domafic::AttributeValue::{Str, OwnedStr, Bool};
use domafic::listener::on;
use domafic::{DomNode, DomNodes, DomValue, KeyValue, Listeners};
#[cfg(target_os = "emscripten")]
use domafic::web_render::{run, JsIo, HttpRequest, HttpResult};

// If rendering client-side with asm.js or WebAssembly:
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

enum Message {
    Login,
    Register,
}

#[derive(Debug)]
enum Msg {
    Submit,
    UpdateUsername(String),
    UpdatePassword(String),
    Received(String),
    LoggedIn,
    ConnectionError(String),
    None
}


// impl State {
//     fn new() -> Self {
//         State {
//             login_state: LoginState{username: "".to_owned(), password: "".to_owned()},
//             view: AppView::Login
//         }
//     }
// }

impl LoginState {
    fn new() -> Self {
        Self {username: "".to_owned(), password: "".to_owned()}
    }

    #[cfg(target_os = "emscripten")]
    fn update(&mut self, msg: Msg, js_io: &JsIo<Msg>) {
        match msg {
            Msg::UpdateUsername(ref name) => self.username = name.to_owned(),
            Msg::UpdatePassword(ref pw) => self.password = pw.to_owned(),
            Msg::Submit => {
                js_io.http(HttpRequest {
                    method: "POST",
                    headers: &[],
                    url: "localhost:8000/login",
                    body: "",
                    timeout_millis: None,
                }, Box::new(|response: HttpResult|
                    match response {
                        Ok(_) => Msg::LoggedIn,
                        Err(r) => Msg::ConnectionError("Can't login, check your network connection.".to_owned())
                    }
                ));
            }
            Msg::LoggedIn => println!("Yaaay, logged in!"),
            _ => {}
        };
    }

//     fn render (&self) {
//     div ((
//         input((
//             attributes([
//                 ("type", Str("text"))
//                 (
//                 on("click", |event|
//                     Msg::Submit
//                 ),
//                 )
//             ]),
//         ))
//     ))
//     }
}


fn main() {
    let state = LoginState::new();
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

    #[cfg(target_os = "emscripten")]
    let update = |state: &mut LoginState, msg: Msg, _: KeyIter, js_io: &JsIo<Msg>| {
        state.update(msg, js_io);
    };

    // If rendering server-side:
    #[cfg(not(target_os = "emscripten"))]
    println!("HTML: {}", render(&mut state));

    // If rendering client-side with asm.js or WebAssembly:
    #[cfg(target_os = "emscripten")]
    run("body", &update, &render, state);
}
