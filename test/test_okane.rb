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

  it "should parse a complete ofx file header with more than one level deep" do
    xml =<<-OFX
      OFXHEADER:100
      <OFX>
        <SIGNONMSGSRSV1>
          <SONRS>
            <STATUS>
              <CODE>0
              <SEVERITY>INFO
            </STATUS>

            <DTSERVER>20240413000000[-3:GMT]
            <LANGUAGE>POR
          </SONRS>
        </SIGNONMSGSRSV1>
      </OFX>
    OFX

    hash = {
      'OFXHEADER' => '100',
      'OFX' => {
        'SIGNONMSGSRSV1' => {
          'SONRS' => {
            'STATUS' => {
              'CODE' => '0',
              'SEVERITY' => 'INFO'
            },
            'DTSERVER' => '20240413000000[-3:GMT]',
            'LANGUAGE' => 'POR'
          }
        }
      }
    }
    _(Okane::OFX.parse(xml)).must_equal hash
  end

  it "should parse a complete ofx file header with an element with multiple children with same tag" do
    xml =<<-OFX
      OFXHEADER:100
      <OFX>
        <CREDITCARDMSGSRSV1>
          <CCSTMTTRNRS>
            <CCSTMTRS>
              <CURDEF>BRL
              <BANKTRANLIST>
                <DTSTART>20221230000000[-3:GMT]
                <DTEND>20230130000000[-3:GMT]

                <STMTTRN>
                  <TRNTYPE>DEBIT
                  <DTPOSTED>20230126000000[-3:GMT]
                  <TRNAMT>-39.80
                  <FITID>63d05e4b-2649-4732-b6d0-2f6e60cf83ee
                  <MEMO>Mc Donalds - Arcos Dou
                </STMTTRN>

                <STMTTRN>
                  <TRNTYPE>DEBIT
                  <DTPOSTED>20230123000000[-3:GMT]
                  <TRNAMT>-35.00
                  <FITID>63cd46ff-cb85-4bef-b85b-31783996d136
                  <MEMO>Receipt
                </STMTTRN>

              </BANKTRANLIST>
            </CCSTMTRS>
          </CCSTMTTRNRS>
        </CREDITCARDMSGSRSV1>
      </OFX>
    OFX

    hash = {
      'OFXHEADER' => '100',
      'OFX' => {
        'CREDITCARDMSGSRSV1' => {
          'CCSTMTTRNRS' => {
            'CCSTMTRS' => {
              'CURDEF' => 'BRL',
              'BANKTRANLIST' => {
                'DTSTART' => '20221230000000[-3:GMT]',
                'DTEND' => '20230130000000[-3:GMT]',
                'STMTTRN' => [
                  {
                    'TRNTYPE' => 'DEBIT',
                    'DTPOSTED' => '20230126000000[-3:GMT]',
                    'TRNAMT' => '-39.80',
                    'FITID' => '63d05e4b-2649-4732-b6d0-2f6e60cf83ee',
                    'MEMO' => 'Mc Donalds - Arcos Dou',
                  },
                  {
                    'TRNTYPE' => 'DEBIT',
                    'DTPOSTED' => '20230123000000[-3:GMT]',
                    'TRNAMT' => '-35.00',
                    'FITID' => '63cd46ff-cb85-4bef-b85b-31783996d136',
                    'MEMO' => 'Receipt',
                  }
                ]
              }
            }
          }
        }
      }
    }

    _(Okane::OFX.parse(xml)).must_equal hash
  end

  it "should parse a complete ofx file header with an attribute tag that has a self close tag" do
    xml =<<-OFX
      OFXHEADER:100
      <OFX>
        <CREDITCARDMSGSRSV1>
          <CCSTMTTRNRS>
            <CCSTMTRS>
              <CURDEF>BRL
              <BANKTRANLIST>
                <DTSTART>20221230000000[-3:GMT]
                <DTEND>20230130000000[-3:GMT]

                <STMTTRN>
                  <TRNTYPE>DEBIT</TRNTYPE>
                  <DTPOSTED>20230126000000[-3:GMT]</DTPOSTED>
                  <TRNAMT>-39.80</TRNAMT>
                  <FITID>63d05e4b-2649-4732-b6d0-2f6e60cf83ee</FITID>
                  <MEMO>Mc Donalds - Arcos Dou</MEMO>
                </STMTTRN>

                <STMTTRN>
                  <TRNTYPE>DEBIT</TRNTYPE>
                  <DTPOSTED>20230123000000[-3:GMT]</DTPOSTED>
                  <TRNAMT>-35.00</TRNAMT>
                  <FITID>63cd46ff-cb85-4bef-b85b-31783996d136</FITID>
                  <MEMO>Receipt</MEMO>
                </STMTTRN>

              </BANKTRANLIST>
            </CCSTMTRS>
          </CCSTMTTRNRS>
        </CREDITCARDMSGSRSV1>
      </OFX>
    OFX

    hash = {
      'OFXHEADER' => '100',
      'OFX' => {
        'CREDITCARDMSGSRSV1' => {
          'CCSTMTTRNRS' => {
            'CCSTMTRS' => {
              'CURDEF' => 'BRL',
              'BANKTRANLIST' => {
                'DTSTART' => '20221230000000[-3:GMT]',
                'DTEND' => '20230130000000[-3:GMT]',
                'STMTTRN' => [
                  {
                    'TRNTYPE' => 'DEBIT',
                    'DTPOSTED' => '20230126000000[-3:GMT]',
                    'TRNAMT' => '-39.80',
                    'FITID' => '63d05e4b-2649-4732-b6d0-2f6e60cf83ee',
                    'MEMO' => 'Mc Donalds - Arcos Dou',
                  },
                  {
                    'TRNTYPE' => 'DEBIT',
                    'DTPOSTED' => '20230123000000[-3:GMT]',
                    'TRNAMT' => '-35.00',
                    'FITID' => '63cd46ff-cb85-4bef-b85b-31783996d136',
                    'MEMO' => 'Receipt',
                  }
                ]
              }
            }
          }
        }
      }
    }

    _(Okane::OFX.parse(xml)).must_equal hash
  end
end
