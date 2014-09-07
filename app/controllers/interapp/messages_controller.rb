module Interapp
  class MessagesController < ApplicationController
    def create
      Interapp::ReceiveMessageService.new(
        payload: request.body.read,
        peer_identifier: request.headers["X-Interapp-Identifier"],
        signature: request.headers["X-Interapp-Signature"]
      ).perform
      render json: { received_at: Time.now.to_i }
    end
  end
end
