require "env-konf/version"
require "env-konf/zip_config"
require "env-konf/zip"
require "env-konf/zip_profile"
require "env-konf/input"
require 'yaml'

module EnvKonf
  Directory = File.expand_path(File.join("~", ".env-konf"))
                       
  def self.get(options = {})
    FileUtils.mkdir_p(Directory) unless File.exist?(Directory)
    path = profile_path(options[:profile] || @profile)
    File.exist?(path) ? YAML.load_file(path) : nil
  end

  def self.profile_init(profile, options = {})
    FileUtils.mkdir_p(Directory) unless File.exist?(Directory)
    path = profile_path(profile || @profile)
    raise ArgumentError.new("profile already exist") if File.exist?(path) && !options[:force]
    File.open(path, "w") { |f| }

    path
  end

  def self.profile=(profile)
    @profile = profile
  end

  def self.profile
    @profile || "default"
  end

  def self.profile_path(profile = nil)
    profile = profile || @profile || "default"
    File.join(Directory, "#{profile}.yaml")
  end

  def self.zip(options = {})
    path = options[:path]
    unless path
      path = EnvKonf::ZipConfig.zip_path
      raise  ArgumentError.new("Need encode zip path") unless path
    end

    profile = options[:profile] || EnvKonf::ZipConfig.profile
    return if EnvKonf::ZipProfile.match_encoded?(profile, profile_path(profile)) unless options[:force]

    md5 = EnvKonf::ZipConfig.passwd_md5
    password = EnvKonf::Input.input_password(:default => options[:password], 
                                             :check_md5 => md5)
    EnvKonf::Zip.encode(path, :password => password,
                              :profile => profile)
    EnvKonf::ZipProfile.save_encode_md5(profile, profile_path(profile))
  end

  def self.unzip(options = {})
    path = options[:path]
    unless path
      path = EnvKonf::ZipConfig.zip_path
      raise  ArgumentError.new("Need decode zip path") unless path
    end

    profile = options[:profile] || EnvKonf::ZipConfig.profile
    return if EnvKonf::ZipProfile.match_decoded?(profile, path) unless options[:force]

    password = EnvKonf::Input.input_password(:default => options[:password], 
                                             :check_twice => false)
    EnvKonf::Zip.decode(path, :password => password,
                              :profile => profile)
    EnvKonf::ZipProfile.save_decode_md5(profile, path)
  end
end
