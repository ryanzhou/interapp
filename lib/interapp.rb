require "ecdsa"
require "interapp/engine"
require "interapp/configuration"
require "interapp/cryptography"
require "interapp/errors"

module Interapp
  EC_GROUP = ECDSA::Group::Secp256k1

  class << self
    attr_accessor :configuration
  end

  def self.configure
    self.configuration ||= Interapp::Configuration.new
    yield(configuration)
  end

  def self.send_message(data:, peer_identifier:)
    Interapp::SendMessageService.new(data: data, peer_identifier: peer_identifier)
  end
end
