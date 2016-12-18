class CreationService
  def create(contest_params)
    contest = create_contest(contest_params[:category])
    create_contestants(contest.id, contest_params[:contestants])
    EvaluationWorker.perform_async(contest.id)

    contest
  end

  private

  def create_contest(category)
    Contest.create!(category: category)
  end

  def create_contestants(contest_id, contestants)
    contestants.each do |contestant|
      Contestant.create!(contestant.merge!(contest_id: contest_id))
    end
  end
end