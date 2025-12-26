# frozen_string_literal: true

class Profile < ApplicationRecord
  validates :name, :title, :email, presence: true
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP }

  # JSONB links column stores LinkedIn, GitHub, etc.
  def linkedin_url
    links&.dig('linkedin')
  end

  def github_url
    links&.dig('github')
  end

  def website_url
    links&.dig('website')
  end

  def display_name
    "#{name} - #{title}"
  end
end
