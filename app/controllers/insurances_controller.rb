class InsurancesController < ApplicationController

  # skip_before_action :authenticate_request
  before_action :set_insurance, only: [:show, :update, :destroy]

  def index
    @insurances = Insurance.all
    render json: @insurances, status: :ok
  end

  def show
    render json: @insurance, status: :ok
  end

  def create
    @insurance = Insurance.new(user_params)
    if @insurance.save
      render json: @insurance, status: :created
    else
      render json: {errors: @insurance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def update
    unless @insurance.update(insurance_params)
      render json: {errors: @insurance.errors.full_messages}, status: :unprocessable_entity
    end
  end

  def destroy
    @insurance.destroy
  end

  private

    def insurance_params
      params.permit(:age, :sex, :bmi, :children, :smoker, :region, :charges)
    end

    def set_insurance
      @insurance = Insurance.find(params[:id])
    end

end
