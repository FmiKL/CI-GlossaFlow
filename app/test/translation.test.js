import test from "node:test";
import assert from "node:assert/strict";
import { isValidTranslation } from "../src/translations/validation.js";
import { simulateTranslation } from "../src/translations/translation.js";

const translation = {
    source_text: "Bonjour",
    source_language: "fr",
    target_language: "en",
};

test("accepte une translation valide", () => {
    assert.equal(isValidTranslation(translation), true);
});

test("refuse un texte vide", () => {
    assert.equal(isValidTranslation({ ...translation, source_text: "" }), false);
});

test("renvoie un résultat simulé", () => {
    assert.equal(simulateTranslation("Bonjour", "fr", "en"), "[simulation fr->en] Bonjour");
});
