require 'fileutils'
require 'yaml/store'
require 'digest/md5'

module EnvKonf
  module Config
    def self.file_path
      ".env-konf/config.yml"
    end

    class << self
      [:decode_key, :encode_key, :profile, :target_path].each do |method|
        define_method(method) { read[method] }
        define_method("#{method}=") { |value| add(method, value) }
      end
    end

    def self.passwd_md5=(password)
      add(:passwd_md5, Digest::MD5.hexdigest(password))
    end

    def self.passwd_md5
      read[:passwd_md5]
    end

    def self.equal_passwd_md5(password)
      md5 = read[:passwd_md5]
      md5 == Digest::MD5.hexdigest(password)
    end

    private

    def self.read
      begin
        YAML.load_file(file_path)
      rescue Errno::ENOENT, Errno::ENOTDIR
        {}
      end
    end

    def self.add(key, value)
      FileUtils.mkdir_p(File.dirname(file_path))

      store = YAML::Store.new(file_path)
      store.transaction do
        store[key] = value
      end
    end
  end
end
