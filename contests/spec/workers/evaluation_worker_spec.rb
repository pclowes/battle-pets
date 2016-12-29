require "rails_helper"
require "sidekiq/testing"

describe EvaluationWorker do
  let(:pets_service) { instance_double(PetsService, post_result: nil, get_pets: nil) }

  before do
    Sidekiq::Testing::inline!
    allow(PetsService).to receive(:new).and_return(pets_service)
  end

  describe "#perform" do
    context "one versus one contest" do
      before do
        @contestant1 = {
            id: 1,
            name: "Contestant 1",
            strength: 11,
            agility: 22,
            wit: 33,
            senses: 44,
            experience: 100,
        }
        @contestant2 = {
            id: 2,
            name: "Contestant 2",
            strength: 44,
            agility: 55,
            wit: 55,
            senses: 55,
            experience: 115,
        }
        @contestants = [@contestant1, @contestant2]
        @contest = Contest.create!(category: :strength, pet_ids: [1, 2])
      end

      %w(strength agility wit senses).each do |category|
        it "sets the contestant with the higher #{category} level as the winner" do
          @contest.update_attributes!(category: category.to_sym)

          allow(pets_service).to receive(:get_pets).and_return(@contestants)

          expected_result = {
              losers: [@contestant1[:id]],
              winners: [@contestant2[:id]]
          }


          EvaluationWorker.perform_async(@contest.id)


          expect(pets_service).to have_received(:get_pets).with({pet_ids: [1, 2]})
          expect(pets_service).to have_received(:post_result).with(expected_result)
        end
      end

      it "uses experience as the tiebreaker if there is a tie" do
        @contestant1[:strength] = @contestant2[:strength]
        expected_result = {
            losers: [@contestant1[:id]],
            winners: [@contestant2[:id]]
        }

        allow(pets_service).to receive(:get_pets).and_return(@contestants)


        EvaluationWorker.perform_async(@contest.id)


        expect(pets_service).to have_received(:post_result).with(expected_result)
      end

      it "handles a tie across category and experience" do
        @contestant1[:strength] = @contestant2[:strength]
        @contestant1[:experience] = @contestant2[:experience]

        expected_result = {
            losers: [@contestant1[:id], @contestant2[:id]],
            winners: []
        }

        allow(pets_service).to receive(:get_pets).and_return(@contestants)


        EvaluationWorker.perform_async(@contest.id)


        expect(pets_service).to have_received(:post_result).with(expected_result)
      end
    end

    context "team versus team" do
      it "evaluates teams by balancing them and treating them as aggregate competitors" do
        contestant1 = {
            id: 1,
            name: "Contestant 1",
            strength: 11,
            agility: 22,
            wit: 33,
            senses: 44,
            experience: 100,
        }
        contestant2 = {
            id: 2,
            name: "Contestant 2",
            strength: 22,
            agility: 55,
            wit: 55,
            senses: 55,
            experience: 115,
        }
        contestant3 = {
            id: 3,
            name: "Contestant 1",
            strength: 33,
            agility: 22,
            wit: 33,
            senses: 44,
            experience: 100,
        }
        contestant4 = {
            id: 4,
            name: "Contestant 2",
            strength: 44,
            agility: 55,
            wit: 55,
            senses: 55,
            experience: 115,
        }

        contestants = [contestant1, contestant2, contestant3, contestant4]
        contest = Contest.create(
            category: :strength,
            pet_ids: contestants.map { |c| c[:pet_id] }
        )

        allow(pets_service).to receive(:get_pets).and_return(contestants)

        expected_result = {
            losers: [contestant1[:id], contestant3[:id]],
            winners: [contestant2[:id], contestant4[:id]]
        }


        EvaluationWorker.perform_async(contest.id)


        expect(pets_service).to have_received(:post_result).with(expected_result)
      end
    end
  end
end
