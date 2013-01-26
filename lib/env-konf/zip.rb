require 'zipruby'

module EnvKonf
  module Zip
    def self.encode(path, options = {})
      ::Zip::Archive.open(path, ::Zip::CREATE | ::Zip::TRUNC) do |arc|
        filepath = EnvKonf.profile_path(options[:profile])
        arc.add_file(filepath)
        arc.encrypt(options[:password]) if options[:password]
      end
    end

    def self.decode(path, options = {})
      ::Zip::Archive.open(path) do |arc|
        arc.decrypt(options[:password]) if options[:password]
        arc.num_files.times do |i|
          arc.fopen(arc.get_name(i)) do |file|
            filepath = EnvKonf.profile_path(options[:profile])
            File.open(filepath, "w") do |f|
              f.write file.read
            end
          end
        end
      end
    end
  end
end
