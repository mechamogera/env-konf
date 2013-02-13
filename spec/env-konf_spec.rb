require 'spec_helper'
require File.expand_path('../lib/env-konf', File.dirname(__FILE__))

describe EnvKonf do
  before :each do
    EnvKonf.profile = nil
  end

  it "should get if profile exist" do
    profile_path = File.join(EnvKonf::Config.directory, "default.yaml")
    yaml_data = :yaml_data
    File.should_receive(:exist?).with(EnvKonf::Config.directory).and_return(true)
    File.should_receive(:exist?).with(profile_path).and_return(true)
    YAML.should_receive(:load_file).with(profile_path).and_return(yaml_data)

    EnvKonf.get.should == yaml_data
  end

  it "should get default profile" do
    profile_path = File.join(EnvKonf::Config.directory, "default.yaml")
    File.should_receive(:exist?).with(EnvKonf::Config.directory).and_return(true)
    File.should_receive(:exist?).with(profile_path).and_return(false)

    EnvKonf.get.should be_nil
  end

  it "should get switch profile" do
    profile_name = "hoge"
    profile_path = File.join(EnvKonf::Config.directory, "#{profile_name}.yaml")
    File.should_receive(:exist?).with(EnvKonf::Config.directory).and_return(true)
    File.should_receive(:exist?).with(profile_path).and_return(false)

    EnvKonf.profile = profile_name
    EnvKonf.get.should be_nil
  end

  it "should mkdir base dir if no exist" do
    profile_path = File.join(EnvKonf::Config.directory, "default.yaml")
    File.should_receive(:exist?).with(EnvKonf::Config.directory).and_return(false)
    FileUtils.should_receive(:mkdir_p).with(EnvKonf::Config.directory).and_return(true)
    File.should_receive(:exist?).with(profile_path).and_return(false)

    EnvKonf.get.should be_nil
  end
end
