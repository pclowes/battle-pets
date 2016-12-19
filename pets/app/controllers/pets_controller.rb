class PetsController < ApplicationController
  def create
    pet = Pet.new(pet_creation_params)

    if pet.save
      render json: pet, status: :created
    else
      render json: pet.errors.full_messages, status: :unprocessable_entity
    end
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