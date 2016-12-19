class Contest < ActiveRecord::Base
  validates :category, presence: true

  enum category: {
      strength: "strength",
      agility: "agility",
      wit: "wit",
      senses: "senses"
  }

end