# frozen_string_literal: true

module Admin
  class ApplicationController < Administrate::ApplicationController
    # Override to customize authorization
    # def authorize_resource(resource)
    #   # Add authentication logic here
    # end

    # Override for custom ordering
    def order
      @order ||= Administrate::Order.new(
        params.fetch(:order, 'created_at'),
        params.fetch(:direction, 'desc')
      )
    end
  end
end
