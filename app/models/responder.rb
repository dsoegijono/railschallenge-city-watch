class Responder < ActiveRecord::Base
  self.inheritance_column = :_type

  belongs_to :emergency

  validates :type, presence: true
  validates :name, presence: true
  validates :capacity, presence: true, numericality: { only_integer: true, greater_than_or_equal_to: 0 }

  def self.types
    %w(Fire Police Medical)
  end
end
