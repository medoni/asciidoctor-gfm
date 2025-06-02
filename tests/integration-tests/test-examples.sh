#!/bin/bash

# Usage:
#   ./test-examples.sh [IMAGE_NAME]
#
# IMAGE_NAME (optional): Docker image to use. Defaults to 'asciidoctor-gfm/asciidoctor-gfm'.
#
# This script runs integration tests using the specified Docker image.

IMAGE_NAME=${1:-asciidoctor-gfm/asciidoctor-gfm}
SCRIPT_DIR="$(dirname -- "$0")"
EXAMPLES_DIR="$(realpath $SCRIPT_DIR/../../examples)"

echo $EXAMPLES_DIR

test_examples_plantuml() {
  docker run --rm -v "$EXAMPLES_DIR:/documents" "$IMAGE_NAME:latest" /documents/plantuml.adoc

  if [ ! -f "$EXAMPLES_DIR/plantuml.md" ]; then
    echo "Markdown file was not created!" >&2
    exit 1
  fi

  if ! grep -q "!\[basic sequence diagram\](basic-sequence-diagram.png)" "$EXAMPLES_DIR/plantuml.md"; then
    echo "Markdown file missing basic sequence diagram reference" >&2
    exit 1
  fi

  if ! grep -q "!\[class diagram\](class-diagram.png)" "$EXAMPLES_DIR/plantuml.md"; then
    echo "Markdown file missing class diagram reference" >&2
    exit 1
  fi

  if [ ! -f "$EXAMPLES_DIR/basic-sequence-diagram.png" ]; then
    echo "Basic sequence diagram image not found" >&2
    exit 1
  fi

  if [ ! -f "$EXAMPLES_DIR/class-diagram.png" ]; then
    echo "Class diagram image not found" >&2
    exit 1
  fi
}

test_examples_plantuml "$1"
