require 'spec_helper'
load File.expand_path('../bin/env-konf', File.dirname(__FILE__))

describe EnvKonfCommand do
  let(:profile) { "hoge" }
  let(:target_path) { "test/zip" }
  let(:password) { "pass" }
  let(:key) { "key" }
  let(:encode_key) { "enc_key" }
  let(:decode_key) { "dec_key" }

  it "should get help message" do
    stdstr = capture(:stdout) {
      proc {
        EnvKonfCommand.run(["-h"]) 
      }.should raise_error(SystemExit)
    }
    stdstr.should match /^Subcommands:/
    stdstr.should match /^Options:/
  end

  it "should profile-init" do
    EnvKonf.should_receive(:profile_init).with(profile).and_return("test")
    capture(:stdout) {
      EnvKonfCommand.run(%W|profile-init #{profile}|)
    }.should match /create\s+test/
  end

  it "should zip" do
    EnvKonf.should_receive(:zip) do |arg|
      arg[:force].should == true
      arg[:password].should == "pass"
      arg[:path].should == "test/zip"
    end
    EnvKonfCommand.run(%w|zip -f -p pass test/zip|)
  end

  it "should unzip" do
    EnvKonf.should_receive(:unzip) do |arg|
      arg[:force].should == true
      arg[:password].should == password
      arg[:path].should == target_path
    end
    EnvKonfCommand.run(%W|unzip -f -p #{password} #{target_path}|)
  end

  it "should zip-config" do
    EnvKonf::Config.should_receive(:passwd_md5=).with(password)
    EnvKonf::Config.should_receive(:target_path=).with(target_path)
    EnvKonf::Config.should_receive(:profile=).with(profile)
    EnvKonf::Config.should_receive(:encode_key=).with(encode_key)
    EnvKonf::Config.should_receive(:decode_key=).with(decode_key)
    EnvKonfCommand.run(%W|zip-config -p #{password} -z #{target_path} -r #{profile} --rsa-encode-key #{encode_key} --rsa-decode-key #{decode_key}|)
  end

  it "should encode" do
    EnvKonf.should_receive(:encode) do |arg|
      arg[:force].should == true
      arg[:key].should == key
      arg[:path].should == target_path
      arg[:profile].should == profile
    end
    EnvKonfCommand.run(%W|encode #{target_path} -f -k #{key} --profile #{profile}|)
  end

  it "should decode" do
    EnvKonf.should_receive(:decode) do |arg|
      arg[:force].should == true
      arg[:key].should == key
      arg[:path].should == target_path
      arg[:profile].should == profile
    end
    EnvKonfCommand.run(%W|decode #{target_path} -f -k #{key} --profile #{profile}|)
  end
end

