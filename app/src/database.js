import { readFileSync } from "node:fs";
import pg from "pg";

const pool = new pg.Pool({
    password: readFileSync(process.env.DB_PASSWORD_FILE, "utf8").trim(),
    connectionTimeoutMillis: 2000,
    query_timeout: 2000,
});

pool.on("error", () => console.error("Connexion PostgreSQL interrompue."));

export async function createTranslation(translation) {
    const { id, source_text, source_language, target_language, translated_text } = translation;
    const result = await pool.query(
        `INSERT INTO app.translations
            (id, source_text, source_language, target_language, translated_text)
         VALUES ($1, $2, $3, $4, $5)
         RETURNING *`,
        [id, source_text, source_language, target_language, translated_text],
    );
    return result.rows[0];
}

export async function getTranslation(id) {
    const result = await pool.query("SELECT * FROM app.translations WHERE id = $1", [id]);
    return result.rows[0];
}

export async function checkDatabase() {
    await pool.query("SELECT 1 FROM app.translations LIMIT 1");
}
