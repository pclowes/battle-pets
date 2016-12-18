require "rails_helper"

describe CreationService do
  describe "#create" do
    it "persists contests and contestants from hash of attributes" do
      params = {
          category: "strength",
          contestants: [
              {
                  pet_id: 1,
                  name: "Contestant 1",
                  strength: 11,
                  agility: 22,
                  wit: 33,
                  senses: 44,
                  experience: 100

              },
              {
                  pet_id: 2,
                  name: "Contestant 2",
                  strength: 44,
                  agility: 33,
                  wit: 22,
                  senses: 11,
                  experience: 120
              }
          ]

      }


      CreationService.new.create(params)


      expect(Contest.count).to eq 1
      contest = Contest.first
      expect(contest.category).to eq "strength"

      # expect(EvaluationService).to have_receieved(:perform).with(contest)

      expect(Contestant.count).to eq 2
      contestant_1 = Contestant.find_by(name: "Contestant 1")
      expect(contestant_1.pet_id).to eq 1
      expect(contestant_1.name).to eq "Contestant 1"
      expect(contestant_1.strength).to eq 11
      expect(contestant_1.agility).to eq 22
      expect(contestant_1.wit).to eq 33
      expect(contestant_1.senses).to eq 44
      expect(contestant_1.experience).to eq 100
      expect(contestant_1.contest).to eq contest
      expect(contestant_1.winner).to eq false

      contestant_2 = Contestant.find_by(name: "Contestant 2")
      expect(contestant_2.pet_id).to eq 2
      expect(contestant_2.name).to eq "Contestant 2"
      expect(contestant_2.strength).to eq 44
      expect(contestant_2.agility).to eq 33
      expect(contestant_2.wit).to eq 22
      expect(contestant_2.senses).to eq 11
      expect(contestant_2.experience).to eq 120
      expect(contestant_2.contest).to eq contest
      expect(contestant_2.winner).to eq true

    end
  end
end
