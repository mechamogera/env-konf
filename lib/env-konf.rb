require "env-konf/version"
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
end
