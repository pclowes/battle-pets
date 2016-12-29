class ContestsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def create
    contest = Contest.new(creation_params)
    if contest.save
      job_id = EvaluationWorker.perform_async(contest.id)
      render json: {contest: contest, job_id: job_id}, status: :accepted
    else
      render json: contest.errors.full_messages, status: :unprocessable_entity
    end
  end

  private

  def creation_params
    params.permit(
        :category,
        pet_ids: []

    )
  end
end