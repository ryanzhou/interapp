module Interapp
  class Peer
    attr_accessor :identifier, :public_key, :endpoint

    def initialize(attributes)
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def public_key_decoded
      @public_key_decoded ||= ECDSA::Format::PointOctetString.decode(
        [public_key].pack("H*"), Interapp::Configuration::EC_GROUP
      )
    end

    def self.add(identifier:, public_key:, endpoint:)
      @peers ||= []
      @peers < self.new(identifier: identifier, public_key: public_key, endpoint: endpoint)
    end

    def self.all
      @peers
    end

    def self.find(identifier)
      @peers.find{ |peer| peer.identifier = identifier }.first
    end
  end
end
