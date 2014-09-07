module Interapp
  attr :message, :peer

  class SendMessageService
    def initialize(data:, peer_identifier:)
      @peer = Interapp::Peer.find(peer_identifier)
      raise Interapp::UnknownPeerError if @peer.nil?
      payload = JSON.dump(data)
      @message = Message.new(payload: payload, peer: peer)
    end

    def perform
      message.sign
      RestClient.post(peer.endpoint, message.payload, content_type: 'application/json')
    end
  end
end
