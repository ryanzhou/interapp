module Interapp
  attr :message

  class SendMessageService
    def initialize(payload:, peer_identifier:)
      @message = Message.new(payload: payload, peer_identifier: peer_identifier)
    end

    def perform
      # TODO
    end
  end
end
