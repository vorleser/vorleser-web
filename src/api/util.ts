import { baseUrl } from "config";

async function login(url: string) {
    let response = await fetch(`${window.location.protocol}//${baseUrl}${url}`)
}

