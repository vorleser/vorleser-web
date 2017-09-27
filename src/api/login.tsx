import { baseUrl } from "config";

async function login(username: string, password: string): Promise<JSON> {
    let response = await fetch(
        `${window.location.protocol}//${baseUrl}/login`,
        {
            method: "POST",
            body: JSON.stringify({
                user: username,
                password: password
            })
        }
    );
    return response.json();
}
