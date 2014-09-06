module Interapp
  module Configuration
    EC_GROUP = ECDSA::Group::Secp256k1
    VALID_CONFIG_KEYS = [:identifier, :private_key, :handler]

    attr_accessor *VALID_CONFIG_KEYS

    def on_receive(&block)
      @handler = block
    end
  end
end
