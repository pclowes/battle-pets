require "rails_helper"
describe CreationService do
  let!(:worker) { class_double(EvaluationWorker, perform_async: "some job id").as_stubbed_const }

  describe "#create" do
    it "persists contests and contestants, calls the evaluation worker, returns service response" do
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

      allow(worker).to receive(:perform_async).and_return("some_job_id")


      service_response = CreationService.new.create(params)


      expect(Contest.count).to eq 1
      contest = Contest.first
      expect(contest.category).to eq "strength"

      expect(service_response[:success]).to eq true
      expect(service_response[:entity]).to eq({contest: contest, job_id: "some_job_id"})
      expect(service_response[:errors]).to be_empty

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

      contestant_2 = Contestant.find_by(name: "Contestant 2")
      expect(contestant_2.pet_id).to eq 2
      expect(contestant_2.name).to eq "Contestant 2"
      expect(contestant_2.strength).to eq 44
      expect(contestant_2.agility).to eq 33
      expect(contestant_2.wit).to eq 22
      expect(contestant_2.senses).to eq 11
      expect(contestant_2.experience).to eq 120
      expect(contestant_2.contest).to eq contest
    end
  end

  it "contests must have a category" do
    params = {
        category: nil,
    }

    allow(worker).to receive(:perform_async).and_return("some_job_id")


    service_response = CreationService.new.create(params)


    expect(worker).to_not have_received(:perform_async)

    expect(service_response[:success]).to eq false
    expect(service_response[:errors]).to match_array(["Category can't be blank"])

    expect(Contest.count).to eq 0
    expect(Contestant.count).to eq 0
  end

  it "contests must have exactly 2 contestants" do
    params = {
        category: :strength,
        contestants: [{}]
    }

    allow(worker).to receive(:perform_async).and_return("some_job_id")


    service_response = CreationService.new.create(params)


    expect(worker).to_not have_received(:perform_async)

    expect(service_response[:success]).to eq false
    expect(service_response[:errors]).to match_array(["Must have exactly two contestants"])

    expect(Contest.count).to eq 0
    expect(Contestant.count).to eq 0
  end

  it "contestants must have a pet_id, name, and contest_id" do
    params = {
        category: :strength,
        contestants: [{},{}]
    }

    allow(worker).to receive(:perform_async).and_return("some_job_id")


    service_response = CreationService.new.create(params)


    expect(worker).to_not have_received(:perform_async)

    expect(service_response[:success]).to eq false
    expect(service_response[:errors]).to match_array([
                                                         "Name can't be blank",
                                                         "Pet can't be blank"
                                                     ])

    expect(Contestant.count).to eq 0
    expect(Contest.count).to eq 0
  end
end
