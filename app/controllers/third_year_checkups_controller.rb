class ThirdYearCheckupsController < ApplicationController
  before_action :set_third_year_checkup, only: [:show, :edit, :update, :destroy]

  # GET /third_year_checkups
  # GET /third_year_checkups.json
  def index
    @third_year_checkups = ThirdYearCheckup.all
  end

  # GET /third_year_checkups/1
  # GET /third_year_checkups/1.json
  def show
  end

  # GET /third_year_checkups/new
  def new
    @third_year_checkup = ThirdYearCheckup.new
  end

  # GET /third_year_checkups/1/edit
  def edit
  end

  # POST /third_year_checkups
  # POST /third_year_checkups.json
  def create
    @third_year_checkup = ThirdYearCheckup.new(third_year_checkup_params)

    respond_to do |format|
      if @third_year_checkup.save
        format.html { redirect_to @third_year_checkup, notice: 'Third year checkup was successfully created.' }
        format.json { render :show, status: :created, location: @third_year_checkup }
      else
        format.html { render :new }
        format.json { render json: @third_year_checkup.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /third_year_checkups/1
  # PATCH/PUT /third_year_checkups/1.json
  def update
    respond_to do |format|
      if @third_year_checkup.update(third_year_checkup_params)
        format.html { redirect_to @third_year_checkup, notice: 'Third year checkup was successfully updated.' }
        format.json { render :show, status: :ok, location: @third_year_checkup }
      else
        format.html { render :edit }
        format.json { render json: @third_year_checkup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /third_year_checkups/1
  # DELETE /third_year_checkups/1.json
  def destroy
    @third_year_checkup.destroy
    respond_to do |format|
      format.html { redirect_to third_year_checkups_url, notice: 'Third year checkup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_third_year_checkup
      @third_year_checkup = ThirdYearCheckup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def third_year_checkup_params
      params[:third_year_checkup]
    end
end
