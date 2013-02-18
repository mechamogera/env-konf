require 'spec_helper'
require File.expand_path('../lib/env-konf/cipher', File.dirname(__FILE__))

describe EnvKonf::Cipher do
  let(:source_str) do
    elem = "a"
    str = ""
    26.times do |i|
      str += elem * (i + 1)
      str += "\n"
      elem = elem.next
    end
    str
  end

  it "should encode and decode" do
    cipher = EnvKonf::Cipher.new
    
    enc_data = cipher.encode(source_str, test_data_path("id_rsa_pub"))
    cipher.decode(enc_data, test_data_path("id_rsa")).should == source_str
  end
end
