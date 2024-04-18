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

  it "should parse a complete ofx file header" do
    xml =<<-OFX
      OFXHEADER:100
      DATA:OFXSGML
      VERSION:102
      SECURITY:NONE
      ENCODING:USASCII
      CHARSET:1252
      COMPRESSION:NONE
      OLDFILEUID:NONE
      NEWFILEUID:NONE
    OFX

    hash = {
      'OFXHEADER' => '100',
      'DATA' => 'OFXSGML',
      'VERSION' => '102',
      'SECURITY' => 'NONE',
      'ENCODING' => 'USASCII',
      'CHARSET' => '1252',
      'COMPRESSION' => 'NONE',
      'OLDFILEUID' => 'NONE',
      'NEWFILEUID' => 'NONE'
    }
    _(Okane::OFX.parse(xml)).must_equal hash
  end

  it "should parse a complete ofx file header and a opening tag" do
    xml =<<-OFX
      OFXHEADER:100
      DATA:OFXSGML
      VERSION:102
      SECURITY:NONE
      ENCODING:USASCII
      CHARSET:1252
      COMPRESSION:NONE
      OLDFILEUID:NONE
      NEWFILEUID:NONE
      <OFX>
      <DTSERVER>20240413000000[-3:GMT]
      </OFX>
    OFX

    hash = {
      'OFXHEADER' => '100',
      'DATA' => 'OFXSGML',
      'VERSION' => '102',
      'SECURITY' => 'NONE',
      'ENCODING' => 'USASCII',
      'CHARSET' => '1252',
      'COMPRESSION' => 'NONE',
      'OLDFILEUID' => 'NONE',
      'NEWFILEUID' => 'NONE',
      'OFX' => {
        'DTSERVER' => '20240413000000[-3:GMT]'
      }
    }
    _(Okane::OFX.parse(xml)).must_equal hash
  end
end
