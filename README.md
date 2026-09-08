# Bachelorarbeit

![Typst v0.15.1](https://img.shields.io/badge/Typst-v0.15.1-239dad?logo=typst)
![PDF/A-3b](https://img.shields.io/badge/PDF-A--3b-007ec6)

## Development

```sh
tinymist preview --ignore-system-fonts --font-path src/assets --pdf-standard a-3b --input revision=$(git rev-parse --short HEAD) --root . src/main.typ
```

## Compiling

```sh
typst c --ignore-system-fonts --font-path src --pdf-standard a-3b --input revision=$(git rev-parse --short HEAD) --root . src/main.typ
```
