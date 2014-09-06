require "ecdsa"
require "interapp/engine"
require "interapp/configuration"

module Interapp
  extend Configuration

  def self.add_peer(*args)
    Interapp::Peer.add(*args)
  end

  def self.send_message(body:, peer_identifier:)
    payload = JSON.dump(body)
    Interapp::SendMessageService.new(payload: payload, peer_identifier: peer_identifier)
  end
end
