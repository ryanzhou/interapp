require 'net/http'
require 'uri'

module Interapp
  class SendMessageService
    attr :message, :peer, :payload

    def initialize(data:, peer_identifier:)
      find_peer(peer_identifier)
      @payload = JSON.dump(data)
      @message = Message.new(payload: @payload, peer: peer)
      @message.sign
    end

    def perform
      response = Net::HTTP.post(
        URI(peer.endpoint),
        message.payload,
        {
          "X-Interapp-Identifier" => Interapp.configuration.identifier,
          "X-Interapp-Signature" => message.signature,
          "Content-Type" => "application/json"
        }
      )
      JSON.parse(response.body) if response
    end

    private
    def find_peer(peer_identifier)
      @peer = Interapp::Peer.find(peer_identifier)
      raise Interapp::UnknownPeerError if @peer.nil?
    end
  end
end
