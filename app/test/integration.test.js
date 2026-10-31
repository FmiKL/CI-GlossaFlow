import test from "node:test";
import assert from "node:assert/strict";

const baseUrl = "http://127.0.0.1:8080";

test("enregistre et lit une traduction", async () => {
    const health = await fetch(`${baseUrl}/health`);
    assert.equal(health.status, 200);
    
    const response = await fetch(`${baseUrl}/translations`, {
        method: "POST",
        headers: { "Content-Type": "application/json" },
        body: JSON.stringify({
            source_text: "Bonjour",
            source_language: "fr",
            target_language: "en",
        }),
    });
    assert.equal(response.status, 201);

    const translation = await response.json();
    const read = await fetch(`${baseUrl}/translations/${translation.id}`);
    
    assert.equal(read.status, 200);
    assert.deepEqual(await read.json(), translation);
});
