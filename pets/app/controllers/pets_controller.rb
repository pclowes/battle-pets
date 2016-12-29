class PetsController < ApplicationController
  protect_from_forgery with: :null_session, if: Proc.new { |c| c.request.format == 'application/json' }

  def create
    pet = Pet.new(pet_creation_params)

    if pet.save
      render json: pet, status: :created
    else
      render json: pet.errors.full_messages, status: :unprocessable_entity
    end
  end

  def index
    pets = Pet.all
    if params[:pet_ids]
      pets = pets.where("id IN (?)", params[:pet_ids])
    end
    render json: pets, status: :ok
  end

  def show
    render json: Pet.find(params[:id])
  end

  def contest_result
    ResultService.new.update(result_params)
    render json: {message: "Results posted"}, status: :ok
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

  def result_params
    params.permit(
        winners: [],
        losers: []
    )
  end
end