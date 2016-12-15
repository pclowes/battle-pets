class PetsController < ApplicationController
  def create
    pet = Pet.create!(pet_creation_params)
    render json: pet, status: :created
  end

  private

  def pet_creation_params
    params.permit(
        :name,
        :strength,
        :agility,
        :wit,
        :senses,
        :experience,
    )
  end

end