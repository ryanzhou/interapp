module Interapp
  class Configuration
    VALID_CONFIG_KEYS = [:identifier, :private_key, :handler, :peers]

    attr_accessor *VALID_CONFIG_KEYS

    def on_receive(&block)
      @handler = block
    end

    def add_peer(identifier:, public_key:, endpoint:)
      @peers ||= []
      @peers < Interapp::Peer.new(identifier: identifier, public_key: public_key, endpoint: endpoint)
    end
  end
end
