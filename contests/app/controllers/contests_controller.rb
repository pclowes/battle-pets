class ContestsController < ApplicationController
  def create
    contest = CreationService.new.create(creation_params)
    render json: contest, status: :created
  end

  private

  def creation_params
    params.permit(
        :category,
        contestants: [
            :pet_id,
            :name,
            :strength,
            :agility,
            :wit,
            :senses,
            :experience,
        ]

    )
  end
end