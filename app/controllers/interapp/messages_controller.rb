module Interapp
  class MessagesController < Interapp::ApplicationController
    def create
      service = Interapp::ReceiveMessageService.new(
        payload: request.body.read,
        peer_identifier: request.headers["X-Interapp-Identifier"],
        signature: request.headers["X-Interapp-Signature"]
      )
      service.perform
      output = service.return_value || { received_at: Time.now.to_i }
      render json: output
    end
  end
end
