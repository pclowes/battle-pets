class ContestsController < ApplicationController
  def create
    contest = Contest.create!(contest_creation_params)
    render json: contest, status: :created
  end

  private

  def contest_creation_params
    params.permit(
        :category
    )
  end
end