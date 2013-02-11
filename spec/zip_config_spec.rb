require 'spec_helper'
require File.expand_path('../lib/env-konf/zip_config', File.dirname(__FILE__))
require 'tmpdir'
require 'fileutils'

describe EnvKonf::ZipConfig do
  around(:each) do |sinario|
    Dir.mktmpdir("env-konf-config-test") do |tmpdir|
      FileUtils.cd(tmpdir) do
        sinario.run
      end
    end
  end

  it "should get nil if dir is not exist" do
    EnvKonf::ZipConfig.profile.should be_nil
    EnvKonf::ZipConfig.zip_path.should be_nil
    EnvKonf::ZipConfig.passwd_md5.should be_nil
  end

  it "should get nil if file is not exist" do
    FileUtils.mkdir_p(File.dirname(EnvKonf::ZipConfig::FILE))
    EnvKonf::ZipConfig.profile.should be_nil
    EnvKonf::ZipConfig.zip_path.should be_nil
    EnvKonf::ZipConfig.passwd_md5.should be_nil
  end

  it "should exist file if added value and not exist file" do
    profile = "hoge"
    EnvKonf::ZipConfig.profile = profile
    File.exist?(EnvKonf::ZipConfig::FILE).should be_true
  end

  it "should added values" do
    [:profile, :zip_path].each do |target|
      EnvKonf::ZipConfig.send("#{target}=", target.to_s)
      EnvKonf::ZipConfig.send(target).should == target.to_s
    end
  end

  it "should get md5 password" do
    password = "test"
    EnvKonf::ZipConfig.passwd_md5 = password
    EnvKonf::ZipConfig.passwd_md5.should_not be_nil
    EnvKonf::ZipConfig.passwd_md5.should_not == password
    EnvKonf::ZipConfig.equal_passwd_md5(password).should be_true
    EnvKonf::ZipConfig.equal_passwd_md5("aaa").should be_false
  end
end
