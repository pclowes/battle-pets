class Pet < ActiveRecord::Base
  validates :name,
      :strength,
      :agility,
      :wit,
      :senses,
      :experience,
      presence: true
end