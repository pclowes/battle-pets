class EvaluationWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(contest_id)
    contest = Contest.find(contest_id)
    category = contest.category.to_sym
    pet_ids = contest.pet_ids

    contestants = PetsService.new.get_pets({pet_ids: pet_ids})
    teams = balance_teams(category, contestants)
    result = evaluate(category, teams)

    PetsService.new.post_result(result)
  end

  private

  def evaluate(category, teams)
    if unequally_matched?(category, teams)
      result = compare(category, teams)
    elsif unequally_matched?(:experience, teams)
      result = compare(:experience, teams)
    else
      result = tie_game(teams)
    end

    result
  end

  def balance_teams(category, contestants)
    sorted_contestants = contestants.sort_by { |x| x[category] }
    team1_contestants = sorted_contestants.select { |x| sorted_contestants.index(x).even? }
    team2_contestants = sorted_contestants - team1_contestants

    team1 = teamwide_stats(category, team1_contestants)
    team2 = teamwide_stats(category, team2_contestants)
    [team1, team2]
  end

  def teamwide_stats(category, team)
    stats = {
        category.to_s => team.inject(0) { |sum, hash| sum + hash[category] },
        experience: team.inject(0) { |sum, hash| sum + hash[:experience] },
        pet_ids: team.map { |c| c[:id] }
    }
    stats.symbolize_keys!
  end

  def compare(attribute, teams)
    sorted_array = teams.minmax_by do |c|
      c[attribute] = c[attribute] || 0
    end

    return {losers: sorted_array.first[:pet_ids], winners: sorted_array.last[:pet_ids]}
  end

  def tie_game(teams)
    pet_ids = []
    teams.each do |t|
      pet_ids += t[:pet_ids]
    end
    return {losers: pet_ids, winners: []}
  end

  def unequally_matched?(attribute, teams)
    contestant1_score = teams.first[attribute]
    contestant2_score = teams.last[attribute]

    contestant1_score != contestant2_score
  end
end
