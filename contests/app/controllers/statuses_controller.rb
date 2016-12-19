class StatusesController < ApplicationController
  def index
    job_id = params[:job_id]
    if Sidekiq::Status::complete?(job_id)
      render json: {message: "Contest complete"}, status: :ok
    elsif Sidekiq::Status::failed?(job_id)
      render json: {message: "Contest failed"}, status: :internal_server_error
    else
      render json: {message: "Contest processing"}, status: :processing
    end
  end
end