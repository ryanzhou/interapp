module Interapp
  class Message
    attr_accessor :payload, :peer, :signature

    def initialize(attributes)
      attributes.each { |name, value| send("#{name}=", value) }
    end

    def valid?
      peer.public_key
    end


    def self.receive_message(payload:, peer_identifier:, signature:)
      message = Message.new(payload: payload, peer_identifier: peer_identifier, signature: signature)
    end

    def self.send_message(payload:, peer_identifier:)
      message = Message.new(payload: payload, peer_identifier: peer_identifier)
    end
  end
end
