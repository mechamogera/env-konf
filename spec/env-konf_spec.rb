require 'spec_helper'
require File.expand_path('../lib/env-konf', File.dirname(__FILE__))

describe EnvKonf do
  describe "get" do
    before :each do
      EnvKonf.profile = nil
    end

    it "should get if profile exist" do
      profile_path = File.join(EnvKonf::ProfileHist.directory, "default.yaml")
      yaml_data = :yaml_data
      File.should_receive(:exist?).with(EnvKonf::ProfileHist.directory).and_return(true)
      File.should_receive(:exist?).with(profile_path).and_return(true)
      YAML.should_receive(:load_file).with(profile_path).and_return(yaml_data)

      EnvKonf.get.should == yaml_data
    end

    it "should get default profile" do
      profile_path = File.join(EnvKonf::ProfileHist.directory, "default.yaml")
      File.should_receive(:exist?).with(EnvKonf::ProfileHist.directory).and_return(true)
      File.should_receive(:exist?).with(profile_path).and_return(false)

      EnvKonf.get.should be_nil
    end

    it "should get switch profile" do
      profile_name = "hoge"
      profile_path = File.join(EnvKonf::ProfileHist.directory, "#{profile_name}.yaml")
      File.should_receive(:exist?).with(EnvKonf::ProfileHist.directory).and_return(true)
      File.should_receive(:exist?).with(profile_path).and_return(false)

      EnvKonf.profile = profile_name
      EnvKonf.get.should be_nil
    end

    it "should mkdir base dir if no exist" do
      profile_path = File.join(EnvKonf::ProfileHist.directory, "default.yaml")
      File.should_receive(:exist?).with(EnvKonf::ProfileHist.directory).and_return(false)
      FileUtils.should_receive(:mkdir_p).with(EnvKonf::ProfileHist.directory).and_return(true)
      File.should_receive(:exist?).with(profile_path).and_return(false)

      EnvKonf.get.should be_nil
    end
  end

  describe "encode decode" do
    around(:each) do |sinario|
      Dir.mktmpdir("env-konf-config-test") do |tmpdir|
        FileUtils.cd(tmpdir) do
          sinario.run
        end 
      end 
    end

    let(:profile) { "test" }
    let(:path) { "./test.zip" }

    it "should encode and decode" do
      EnvKonf.should_receive(:profile_path).with(profile).twice.and_return(__FILE__)
      EnvKonf.encode(:path => path, :profile => profile, :key => test_data_path("id_rsa_pub"))
      EnvKonf.decode(:path => path, :profile => profile, :key => test_data_path("id_rsa"))
    end
  end
end
