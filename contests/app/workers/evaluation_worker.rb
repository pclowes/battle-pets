class EvaluationWorker
  include Sidekiq::Worker
  include Sidekiq::Status::Worker

  def perform(contest_id)
    category = Contest.find(contest_id).category.to_sym
    contestants = Contestant.where(contest_id: contest_id)

    evaluate(category, contestants)
  end

  private

  def evaluate(category, contestants)
    if unequally_matched?(category, contestants)
      result = compare(category, contestants)
    elsif unequally_matched?(:experience, contestants)
      result = compare(:experience, contestants)
    else
      return tie_game(contestants)
    end

    update(result)
  end

  def compare(attribute, contestants)
    contestants.minmax_by do |c|
      c[attribute] = c[attribute] || 0
    end
  end

  def unequally_matched?(attribute, contestants)
    contestant1_score = contestants.first[attribute]
    contestant2_score = contestants.last[attribute]

    contestant1_score != contestant2_score
  end

  def update(result)
    result.first.update_attributes!(winner: false)
    result.last.update_attributes!(winner: true)
  end

  def tie_game(contestants)
    contestants.update_all(winner: false)
  end
end
