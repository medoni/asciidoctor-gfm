# frozen_string_literal: true

require 'asciidoctor'
require 'asciidoctor/converter'

module Asciidoctor
  module GFM
    # Converter for GitHub Flavored Markdown backend for Asciidoctor
    class Converter < Asciidoctor::Converter::Base
      register_for 'gfm'

      def convert_document(node, _transform = nil)
        doc = []
        doc << convert_header(node)
        doc << convert_content(node)
        doc.compact.join("\n\n")
      end

      def convert_section(node, _transform = nil)
        title_level = node.level
        header = "#{'#' * title_level} #{node.title}"
        [header, convert_content(node)].join("\n\n")
      end

      def convert_paragraph(node, _transform = nil)
        node.content
      end

      def convert_listing(node, _transform = nil)
        language = node.attr('language', 'plain')
        ["```#{language}", node.content, '```'].join("\n")
      end

      def convert_literal(node, _transform = nil)
        ['```', node.content, '```'].join("\n")
      end

      def convert_admonition(node, _transform = nil)
        type = node.attr('name', 'note').upcase
        ["**#{type}:**", node.content].join("\n\n")
      end

      def convert_ulist(node, _transform = nil)
        result = []
        node.items.each do |item|
          result << "- #{item.text}"
          result << convert_content(item) if item.blocks?
        end
        result.join("\n")
      end

      def convert_olist(node, _transform = nil)
        result = []
        node.items.each_with_index do |item, index|
          result << "#{index + 1}. #{item.text}"
          result << convert_content(item) if item.blocks?
        end
        result.join("\n")
      end

      def convert_table(node, _transform = nil)
        result = []
        header_row = node.rows.head[0]
        result << "| #{header_row.map(&:text).join(' | ')} |"
        result << "| #{header_row.map { |_| '---' }.join(' | ')} |"
        node.rows.body.each do |row|
          result << "| #{row.map(&:text).join(' | ')} |"
        end
        result.join("\n")
      end

      def convert_image(node, _transform = nil)
        imagesdir = node.document.attr('imagesdir') || '.'
        target = node.attr('target')
        image_path_md = if imagesdir != '.' && imagesdir != './' && target !~ %r{^(?:[a-z]+:)?//}
                          File.join(imagesdir, target)
                        else
                          target
                        end
        title = node.attr('title') ? " \"#{node.attr('title')}\"" : ''
        "![#{node.attr('alt')}](#{image_path_md}#{title})"
      end

      def convert_inline_quoted(node, _transform = nil)
        case node.type
        when :strong
          "**#{node.text}**"
        when :emphasis
          "*#{node.text}*"
        when :monospaced
          "`#{node.text}`"
        when :superscript
          "<sup>#{node.text}</sup>"
        when :subscript
          "<sub>#{node.text}</sub>"
        when :mark
          "<mark>#{node.text}</mark>"
        else
          node.text
        end
      end

      def convert_inline_anchor(node, _transform = nil)
        case node.type
        when :link
          "[#{node.text}](#{node.target})"
        when :xref
          "[#{node.text.empty? ? node.target : node.text}](##{node.target})"
        else
          node.text
        end
      end

      def convert_header(node)
        return nil unless node.header?

        result = []
        result << "# #{node.doctitle}" if node.header?
        if node.attr?('author') || node.attr?('email')
          author_line = []
          author_line << node.attr('author') if node.attr?('author')
          author_line << "<#{node.attr('email')}>" if node.attr?('email')
          result << "*By #{author_line.join(' ')}*"
        end
        result << "_#{node.attr('revdate')}_" if node.attr?('revdate')
        result.join("\n\n")
      end

      def convert_content(node)
        node.blocks.map { |b| convert(b) }.compact.join("\n\n")
      end
    end
  end
end
