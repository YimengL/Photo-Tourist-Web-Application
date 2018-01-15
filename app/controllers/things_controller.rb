class ThingsController < ApplicationController
  before_action :set_thing, only: [:show, :update, :destroy]
  before_action :authenticate_user!, only: [:create, :update, :destroy]
  wrap_parameters :thing, include: ["name", "description", "notes"]

  # GET /things
  # GET /things.json
  def index
    @things = Thing.all
  end

  # GET /things/1
  # GET /things/1.json
  def show
  end

  # POST /things
  # POST /things.json
  def create
    @thing = Thing.new(thing_params)

    if @thing.save
      render :show, status: :created, location: @thing
    else
      render json: { errors: @thing.errors.messages },
        status: :unprocessable_entity
    end
  end

  # PATCH/PUT /things/1
  # PATCH/PUT /things/1.json
  def update
    if @thing.update(thing_params)
      head :no_content
    else
      render json: { errors: @thing.errors.messages },
        status: :unprocessable_entity
    end
  end

  # DELETE /things/1
  # DELETE /things/1.json
  def destroy
    @thing.destroy

    head :no_content
  end

  private

    def set_thing
      @thing = Thing.find(params[:id])
    end

    def thing_params
      params.require(:thing).tap { |p|
        p.require(:name)    # throws ActionController::ParameterMissing
      }.permit(:name, :description, :notes)
    end
end
