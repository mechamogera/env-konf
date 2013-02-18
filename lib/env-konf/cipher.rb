require 'openssl'
require 'stringio'

module EnvKonf
  class Cipher
    def initialize

    end

    def encode(data, key_path)
      key = create_key(key_path)
      salt = OpenSSL::Random.random_bytes(8)
      password = OpenSSL::Random.random_bytes(16)
      enc_password = key.public_encrypt(password)

      salt + [enc_password.size].pack("N") + enc_password + encrypt(data, salt, password)
    end

    def decode(encoded_data, key_path)
      data = (encoded_data.class == String) ? StringIO.new(encoded_data) : encoded_data
      key = create_key(key_path)
      salt = data.read(8)
      password_size = data.read(4).unpack("N")[0]
      password = key.private_decrypt(data.read(password_size))

      decrypt(data.read, salt, password)
    ensure
      data.close if encoded_data.class == String
    end

    private

    def create_key(key_path)
      key = nil
      File.open(key_path) do |f|
        key = OpenSSL::PKey::RSA.new(f)
      end
      key
    end

    def encrypt(data, salt, password)
      cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
      cipher.encrypt
      cipher.pkcs5_keyivgen(password, salt)
      cipher.update(data) + cipher.final
    end

    def decrypt(data, salt, password)
      cipher = OpenSSL::Cipher::Cipher.new("AES-256-CBC")
      cipher.decrypt
      cipher.pkcs5_keyivgen(password, salt)
      cipher.update(data) + cipher.final
    end
  end
end
