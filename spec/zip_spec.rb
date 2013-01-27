require 'spec_helper'
require File.expand_path('../lib/env-konf/zip', File.dirname(__FILE__))
require 'tmpdir'
require 'digest/md5'

describe EnvKonf::Zip do
  it "should encode and decode" do
    Dir.mktmpdir("env-konf-spec-zip") do |tmpdir|
      decoded_path = File.join(tmpdir, "hoge")
      target_path = File.expand_path(__FILE__)
      zip_path = File.join(tmpdir, "no-password.zip")
      EnvKonf.should_receive(:profile_path).with(nil).and_return(target_path)
      EnvKonf.should_receive(:profile_path).with(nil).and_return(decoded_path)

      EnvKonf::Zip.encode(zip_path)
      File.exist?(zip_path).should be_true

      EnvKonf::Zip.decode(zip_path)
      File.exist?(decoded_path).should be_true
      Digest::MD5.file(decoded_path).hexdigest.should == 
        Digest::MD5.file(target_path).hexdigest
    end
  end

  it "should encode and decode with password" do
    Dir.mktmpdir("env-konf-spec-zip-password") do |tmpdir|
      password = "hige"
      decoded_path = File.join(tmpdir, "hoge")
      target_path = File.expand_path(__FILE__)
      zip_path = File.join(tmpdir, "password.zip")
      EnvKonf.should_receive(:profile_path).with(nil).and_return(target_path)
      EnvKonf.should_receive(:profile_path).twice.with(nil).and_return(decoded_path)

      EnvKonf::Zip.encode(zip_path, :password => password)
      File.exist?(zip_path).should be_true

      proc { EnvKonf::Zip.decode(zip_path) }.should raise_error(Zip::Error)
      proc { EnvKonf::Zip.decode(zip_path, :password => "aaa") }.should raise_error(Zip::Error)

      EnvKonf::Zip.decode(zip_path, :password => password)
      File.exist?(decoded_path).should be_true
      Digest::MD5.file(decoded_path).hexdigest.should == 
        Digest::MD5.file(target_path).hexdigest
    end
  end

  it "should encode and decode with profile" do
    Dir.mktmpdir("env-konf-spec-zip-profile") do |tmpdir|
      profile = "pf"
      decoded_path = File.join(tmpdir, "hoge")
      target_path = File.expand_path(__FILE__)
      zip_path = File.join(tmpdir, "no-password.zip")
      EnvKonf.should_receive(:profile_path).with(profile).and_return(target_path)
      EnvKonf.should_receive(:profile_path).with(profile).and_return(decoded_path)

      EnvKonf::Zip.encode(zip_path, :profile => profile)
      File.exist?(zip_path).should be_true

      EnvKonf::Zip.decode(zip_path, :profile => profile)
      File.exist?(decoded_path).should be_true
      Digest::MD5.file(decoded_path).hexdigest.should == 
        Digest::MD5.file(target_path).hexdigest
    end
  end
end
