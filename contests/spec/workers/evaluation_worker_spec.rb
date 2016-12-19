require "rails_helper"
require "sidekiq/testing"

describe EvaluationWorker do
  before do
    Sidekiq::Testing::inline!
  end

  describe "evaluates all contest categories and updates the winning contestant" do
    %w(strength agility wit senses).each do |category|
      it "sets the contestant with the higher #{category} level as the winner" do
        contest = Contest.create!(category: category.to_sym)
        Contestant.create!(
            pet_id: 1,
            name: "Contestant 1",
            strength: 11,
            agility: 22,
            wit: 33,
            senses: 44,
            experience: 100,
            contest_id: contest.id,
            winner: nil
        )

        Contestant.create!(
            pet_id: 2,
            name: "Contestant 2",
            strength: 55,
            agility: 55,
            wit: 55,
            senses: 55,
            experience: 115,
            contest_id: contest.id,
            winner: nil
        )

        EvaluationWorker.perform_async(contest.id)

        expect(Contestant.find_by(pet_id: 1).winner).to eq false
        expect(Contestant.find_by(pet_id: 2).winner).to eq true
      end
    end

    it "uses experience as the tiebreaker if there is a tie" do
      contest = Contest.create!(category: :wit)
      Contestant.create!(
          pet_id: 1,
          name: "Contestant 1",
          wit: 33,
          experience: 120,
          contest_id: contest.id,
          winner: nil
      )

      Contestant.create!(
          pet_id: 2,
          name: "Contestant 2",
          wit: 33,
          experience: 130,
          contest_id: contest.id,
          winner: nil
      )

      EvaluationWorker.perform_async(contest.id)

      expect(Contestant.find_by(pet_id: 1).winner).to eq false
      expect(Contestant.find_by(pet_id: 2).winner).to eq true
    end

    it "handles a tie across category and experience" do
      contest = Contest.create!(category: :wit)
      Contestant.create!(
          pet_id: 1,
          name: "Contestant 1",
          wit: 33,
          experience: 120,
          contest_id: contest.id,
          winner: nil
      )

      Contestant.create!(
          pet_id: 2,
          name: "Contestant 2",
          wit: 33,
          experience: 120,
          contest_id: contest.id,
          winner: nil
      )

      EvaluationWorker.perform_async(contest.id)

      expect(Contestant.find_by(pet_id: 1).winner).to eq false
      expect(Contestant.find_by(pet_id: 2).winner).to eq false
    end

    it "handles a contestant with a missing attribute" do
      contest = Contest.create!(category: :wit)
      Contestant.create!(
          pet_id: 1,
          name: "Contestant 1",
          wit: 33,
          experience: 120,
          contest_id: contest.id,
          winner: nil
      )

      Contestant.create!(
          pet_id: 2,
          name: "Contestant 2",
          wit: nil,
          experience: 120,
          contest_id: contest.id,
          winner: nil
      )

      EvaluationWorker.perform_async(contest.id)

      expect(Contestant.find_by(pet_id: 1).winner).to eq true
      expect(Contestant.find_by(pet_id: 2).winner).to eq false
    end
  end
end
