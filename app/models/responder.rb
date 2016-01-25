class Responder < ActiveRecord::Base
  self.inheritance_column = :_type
  self.primary_key = 'name'

  belongs_to :emergency

  validates :type, presence: true
  validates :name, presence: true, uniqueness: true
  validates :capacity, presence: true, inclusion: 1..5

  def self.types
    %w(Fire Police Medical)
  end
end
