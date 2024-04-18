module Okane
  class OFX
    AGGREGATE_TAGS = ["OFX"]

    def self.parse(content)
      lines = content.split("\n")

      result = {}

      tag_stack = []

      lines.each do |line|
        header_pattern = /(.+):(.+)/
        aggregate_tag_pattern = /<(.+)>/
        aggregate_closing_tag_pattern = /<\/(.+)>/
        attribute_tag_pattern = /<(.+)>(.+)/

        line = line.strip

        if (attribute_tag_pattern.match?(line))
          puts "attribute_tag_pattern"
          match = attribute_tag_pattern.match(line)
          tag = match[1]
          value = match[2]
          result[tag_stack.first][tag] = value.to_s
        elsif (header_pattern.match?(line))
          match = header_pattern.match(line)
          result[match[1]] = match[2]
        elsif (aggregate_closing_tag_pattern.match?(line))
          tag_stack.pop
          puts "No pattern found"
        elsif (aggregate_tag_pattern.match?(line))
          match = aggregate_tag_pattern.match(line)
          tag = match[1]
          result[tag] = {}
          tag_stack.append(tag)
        end
      end

      return result
    end
  end
end
