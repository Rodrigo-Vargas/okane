module Okane
  ENUMERABLE_TAGS = ["STMTTRN"]

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


          if (target_object.class == Hash)
            target_object[tag] = value.to_s
          else
            target_object.last()[tag] = value.to_s
          end
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

            if (Okane::ENUMERABLE_TAGS.find_index(tag) != nil)
              if (target_object[tag] == nil)
                target_object[tag] = []
              end

              target_object[tag].append({})
            else
              target_object[tag] = {}
            end
          else
            result[tag] = {}
          end

          tag_stack.append(tag)

        elsif (line.size == 0)
          # Do nothing
        else
          puts line
          puts "No pattern found"
        end
      end

      return result
    end
  end
end
