class Contest < ActiveRecord::Base
  enum category: {
      strength: "strength",
      agility: "agility",
      wit: "wit",
      senses: "senses"
  }
end