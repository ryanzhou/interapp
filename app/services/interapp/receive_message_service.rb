module Interapp
  attr :message

  class ReceiveMessageService
    def initialize(payload:, peer_identifier:, signature:)
      @message = Message.new(payload: payload, peer_identifier: peer_identifier, signature: signature)
    end

    def perform
      # TODO
    end
  end
end
