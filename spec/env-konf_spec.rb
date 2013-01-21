require 'spec_helper'
require File.expand_path('../lib/env-konf', File.dirname(__FILE__))

describe EnvKonf do
  it "could get default profile" do
    File.should_receive(:exist?).with(EnvKonf::Directory).and_return(true)
    File.should_receive(:exist?).with(File.join(EnvKonf::Directory, "default.yaml")).and_return(false)
    EnvKonf.get.should == nil
  end
end
