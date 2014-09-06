module Interapp
  class Message
    attr_accessor :payload, :peer, :signature

    def initialize(attributes)
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def verify
      Interapp::Cryptography.verify(payload, signature_decoded, peer.public_key_decoded)
    end

    def sign
      encoded_signature = Interapp::Cryptography.sign(payload, Interapp.private_key.to_i(16))
      self.signature = encoded_signature.unpack("H*").first
    end

    def signature_decoded
      ECDSA::Format::SignatureDerString.decode([signature].pack("H*"))
    end
  end
end
