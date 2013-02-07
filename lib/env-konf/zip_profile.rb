require 'digest/md5'
require 'yaml'
require 'fileutils'

module EnvKonf
  module ZipProfile
    FILE = File.expand_path(File.join("~", ".env-konf", ".zip_profile"))

    def self.save_encode_md5(profile, source)
      write(profile, {:encode_md5 => Digest::MD5.file(source).hexdigest})
    end

    def self.save_decode_md5(profile, source)
      write(profile, {:decode_md5 => Digest::MD5.file(source).hexdigest})
    end

    def self.match_encoded?(profile, source)
      md5 = read[profile][:encode_md5] rescue nil
      md5 == Digest::MD5.file(source).hexdigest
    end

    def self.match_decoded?(profile, source)
      md5 = read[profile][:decode_md5]
      md5 == Digest::MD5.file(source).hexdigest
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
