require 'spec_helper'
require File.expand_path('../lib/env-konf/zip_profile', File.dirname(__FILE__))

describe EnvKonf::ZipProfile do
  around(:each) do |sinario|
    Dir.mktmpdir("env-konf-zipprofile-test") do |tmpdir|
      FileUtils.cd(tmpdir) do
        sinario.run
      end
    end
  end

  it "should save encode md5" do
    source = "test.yml"
    md5 = "test"
    profile = "test/config.yaml"

    Digest::MD5.should_receive(:file).with(source).and_return(md5)

    mkdir_p_original = FileUtils.method(:mkdir_p)
    FileUtils.should_receive(:mkdir_p).with(
      File.dirname(EnvKonf::ZipProfile::FILE)
    ) { mkdir_p_original.call(File.dirname(profile)) }
    
    new_original = YAML::Store.method(:new)
    YAML::Store.should_receive(:new).with(EnvKonf::ZipProfile::FILE) {
      new_original.call(profile)
    }

    EnvKonf::ZipProfile.save_encode_md5("test.yml")
    YAML.load_file(profile).should == { :encode_md5 => md5 }
  end
end
