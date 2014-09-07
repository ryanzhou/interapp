module Interapp
  class Peer
    attr_accessor :identifier, :public_key, :endpoint

    def initialize(attributes)
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def public_key_decoded
      @public_key_decoded ||= ECDSA::Format::PointOctetString.decode(
        [public_key].pack("H*"), Interapp::EC_GROUP
      )
    end

    def self.all
      Interapp.configuration.peers
    end

    def self.find(identifier)
      self.all.find{ |peer| peer.identifier == identifier }
    end
  end
end
