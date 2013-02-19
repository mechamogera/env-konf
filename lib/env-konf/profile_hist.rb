require 'digest/md5'
require 'yaml'
require 'fileutils'
require File.expand_path('config', File.dirname(__FILE__))

module EnvKonf
  module ProfileHist
    def self.directory
      File.expand_path(File.join("~", ".env-konf"))
    end

    def self.file_path
      File.join(directory, ".profile_hist")
    end

    def self.save_encode_md5(profile, source)
      write(profile, {:encode_md5 => Digest::MD5.file(source).hexdigest})
    end

    def self.save_decode_md5(profile, source)
      write(profile, {:decode_md5 => Digest::MD5.file(source).hexdigest})
    end

    def self.match_encoded?(profile, source)
      data = read[profile]
      md5 = data ? data[:encode_md5] : nil
      md5 == Digest::MD5.file(source).hexdigest
    end

    def self.match_decoded?(profile, source)
      data = read[profile]
      md5 = data ? data[:decode_md5] : nil
      md5 == Digest::MD5.file(source).hexdigest
    end

    private

    def self.read
      begin
        YAML.load_file(file_path) || {}
      rescue Errno::ENOENT, Errno::ENOTDIR
        {}
      end
    end

    def self.write(key, value)
      FileUtils.mkdir_p(File.dirname(file_path))

      store = YAML::Store.new(file_path)
      store.transaction do
        bef_val = read[key]
        store[key] = bef_val ? bef_val.merge(value) : value
      end
    end
  end
end
