require 'minitest/autorun'
require 'okane'

describe Okane::OFX do
  it "should transform a basic ofx file header" do
    ofx_content = "OFXHEADER:100"

    hash = {
      'OFXHEADER' => '100'
    }

    _(Okane::OFX.parse(ofx_content)).must_equal hash
  end
end
