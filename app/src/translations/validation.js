export function isValidTranslation(data) {
    if (data === null || typeof data !== "object") {
        return false;
    }

    const { source_text, source_language, target_language } = data;
    if (
        typeof source_text !== "string" ||
        source_text.trim() === "" ||
        source_text.length > 1000
    ) {
        return false;
    }

    return (
        (source_language === "fr" && target_language === "en") ||
        (source_language === "en" && target_language === "fr")
    );
}
