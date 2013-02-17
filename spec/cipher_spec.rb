require 'spec_helper'
require File.expand_path('../lib/env-konf/cipher', File.dirname(__FILE__))

describe EnvKonf::Cipher do
  it "should encode and decode" do
    cipher = EnvKonf::Cipher.new
    enc_data = cipher.encode("test", test_data_path("id_rsa"))
    cipher.decode(enc_data, test_data_path("id_rsa")).should == "test"
  end
end
