import { createServer } from "node:http";
import { randomUUID } from "node:crypto";
import { checkDatabase, createTranslation, getTranslation } from "./database.js";
import { isValidTranslation } from "./translations/validation.js";
import { simulateTranslation } from "./translations/translation.js";

function sendJson(response, status, body) {
    response.writeHead(status, { "Content-Type": "application/json; charset=utf-8" });
    response.end(JSON.stringify(body));
}

async function handleHealth(response) {
    await checkDatabase();
    return sendJson(response, 200, { status: "ok" });
}

async function handleGetTranslation(id, response) {
    const translation = await getTranslation(id);
    if (!translation) {
        return sendJson(response, 404, { error: "Traduction introuvable." });
    }
    return sendJson(response, 200, translation);
}

async function handleCreateTranslation(request, response) {
    let body = "";
    request.setEncoding("utf8");
    for await (const chunk of request) body += chunk;

    let data;
    try {
        data = JSON.parse(body);
    } catch {
        return sendJson(response, 400, { error: "JSON invalide." });
    }
    if (!isValidTranslation(data)) {
        return sendJson(response, 400, { error: "Requête invalide." });
    }

    const { source_text, source_language, target_language } = data;
    const translation = await createTranslation({
        id: randomUUID(),
        source_text,
        source_language,
        target_language,
        translated_text: simulateTranslation(source_text, source_language, target_language),
    });
    response.setHeader("Location", `/translations/${translation.id}`);
    return sendJson(response, 201, translation);
}

createServer(async (request, response) => {
    try {
        if (request.method === "GET" && request.url === "/health") {
            return await handleHealth(response);
        }

        const translationMatch = request.url.match(/^\/translations\/([^/]+)$/);
        if (request.method === "GET" && translationMatch) {
            return await handleGetTranslation(translationMatch[1], response);
        }

        if (request.method === "POST" && request.url === "/translations") {
            return await handleCreateTranslation(request, response);
        }

        sendJson(response, 404, { error: "Route introuvable." });
    } catch {
        sendJson(response, 503, { error: "Service indisponible." });
    }
}).listen(3000, "0.0.0.0");
