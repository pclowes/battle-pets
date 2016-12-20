require "rails_helper"

describe ResultService do
  describe "#update" do
    it "adds experience 15xp to winners and 5xp to losers" do
      winning_pet = Pet.create!(
          name: "Winner",
          strength: 99,
          agility: 99,
          wit: 99,
          senses: 99,
          experience: 100
      )
      losing_pet = Pet.create!(
          name: "Loser",
          strength: 1,
          agility: 1,
          wit: 1,
          senses: 1,
          experience: 100
      )
      result = {
          winners: [winning_pet.id],
          losers: [losing_pet.id]
      }


      ResultService.new.update(result)


      expect(winning_pet.reload.experience).to eq 115
      expect(losing_pet.reload.experience).to eq 105
    end
  end
end