class CreationService
  def create(contest_params)
    contest = create_contest(contest_params[:category])
    create_contestants(contest.id, contest_params[:contestants])
    evaluate_contest(contest)

    contest
  end

  private

  def create_contestants(contest_id, contestants)
    contestants.each do |contestant|
      Contestant.create(contestant.merge!(contest_id: contest_id))
    end
  end

  def create_contest(category)
    Contest.create(category: category)
  end

  def evaluate_contest(contest)
    contestants = Contestant.where(contest_id: contest.id).order("#{contest.category} DESC")

    winner = contestants.first
    winner.update_attributes!(winner: true)

    loser = contestants.last
    loser.update_attributes!(winner: false)
  end
end