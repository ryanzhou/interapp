module Interapp
  class ApplicationController < ActionController::Base
    protect_from_forgery with: :null_session
    
    rescue_from Interapp::SignatureInvalidError do
      render json: { error: "SIGNATURE_INVALID" }, status: 403
    end

    rescue_from Interapp::UnknownPeerError do
      render json: { error: "UNKNOWN_PEER" }, status: 403
    end
  end
end
