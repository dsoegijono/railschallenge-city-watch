class Emergency < ActiveRecord::Base
  has_many :responders

  self.primary_key = 'code'
end
