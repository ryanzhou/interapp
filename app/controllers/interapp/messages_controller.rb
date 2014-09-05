module Interapp
  class MessagesController < ApplicationController
    def create
      Interapp::ReceiveMessageService.new(
        payload: request.body.read,
        peer_identifier: request.headers["X-Interapp-Identifier"],
        signature: request.headers["X-Interapp-Signature"]
      )
    end
  end
end
