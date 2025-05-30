# Asciidoctor-GFM

An Asciidoctor extension that converts AsciiDoc to GitHub Flavored Markdown (GFM).

## Installation

### As a Ruby Gem

```bash
$ gem install asciidoctor-gfm
```


## Usage Examples

### PlantUML Example

The following AsciiDoc demonstrates how to include PlantUML diagrams:

```adoc
= PlantUML Example
:source-highlighter: rouge
:imagesdir: ./

== Basic Sequence Diagram

[plantuml, format=png]
....
@startuml
Alice -> Bob: Authentication Request
Bob --> Alice: Authentication Response

Alice -> Bob: Another request
Alice <-- Bob: Another response
@enduml
....

== Class Diagram

[plantuml, format=png]
....
@startuml
class Car {
  +Color color
  +int weight
  +start()
  +stop()
}

Driver - Car : drives >
Car *- Wheel : has 4 >
@enduml
....
```

See `examples/plantuml.adoc` for the full example.

## Docker

You can use Asciidoctor-GFM via Docker. The image is published to the GitHub Package Registry.

```bash
$ docker run --rm -v "$PWD:/documents" ghcr.io/medoni/asciidoctor-gfm/asciidoctor-gfm:latest examples/plantuml.adoc
```

The complete usage:
```bash 
$ docker run --rm -v ghcr.io/medoni/asciidoctor-gfm/asciidoctor-gfm:latest
# Usage: asciidoctor-gfm [options] FILE
#     -o, --output FILE                Output file (default: FILE with .md extension)
#     -a, --attribute KEY[=VALUE]      Document attribute to set
#         --[no-]diagrams              Enable or disable diagram processing (default: enabled)
#     -h, --help                       Display this help message
#     -v, --version                    Display version information
```

## Supported Features

The following AsciiDoc and GitHub Flavored Markdown (GFM) features are supported by the converter:

| AsciiDoc Element         | GFM Output                | Notes |
|-------------------------|---------------------------|-------|
| Document Title, Author  | H1, author, date          | Title as H1, author/date as text |
| Section Headings        | #, ##, ###, etc.          | Level mapped to heading depth |
| Paragraphs              | Paragraphs                |       |
| Unordered Lists         | -, nested lists           |       |
| Ordered Lists           | 1., 2., ...               |       |
| Code Blocks (Listing)   | ```lang ... ```           | Language if specified |
| Literal Blocks          | ``` ... ```               | No language |
| Admonitions             | **NOTE:**, **TIP:**, etc. | Rendered as bold label |
| Tables                  | Markdown tables           | Header, separator, body |
| Images                  | ![alt](path "title")     | Respects :imagesdir: |
| Inline Formatting       | **bold**, *italic*, `code`, <sup>sup</sup>, <sub>sub</sub>, <mark>mark</mark> | |
| Links                   | [text](url)               | Xrefs as [text](#anchor) |
| PlantUML Diagrams       | Image references          | With asciidoctor-diagram |

Other AsciiDoc features may be rendered as plain text or not supported. For details, see the [converter.rb](lib/asciidoctor/gfm/converter.rb) implementation.
