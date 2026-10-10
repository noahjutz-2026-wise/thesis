# Bachelorarbeit

![Typst v0.15.1](https://img.shields.io/badge/Typst-v0.15.1-239dad?logo=typst)
![PDF/A-3b](https://img.shields.io/badge/PDF-A--3b-007ec6)
## Development

```bash
tinymist preview \
    --ignore-system-fonts \
    --font-path src \
    --pdf-standard a-3b \
    --input GIT_HASH="$(git rev-parse --short HEAD)" \
    --input GIT_TAG="$(git describe --tags --exact-match)" \
    --root . \
    src/main.typ
```

## Compiling

To PDF:

```bash
typst compile \
    --ignore-system-fonts \
    --font-path src \
    --pdf-standard a-3b \
    --input GIT_HASH="$(git rev-parse --short HEAD)" \
    --input GIT_TAG="$(git describe --tags --exact-match)" \
    --root . \
    src/main.typ
```

To TXT:

```bash
typst compile \
    --ignore-system-fonts \
    --font-path src \
    --features html \
    --format html \
    --input GIT_HASH="$(git rev-parse --short HEAD)" \
    --input GIT_TAG="$(git describe --tags --exact-match)" \
    --root . \
    src/main.typ && \
    pandoc src/main.html -o main.txt
```


