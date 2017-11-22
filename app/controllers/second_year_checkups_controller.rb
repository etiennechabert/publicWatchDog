class SecondYearCheckupsController < ApplicationController
  before_action :set_second_year_checkup, only: [:show, :edit, :update, :destroy]

  # GET /second_year_checkups
  # GET /second_year_checkups.json
  def index
    @second_year_checkups = SecondYearCheckup.all
  end

  # GET /second_year_checkups/1
  # GET /second_year_checkups/1.json
  def show
  end

  # GET /second_year_checkups/new
  def new
    @second_year_checkup = SecondYearCheckup.new
  end

  # GET /second_year_checkups/1/edit
  def edit
  end

  # POST /second_year_checkups
  # POST /second_year_checkups.json
  def create
    @second_year_checkup = SecondYearCheckup.new(second_year_checkup_params)

    respond_to do |format|
      if @second_year_checkup.save
        format.html { redirect_to @second_year_checkup, notice: 'Second year checkup was successfully created.' }
        format.json { render :show, status: :created, location: @second_year_checkup }
      else
        format.html { render :new }
        format.json { render json: @second_year_checkup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /second_year_checkups/1
  # PATCH/PUT /second_year_checkups/1.json
  def update
    respond_to do |format|
      if @second_year_checkup.update(second_year_checkup_params)
        format.html { redirect_to @second_year_checkup, notice: 'Second year checkup was successfully updated.' }
        format.json { render :show, status: :ok, location: @second_year_checkup }
      else
        format.html { render :edit }
        format.json { render json: @second_year_checkup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /second_year_checkups/1
  # DELETE /second_year_checkups/1.json
  def destroy
    @second_year_checkup.destroy
    respond_to do |format|
      format.html { redirect_to second_year_checkups_url, notice: 'Second year checkup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_second_year_checkup
      @second_year_checkup = SecondYearCheckup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def second_year_checkup_params
      params[:second_year_checkup]
    end
end
