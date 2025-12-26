# frozen_string_literal: true

class ExperienceAccomplishment < ApplicationRecord
  belongs_to :experience, inverse_of: :accomplishments

  validates :accomplishment, presence: true

  default_scope { order(:sort_order) }

  def display_name
    accomplishment.truncate(50)
  end
end
