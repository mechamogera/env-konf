require 'spec_helper'
require File.expand_path('../lib/env-konf/zip_profile', File.dirname(__FILE__))

describe EnvKonf::ZipProfile do
  it "should save encode md5" do
    source = "test.yml"
    md5 = "test"
    Digest::MD5.should_receive(:file).with(source).and_return(md5)
    FileUtils.should_receive(:mkdir_p).with(File.dirname(EnvKonf::ZipProfile::FILE))
    YAML::Store.any_instance.stub(:[]=).with(:encode_md5, md5)

    EnvKonf::ZipProfile.save_encode_md5("test.yml")
  end
end
