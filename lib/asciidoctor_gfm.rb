# frozen_string_literal: true

# Add /app/lib to $LOAD_PATH for Docker, and local lib for dev
lib_paths = [File.expand_path('..', __dir__), '/app/lib']
lib_paths.each do |path|
  $LOAD_PATH.unshift(path) unless $LOAD_PATH.include?(path)
end

require 'asciidoctor/gfm/converter'
require 'asciidoctor/gfm/version'

Asciidoctor::GFM::Converter.register_for 'gfm'
