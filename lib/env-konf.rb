require "env-konf/version"
require "env-konf/config"
require "env-konf/zip"
require "env-konf/profile_hist"
require "env-konf/input"
require "env-konf/config"

require 'yaml'
require 'openssl'

module EnvKonf
  def self.get(options = {})
    FileUtils.mkdir_p(ProfileHist.directory) unless File.exist?(ProfileHist.directory)
    path = profile_path(options[:profile] || @profile)
    File.exist?(path) ? YAML.load_file(path) : nil
  end

  def self.profile_init(profile, options = {})
    FileUtils.mkdir_p(ProfileHist.directory) unless File.exist?(ProfileHist.directory)
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
    File.join(ProfileHist.directory, "#{profile}.yaml")
  end

  def self.zip(options = {})
    path = options[:path]
    unless path
      path = EnvKonf::Config.target_path
      raise  ArgumentError.new("Need encode zip path") unless path
    end

    profile = options[:profile] || EnvKonf::Config.profile
    return if EnvKonf::ProfileHist.match_encoded?(profile, profile_path(profile)) unless options[:force]

    md5 = EnvKonf::Config.passwd_md5
    password = EnvKonf::Input.input_password(:default => options[:password], 
                                             :check_md5 => md5)
    EnvKonf::Zip.encode(path, :password => password,
                              :profile => profile)
    EnvKonf::ProfileHist.save_encode_md5(profile, profile_path(profile))
  end

  def self.unzip(options = {})
    path = options[:path]
    unless path
      path = EnvKonf::Config.target_path
      raise  ArgumentError.new("Need decode zip path") unless path
    end

    profile = options[:profile] || EnvKonf::Config.profile
    return if EnvKonf::ProfileHist.match_decoded?(profile, path) unless options[:force]

    password = EnvKonf::Input.input_password(:default => options[:password], 
                                             :check_twice => false)
    EnvKonf::Zip.decode(path, :password => password,
                              :profile => profile)
    EnvKonf::ProfileHist.save_decode_md5(profile, path)
  end

  def self.encode(options = {})
    cipher = Cipher.new

    path = options[:path] || EnvKonf::Config.target_path
    raise  ArgumentError.new("Need encode path") unless path
    profile = options[:profile] || EnvKonf::Config.profile

    profile_hist_save(:encode, profile, profile_path(profile), options[:force]) do
      File.open(path, "wb") do |wf|
        File.open(profile_path(profile), "r") do |rf|
          wf.write cipher.encode(rf.read, options[:key] || EnvKonf::Config.encode_key)
        end
      end
    end
  end

  def self.decode(options = {})
    cipher = Cipher.new

    path = options[:path] || EnvKonf::Config.target_path
    raise  ArgumentError.new("Need decode path") unless path unless path
    profile = options[:profile] || EnvKonf::Config.profile

    profile_hist_save(:decode, profile, path, options[:force]) do
      File.open(profile_path(profile), "w") do |wf|
        File.open(path, "rb") do |rf|
          wf.write cipher.decode(rf, options[:key] || EnvKonf::Config.decode_key)
        end
      end
    end
  end
  
  private

  def self.profile_hist_save(type, profile, path, is_force, &block)
    return if !is_force && EnvKonf::ProfileHist.send("match_#{type}d?", profile, path)
    block.call
    EnvKonf::ProfileHist.send("save_#{type}_md5", profile, path)
  end
end
