class EvaluationWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker


  def perform(contest_id)
    category = Contest.find(contest_id).category.to_sym
    contestants = Contestant.where(contest_id: contest_id)

    result = evaluate(category, contestants)
    update_contestants(result)

    formatted_result = format(result)

    PetsService.new.post_result(formatted_result)
  end

  private

  def evaluate(category, contestants)
    if unequally_matched?(category, contestants)
      result = compare(category, contestants)
    elsif unequally_matched?(:experience, contestants)
      result = compare(:experience, contestants)
    else
      result = tie_game(contestants)
    end

    result
  end

  def compare(attribute, contestants)
    sorted_array = contestants.minmax_by do |c|
      c[attribute] = c[attribute] || 0
    end

    return { losers: [sorted_array.first], winners: [sorted_array.last] }
  end

  def tie_game(contestants)
    return { losers: contestants.to_a, winners: [] }
  end

  def unequally_matched?(attribute, contestants)
    contestant1_score = contestants.first[attribute]
    contestant2_score = contestants.last[attribute]

    contestant1_score != contestant2_score
  end

  def update_contestants(result)
    result[:losers].each do |c|
      c.update_attributes(winner: false)
    end

    result[:winners].each do |c|
      c.update_attributes(winner: true)
    end
  end

  def format(result)
    losing_pet_ids = result[:losers].map(&:pet_id)
    winning_pet_ids = result[:winners].map(&:pet_id)

    {losers: losing_pet_ids, winners: winning_pet_ids}
  end
end
