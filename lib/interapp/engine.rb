module Interapp
  class Engine < ::Rails::Engine
    isolate_namespace Interapp
    config.after_initialize do
      require 'interapp/application_controller'
    end
  end
end
