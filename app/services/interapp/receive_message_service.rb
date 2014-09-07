module Interapp
  attr :message, :data

  class ReceiveMessageService
    def initialize(payload:, peer_identifier:, signature:)
      peer = Interapp::Peer.find(peer_identifier)
      raise Interapp::UnknownPeerError if peer.nil?
      @message = Message.new(payload: payload, peer: peer, signature: signature)
      @data = JSON.load(@message.payload)
    end

    def perform
      if @message.verify
        Interapp.configuration.handler.call(data, message.peer_identifier)
      else
        raise Interapp::SignatureInvalidError
      end
    end
  end
end
