require 'spec_helper'
load File.expand_path('../bin/env-konf', File.dirname(__FILE__))

describe EnvKonfCommand do
  let(:profile) { "hoge" }
  let(:zip_path) { "test/zip" }
  let(:password) { "pass" }

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
      arg[:path].should == zip_path
    end
    EnvKonfCommand.run(%W|unzip -f -p #{password} #{zip_path}|)
  end

  it "should zip-config" do
    EnvKonf::Config.should_receive(:passwd_md5=).with(password)
    EnvKonf::Config.should_receive(:zip_path=).with(zip_path)
    EnvKonf::Config.should_receive(:profile=).with(profile)
    EnvKonfCommand.run(%W|zip-config -p #{password} -z #{zip_path} -r #{profile}|)
  end
end

