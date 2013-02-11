require 'spec_helper'
require File.expand_path('../lib/env-konf/input', File.dirname(__FILE__))
require 'tmpdir'
require 'fileutils'

describe EnvKonf::Input do
  it "should get input password" do
    password = "password"
    HighLine.any_instance.stub(:ask).with(any_args).and_return(password)
    
    EnvKonf::Input.input_password.should == password
  end

  it "should get default password" do
    password = "password"
    EnvKonf::Input.input_password(:default => password).should == password
  end

  it "should get input password if default password is empy" do
    password = "password"
    HighLine.any_instance.stub(:ask).with(any_args).and_return(password)
    
    EnvKonf::Input.input_password(:default => "").should == password
  end

  it "should get input password if default password is nil" do
    password = "password"
    HighLine.any_instance.stub(:ask).with(any_args).and_return(password)
    
    EnvKonf::Input.input_password(:default => nil).should == password
  end

  it "should get input password at twice" do
    password = "password"
    count = 0
    HighLine.any_instance.stub(:ask).with(any_args) do
      count += 1
      password
    end

    EnvKonf::Input.input_password.should == password
    count.should == 2
  end

  it "should get input password with miss match" do
    password = "password"
    count = 0
    HighLine.any_instance.stub(:ask).with(any_args) do
      count += 1
      count == 1 ? "aaa" : password
    end
    STDERR.should_receive(:puts).with(any_args)

    EnvKonf::Input.input_password.should == password
    count.should == 4
  end

  it "should get input password at once" do
    password = "password"
    count = 0
    HighLine.any_instance.stub(:ask).with(any_args) do
      count += 1
      password
    end

    EnvKonf::Input.input_password(:check_twice => false).should == password
    count.should == 1
  end

  it "should get input password by md5 checking" do
    password = "password"
    md5 =  Digest::MD5.hexdigest(password)
    count = 0
    HighLine.any_instance.stub(:ask).with(any_args) do
      count += 1
      password
    end

    EnvKonf::Input.input_password(:check_md5 => md5).should == password
    count.should == 1
  end

  it "should get input password with md5 miss match" do
    password = "password"
    md5 =  Digest::MD5.hexdigest(password)
    count = 0
    HighLine.any_instance.stub(:ask).with(any_args) do
      count += 1
      count == 1 ? "aaa" : password
    end
    STDERR.should_receive(:puts).with(any_args)

    EnvKonf::Input.input_password(:check_md5 => md5).should == password
    count.should == 2
  end
end
