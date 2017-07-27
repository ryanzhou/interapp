module Interapp
  class ReceiveMessageService
    attr :message, :peer, :data, :return_value

    def initialize(payload:, peer_identifier:, signature:)
      find_peer(peer_identifier)
      @message = Message.new(payload: payload, peer: @peer, signature: signature)
      @data = JSON.load(@message.payload)
    end

    def perform
      if @message.verify
        @return_value = Interapp.configuration.handler.call(data, message.peer.identifier)
      else
        raise Interapp::SignatureInvalidError
      end
    rescue OpenSSL::ASN1::ASN1Error
      raise Interapp::SignatureInvalidError
    end

    private
    def find_peer(peer_identifier)
      @peer = Interapp::Peer.find(peer_identifier)
      raise Interapp::UnknownPeerError if @peer.nil?
    end
  end
end
