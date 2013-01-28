require "env-konf/version"
require "env-konf/config"
require "env-konf/zip"
require "env-konf/input"
require 'yaml'

module EnvKonf
  Directory = File.expand_path(File.join("~", ".env_konf"))
                       
  def self.get(options = {})
    FileUtils.mkdir_p(Directory) unless File.exist?(Directory)
    path = profile_path(options[:profile] || @profile)
    File.exist?(path) ? YAML.load_file(path) : nil
  end

  def self.switch(name = nil, options = {})
    @profile = name
  end

  def self.profile
    @profile || "default"
  end

  def self.profile_path(profile = nil)
    profile = profile || @profile || "default"
    File.join(Directory, "#{profile}.yaml")
  end

  def self.encode(options = {})
    path = options[:path]
    unless path
      path = EnvKonf::Config.zip_path
      raise  ArgumentError.new("Need encode zip path") unless path
    end

    md5 = EnvKonf::Config.passwd_md5
    password = EnvKonf::Input.input_password(:default => options[:password], 
                                             :check_md5 => md5)
    profile = options[:profile] || EnvKonf::Config.profile
    EnvKonf::Zip.encode(path, :password => password,
                              :profile => profile)
  end

  def self.decode(options = {})
    path = options[:path]
    unless path
      path = EnvKonf::Config.zip_path
      raise  ArgumentError.new("Need decode zip path") unless path
    end

    password = CipherConf.input_password(:default => options[:password], 
                                         :check_twice => false)
    profile = options[:profile] || EnvKonf::Config.profile
    EnvKonf::Zip.decode(path, :password => password,
                              :profile => profile)
  end
end
