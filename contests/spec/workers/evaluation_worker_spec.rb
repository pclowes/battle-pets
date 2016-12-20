require "rails_helper"
require "sidekiq/testing"

describe EvaluationWorker do
  let(:pets_service) { instance_double(PetsService, post_result: nil) }

  before do
    Sidekiq::Testing::inline!

    allow(PetsService).to receive(:new).and_return(pets_service)

    @contest = Contest.create!(category: :strength)
    @contestant1 = Contestant.create!(
        pet_id: 1,
        name: "Contestant 1",
        strength: 11,
        agility: 22,
        wit: 33,
        senses: 44,
        experience: 100,
        contest_id: @contest.id,
        winner: nil
    )
    @contestant2 = Contestant.create!(
        pet_id: 2,
        name: "Contestant 2",
        strength: 55,
        agility: 55,
        wit: 55,
        senses: 55,
        experience: 115,
        contest_id: @contest.id,
        winner: nil
    )
  end


  describe "evaluates contest, updates contestants, post results to service" do
    %w(strength agility wit senses).each do |category|
      it "sets the contestant with the higher #{category} level as the winner" do
        @contest.update_attributes!(category: category.to_sym)
        expected_result = {
            losers: [@contestant1.pet_id],
            winners: [@contestant2.pet_id]
        }


        EvaluationWorker.perform_async(@contest.id)


        expect(Contestant.find_by(pet_id: 1).winner).to eq false
        expect(Contestant.find_by(pet_id: 2).winner).to eq true

        expect(pets_service).to have_received(:post_result).with(expected_result)
      end
    end

    it "uses experience as the tiebreaker if there is a tie" do
      @contestant1.update_attributes(strength: @contestant2.strength)
      expected_result = {
          losers: [@contestant1.pet_id],
          winners: [@contestant2.pet_id]
      }


      EvaluationWorker.perform_async(@contest.id)


      expect(@contestant1.reload.winner).to eq false
      expect(@contestant2.reload.winner).to eq true
      expect(pets_service).to have_received(:post_result).with(expected_result)
    end

    it "handles a tie across category and experience" do
      @contestant1.update_attributes(
          strength: @contestant2.strength,
          experience: @contestant2.experience
      )
      expected_result = {
          losers: [@contestant2.pet_id, @contestant1.pet_id],
          winners: []
      }


      EvaluationWorker.perform_async(@contest.id)


      expect(@contestant1.reload.winner).to eq false
      expect(@contestant2.reload.winner).to eq false
      expect(pets_service).to have_received(:post_result).with(expected_result)
    end

    it "handles a contestant with a missing attribute" do
      @contestant2.update_attributes(strength: nil)
      expected_result = {
          losers: [@contestant2.pet_id],
          winners: [@contestant1.pet_id]
      }


      EvaluationWorker.perform_async(@contest.id)


      expect(@contestant1.reload.winner).to eq true
      expect(@contestant2.reload.winner).to eq false
      expect(pets_service).to have_received(:post_result).with(expected_result)
    end
  end
end
