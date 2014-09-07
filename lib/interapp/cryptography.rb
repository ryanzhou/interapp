module Interapp
  module Cryptography
    def self.generate_keypair
      private_key = 1 + SecureRandom.random_number(group.order - 1)
      public_key = group.generator.multiply_by_scalar(private_key)
      public_key_binary = ECDSA::Format::PointOctetString.encode(public_key, compression: true)
      return private_key.to_s(16), public_key_binary.unpack('H*').first
    end

    def self.sign(payload, private_key_binary)
      digest = Digest::SHA2.digest(payload)
      signature = nil
      while signature.nil?
        temp_key = 1 + SecureRandom.random_number(group.order - 1)
        signature = ECDSA.sign(group, private_key_binary, digest, temp_key)
      end
      ECDSA::Format::SignatureDerString.encode(signature)
    end

    def self.verify(payload, signature_decoded, public_key_decoded)
      digest = Digest::SHA2.digest(payload)
      ECDSA.valid_signature?(public_key_decoded, digest, signature_decoded)
    end

    private
    def self.group
      Interapp::EC_GROUP
    end
  end
end
