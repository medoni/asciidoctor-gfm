# frozen_string_literal: true

require_relative 'lib/asciidoctor/gfm/version'

Gem::Specification.new do |spec|
  spec.name          = 'asciidoctor-gfm'
  spec.version       = Asciidoctor::GFM::VERSION
  spec.authors       = ['https://github.com/medoni']
  spec.email         = ['https://github.com/medoni']

  spec.summary       = 'Asciidoctor converter for GitHub Flavored Markdown'
  spec.description   = 'An Asciidoctor extension that converts AsciiDoc to GitHub Flavored Markdown'
  spec.homepage      = 'https://github.com/medoni/asciidoctor-gfm'
  spec.license       = 'MIT'
  spec.required_ruby_version = Gem::Requirement.new('>= 2.7.0')

  spec.metadata['homepage_uri'] = spec.homepage
  spec.metadata['source_code_uri'] = spec.homepage
  spec.metadata['changelog_uri'] = "#{spec.homepage}/blob/main/CHANGELOG.md"

  spec.files         = Dir.glob('{bin,lib,examples}/**/*') + %w[LICENSE README.md]
  spec.bindir        = 'bin'
  spec.executables   = ['asciidoctor-gfm']
  spec.require_paths = ['lib']

  spec.add_dependency 'asciidoctor', '~> 2.0'
  spec.add_dependency 'asciidoctor-diagram', '~> 2.2'
  spec.add_development_dependency 'minitest', '~> 5.0'
  spec.add_development_dependency 'rake', '~> 13.0'
end
