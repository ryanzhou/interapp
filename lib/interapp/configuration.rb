module Interapp
  module Configuration
    EC_GROUP = ECDSA::Group::Secp256k1
    VALID_CONFIG_KEYS = [:identifier, :private_key]

    attr *VALID_CONFIG_KEYS
  end
end
