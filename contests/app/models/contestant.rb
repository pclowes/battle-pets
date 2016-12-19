class Contestant < ActiveRecord::Base
 belongs_to :contest
  validates :pet_id,
            :name,
            :contest_id,
            presence: true
end