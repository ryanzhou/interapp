module Interapp
  class ApplicationController < ActionController::Base
    rescue_from Interapp::SignatureInvalidError do
      render json: { error: "SIGNATURE_INVALID" }, status: 403
    end

    rescue_from Interapp::UnknownPeerError do
      render json: { error: "UNKNOWN_PEER" }, status: 403
    end
  end
end
