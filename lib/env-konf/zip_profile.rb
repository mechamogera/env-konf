require 'digest/md5'
require 'yaml'
require 'fileutils'

module EnvKonf
  module ZipProfile
    FILE = File.join(Directory, ".zip_profile")

    def self.save_encode_md5(source)
      write(:encode_md5, Digest::MD5.file(source))
    end

    def self.save_decode_md5(source)
      write(:decode_md5, Digest::MD5.file(source))
    end

    def self.match_encoded?(source)
      read[:encode_md5] == Digest::MD5.file(source)
    end

    def self.match_decoded?(source)
      read[:decode_md5] == Digest::MD5.file(source)
    end

    private

    def self.read
      begin
        YAML.load_file(FILE)
      rescue Errno::ENOENT, Errno::ENOTDIR
        {}
      end
    end

    def self.write(key, value)
      FileUtils.mkdir_p(File.dirname(FILE))

      store = YAML::Store.new(FILE)
      store.transaction do
        store[key] = value
      end
    end
  end
end
