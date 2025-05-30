ARG VERSION=1.0.0

FROM ruby:3.2-slim
    ARG VERSION
    # Install PlantUML and dependencies
    RUN apt-get update && apt-get install -y \
        default-jre \
        graphviz \
        wget \
        unzip \
        && rm -rf /var/lib/apt/lists/*
    RUN mkdir -p /usr/local/share/plantuml && \
        wget -q https://github.com/plantuml/plantuml/releases/download/v1.2023.10/plantuml-1.2023.10.jar -O /usr/local/share/plantuml/plantuml.jar && \
        echo '#!/bin/bash\njava -jar /usr/local/share/plantuml/plantuml.jar "$@"' > /usr/local/bin/plantuml && \
        chmod +x /usr/local/bin/plantuml

    WORKDIR /app

    # Install dependencies
    RUN mkdir -p /app/lib/asciidoctor/gfm
    COPY Gemfile Gemfile.lock* ./
    COPY asciidoctor-gfm.gemspec ./
    COPY lib/asciidoctor/gfm/version.rb ./lib/asciidoctor/gfm/
    COPY lib/asciidoctor/gfm/converter.rb ./lib/asciidoctor/gfm/
    COPY lib/asciidoctor_gfm.rb ./lib/
    RUN bundle install

    # Build asciidoctor-gfm
    COPY bin/ ./bin/
    RUN chmod +x bin/asciidoctor-gfm
    RUN ln -s /app/bin/asciidoctor-gfm /usr/local/bin/asciidoctor-gfm

    VOLUME ["/documents"]
    WORKDIR /documents

    ENTRYPOINT ["asciidoctor-gfm"]
    CMD ["--help"]

    LABEL org.opencontainers.image.title="asciidoctor-gfm" \
        org.opencontainers.image.description="Asciidoctor extension for GitHub Flavored Markdown (GFM) with PlantUML support" \
        org.opencontainers.image.version="$VERSION" \
        org.opencontainers.image.url="https://github.com/medoni/asciidoctor-gfm/pkgs/container/asciidoctor-gfm%2Fasciidoctor-gfm" \
        org.opencontainers.image.source="https://github.com/medoni/asciidoctor-gfm" \
        org.opencontainers.image.licenses="MIT" \
        org.opencontainers.image.authors="https://github.com/medoni"
