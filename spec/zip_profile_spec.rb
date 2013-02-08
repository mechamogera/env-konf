require 'spec_helper'
require File.expand_path('../lib/env-konf/zip_profile', File.dirname(__FILE__))

describe EnvKonf::ZipProfile do
  let(:source) { "test.yml" } 
  let(:md5) { "test" }
  let(:profile_path) { "test/config.yaml" }
  let(:profile) { "test" }

  around(:each) do |sinario|
    Dir.mktmpdir("env-konf-zipprofile-test") do |tmpdir|
      FileUtils.cd(tmpdir) do
        sinario.run
      end
    end
  end

  it "should not match if no exist record" do
    md5_obj = double("md5_obj", :hexdigest => md5)
    Digest::MD5.should_receive(:file).twice.with(source).and_return(md5_obj)

    EnvKonf::ZipProfile.match_encoded?(profile, source).should be_false
    EnvKonf::ZipProfile.match_decoded?(profile, source).should be_false
  end

  it "should save encode md5" do
    md5_obj = double("md5_obj", :hexdigest => md5)
    Digest::MD5.should_receive(:file).twice.with(source).and_return(md5_obj)

    mkdir_p_original = FileUtils.method(:mkdir_p)
    FileUtils.should_receive(:mkdir_p).with(
      File.dirname(EnvKonf::ZipProfile::FILE)
    ) { mkdir_p_original.call(File.dirname(profile_path)) }
    
    new_original = YAML::Store.method(:new)
    YAML::Store.should_receive(:new).with(EnvKonf::ZipProfile::FILE) {
      new_original.call(profile_path)
    }

    EnvKonf::ZipProfile.save_encode_md5(profile, source)
    YAML.load_file(profile_path).should == {profile => { :encode_md5 => md5 }}

    YAML.should_receive(:load_file).twice.with(EnvKonf::ZipProfile::FILE).and_return(profile => { :encode_md5 => md5 })
    EnvKonf::ZipProfile.match_encoded?(profile, source).should be_true

    Digest::MD5.should_receive(:file).with(__FILE__).and_call_original
    EnvKonf::ZipProfile.match_encoded?(profile, __FILE__).should be_false
  end

  it "should save decode md5" do
    md5_obj = double("md5_obj", :hexdigest => md5)
    Digest::MD5.should_receive(:file).twice.with(source).and_return(md5_obj)

    mkdir_p_original = FileUtils.method(:mkdir_p)
    FileUtils.should_receive(:mkdir_p).with(
      File.dirname(EnvKonf::ZipProfile::FILE)
    ) { mkdir_p_original.call(File.dirname(profile_path)) }
    
    new_original = YAML::Store.method(:new)
    YAML::Store.should_receive(:new).with(EnvKonf::ZipProfile::FILE) {
      new_original.call(profile_path)
    }

    EnvKonf::ZipProfile.save_decode_md5(profile, source)
    YAML.load_file(profile_path).should == {profile => { :decode_md5 => md5 }}
    
    YAML.should_receive(:load_file).twice.with(EnvKonf::ZipProfile::FILE).and_return(profile => { :decode_md5 => md5 })
    EnvKonf::ZipProfile.match_decoded?(profile, source).should be_true

    Digest::MD5.should_receive(:file).with(__FILE__).and_call_original
    EnvKonf::ZipProfile.match_decoded?(profile, __FILE__).should be_false
  end
end
