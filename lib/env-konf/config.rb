require 'fileutils'

module EnvKonf
  module Config
    FILE = ".#{File.basename($0)}/config.yml"

    class << self
      [:profile, :zip_path].each do |method|
        define_method(method) { read[method] }
        define_method("add_#{method}") { |value| add(method, value) }
      end
    end

    private

    def self.read
      YAML.load_file(FILE)
    end

    def self.add(key, value)
      FileUtils.mkdir_p(File.dirname(FILE))

      store = YAML::Store.new(FILE)
      store.transaction do
        store[key] = val
      end
    end
  end
end
