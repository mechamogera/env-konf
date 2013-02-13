module EnvKonf
  module Config
    def self.directory
      Directory
    end
    
    private

    Directory = File.expand_path(File.join("~", ".env-konf"))
  end
end
