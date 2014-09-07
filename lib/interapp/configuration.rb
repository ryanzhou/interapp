module Interapp
  class Configuration
    VALID_CONFIG_KEYS = [:identifier, :private_key, :handler, :peers]

    attr_accessor *VALID_CONFIG_KEYS

    def on_receive(&block)
      @handler = block
    end

    def add_peer
      peer = Interapp::Peer.new
      yield(peer)
      @peers ||= []
      @peers << peer
    end
  end
end
