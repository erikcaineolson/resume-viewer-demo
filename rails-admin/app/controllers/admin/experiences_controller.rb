# frozen_string_literal: true

module Admin
  class ExperiencesController < Admin::ApplicationController
    # Administrate handles all CRUD by default

    def scoped_resource
      Experience.includes(:skills, :accomplishments)
    end
  end
end
