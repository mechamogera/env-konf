require "env-konf/version"
require 'yaml'

module EnvKonf
  Directory = File.expand_path(File.join("~", ".env_konf"))
                       
  def self.get(options = {})
    self.load
  end

  def self.switch(name, options)
    @profile = File.join(Directory, "#{name}.yaml")
  end

  private

  def self.load
    FileUtils.mkdir_p(Directory) unless File.exist?(Directory)
    @profile ||= File.join(Directory, "default.yaml")
    File.exist?(@profile) ? YAML.load_file(@profile) : nil
  end
end
