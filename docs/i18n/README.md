# Documentation localizations

The English [root README](../../README.md) is the source document. Translations live in a directory named for their [BCP 47 language tag](https://www.rfc-editor.org/info/bcp47), so readers and contributors can find a language without relying on a platform-specific filename convention.

## Available languages

| Language | Tag | Document | Status |
| --- | --- | --- | --- |
| English | `en` | [README](../../README.md) | Source |
| 한국어 | `ko` | [README](ko/README.md) | Translation |

## Translation conventions

- Use the shortest unambiguous BCP 47 tag. Use `ko`, not `ko-KR`, unless the content genuinely differs by region.
- Store a translation at `docs/i18n/<language-tag>/README.md` and include an `i18n` HTML comment naming its locale and source document.
- Keep command lines, flags, paths, URLs, environment-variable names, and code blocks exactly as in the English source unless the command itself is localized by the software.
- Preserve the source document's heading order and operational meaning. Translate prose, table descriptions, and headings for the reader.
- When adding or updating a translation, update the language selector in the root README and the table above in the same change.

## Adding a language

1. Copy the current root README into `docs/i18n/<language-tag>/README.md`.
2. Add the locale metadata comment and translate only reader-facing text.
3. Add the new language to this registry and to the root README selector.
4. Verify every command, URL, and local Markdown link against the English source before publishing.
