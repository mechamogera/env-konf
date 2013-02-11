require 'digest/md5'
require 'highline'

module EnvKonf
  module Input
    def self.input_password(options = {})
      options = {:default => "", :check_twice => true}.merge(options)
      password = options[:default]

      while password.nil? || password.empty?
        password = HighLine.new.ask('Password: ') { |q| q.echo = '*' }
        if password.empty?
          $stderr.puts "Password should be not empty"
          next
        end
                            
        if options[:check_md5]
          if options[:check_md5] != Digest::MD5.hexdigest(password)
            $stderr.puts "Password md5 miss match"
            password = nil
          end
          next
        end
        next unless options[:check_twice]

        password2 = HighLine.new.ask('Retype password: ') { |q| q.echo = '*' }
        if password != password2
          $stderr.puts "Password miss match"
           password = nil
        end
      end
      return password
    end
  end
end
