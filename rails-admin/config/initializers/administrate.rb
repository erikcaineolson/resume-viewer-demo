# Administrate configuration
Rails.application.config.to_prepare do
  Administrate::ApplicationController.class_eval do
    # Customize Administrate behavior here if needed
  end
end
