FROM docker.io/123marvin123/typst:0.15.1

ARG GIT_HASH
ARG GIT_TAG
ENV GIT_HASH=${GIT_HASH}
ENV GIT_TAG=${GIT_TAG}

WORKDIR /app

COPY src src

CMD [ \
    "typst", \
    "compile", \
    "src/main.typ", \
    "/output/main.pdf", \
    "--ignore-system-fonts", \
    "--font-path", \
    "src/assets", \
    "--pdf-standard", \
    "a-3b", \
    "--input ", \
    "GIT_HASH=${GIT_HASH}", \
    "GIT_TAG=${GIT_TAG}", \
    "--root", \
    "src" \
]
