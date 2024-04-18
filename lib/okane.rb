module Okane
  class OFX
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
          match = attribute_tag_pattern.match(line)
          tag = match[1]
          value = match[2]

          target_object = result.dig(*tag_stack)
          target_object[tag] = value.to_s
        elsif (header_pattern.match?(line))
          match = header_pattern.match(line)
          result[match[1]] = match[2]
        elsif (aggregate_closing_tag_pattern.match?(line))
          tag_stack.pop
        elsif (aggregate_tag_pattern.match?(line))
          match = aggregate_tag_pattern.match(line)
          tag = match[1]

          if (tag_stack.count > 0)
            target_object = result.dig(*tag_stack)

            target_object[tag] = {}
          else
            result[tag] = {}
          end

          tag_stack.append(tag)

        else
          puts "No pattern found"
        end
      end

      return result
    end
  end
end
