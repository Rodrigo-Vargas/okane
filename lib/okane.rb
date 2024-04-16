module Okane
  class OFX
    def self.parse(content)
      lines = content.split("\n")

      result = {}

      lines.each do |line|
        match = /(.+):(.+)/.match(line)
        result[match[1].strip] = match[2]
      end

      return result
    end
  end
end
