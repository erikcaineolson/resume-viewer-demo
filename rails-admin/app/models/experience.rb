# frozen_string_literal: true

class Experience < ApplicationRecord
  has_many :accomplishments,
           class_name: 'ExperienceAccomplishment',
           dependent: :destroy,
           inverse_of: :experience

  has_and_belongs_to_many :skills, join_table: 'experience_skills'

  validates :company, :title, :start_date, presence: true
  validate :end_date_after_start_date

  scope :current, -> { where(end_date: nil) }
  scope :past, -> { where.not(end_date: nil) }
  scope :chronological, -> { order(start_date: :desc) }

  # is_current is a generated column in PostgreSQL
  def current?
    end_date.nil?
  end

  def duration_months
    end_date_or_now = end_date || Date.current
    ((end_date_or_now.year - start_date.year) * 12) +
      (end_date_or_now.month - start_date.month)
  end

  def duration_display
    months = duration_months
    years = months / 12
    remaining = months % 12

    parts = []
    parts << "#{years}y" if years.positive?
    parts << "#{remaining}m" if remaining.positive?
    parts.join(' ') || '< 1m'
  end

  def display_name
    "#{title} at #{company}"
  end

  private

  def end_date_after_start_date
    return unless end_date && start_date
    return unless end_date < start_date

    errors.add(:end_date, 'must be after start date')
  end
end
