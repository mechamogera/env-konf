require 'spec_helper'
require File.expand_path('../lib/env-konf/config', File.dirname(__FILE__))
require 'tmpdir'
require 'fileutils'

describe EnvKonf::Config do
  around(:each) do |sinario|
    Dir.mktmpdir("env-konf-config-test") do |tmpdir|
      FileUtils.cd(tmpdir) do
        sinario.run
      end
    end
  end

  it "should get nil if dir is not exist" do
    [:profile, :target_path, :passwd_md5, :encode_key, :decode_key].each do |method|
      EnvKonf::Config.send(method).should be_nil
    end
  end

  it "should get nil if file is not exist" do
    FileUtils.mkdir_p(File.dirname(EnvKonf::Config.file_path))
    [:profile, :target_path, :passwd_md5, :encode_key, :decode_key].each do |method|
      EnvKonf::Config.send(method).should be_nil
    end
  end

  it "should exist file if added value and not exist file" do
    profile = "hoge"
    EnvKonf::Config.profile = profile
    File.exist?(EnvKonf::Config.file_path).should be_true
  end

  it "should added values" do
    [:profile, :target_path, :encode_key, :decode_key].each do |target|
      EnvKonf::Config.send("#{target}=", target.to_s)
      EnvKonf::Config.send(target).should == target.to_s
    end
  end

  it "should get md5 password" do
    password = "test"
    EnvKonf::Config.passwd_md5 = password
    EnvKonf::Config.passwd_md5.should_not be_nil
    EnvKonf::Config.passwd_md5.should_not == password
    EnvKonf::Config.equal_passwd_md5(password).should be_true
    EnvKonf::Config.equal_passwd_md5("aaa").should be_false
  end
end
