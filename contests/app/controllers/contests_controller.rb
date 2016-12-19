class ContestsController < ApplicationController
  def create
    response = CreationService.new.create(creation_params)

    if response[:success]
      render json: response[:entity], status: :processing
    else
      render json: response[:errors], status: :unprocessable_entity
    end
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