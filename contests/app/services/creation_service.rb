class CreationService
  def create(params)
    @errors = []
    contest = Contest.new(category: params[:category])

    ActiveRecord::Base.transaction do
      validate_save(contest)
      if valid_contestant_number?(params[:contestants])
        create_contestants(contest.id, params[:contestants])
      end
    end

    if @errors.empty?
      job_id = EvaluationWorker.perform_async(contest.id)
    end

    {
        success: @errors.empty?,
        entity: {contest: contest, job_id: job_id},
        errors: @errors.uniq
    }
  end

  private

  def valid_contestant_number?(contestants)
    if contestants.try(:length) != 2
      @errors << "Must have exactly two contestants"
      return false
    else
      true
    end
  end

  def create_contestants(contest_id, contestants)
    contestants.each do |contestant|
      new_contestant = Contestant.new(contestant.merge!(contest_id: contest_id))
      validate_save(new_contestant)
    end
  end

  def validate_save(object)
    if object.valid?
      object.save!
    else
      @errors += object.errors.full_messages
    end
  end
end