module Okane
  class OFX
    def self.parse(content)
      match = /OFXHEADER:(.+)/.match(content)

      return {
        "OFXHEADER" => match[1]
      }
    end
  end
end
