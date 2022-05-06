export function genRandomID(): string {
    const str = Math.random().toString(36) + Math.random().toString(36);

    return str
        .replace(/[^A-Za-z]/g, 'ABCDEFGH'[Math.floor(Math.random() * 10)])
        .replace(/\./g, '')
        .slice(0, 7);
}
