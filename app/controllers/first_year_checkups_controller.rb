class FirstYearCheckupsController < ApplicationController
  before_action :set_first_year_checkup, only: [:show, :edit, :update, :destroy]

  # GET /first_year_checkups
  # GET /first_year_checkups.json
  def index
    @first_year_checkups = FirstYearCheckup.all
  end

  # GET /first_year_checkups/1
  # GET /first_year_checkups/1.json
  def show
  end

  # GET /first_year_checkups/new
  def new
    @first_year_checkup = FirstYearCheckup.new
  end

  # GET /first_year_checkups/1/edit
  def edit
  end

  # POST /first_year_checkups
  # POST /first_year_checkups.json
  def create
      @student = Student.find_by_login(params[:student])
      @first_year_checkup = FirstYearCheckup.new(first_year_checkup_params.merge({student_login: params[:student], user_login: current_user.login}))

      respond_to do |format|
          if @first_year_checkup.save
              format.html { redirect_to student_path(@student.login), success: 'First year checkup was successfully created.' }
              format.json { render :show, status: :created, location: @first_year_checkup }
          else
              format.html { redirect_to student_path(@student.login), warning: 'First year checkup was not created' }
              format.json { render json: @first_year_checkup.errors, status: :unprocessable_entity }
          end
      end
  end

  # PATCH/PUT /first_year_checkups/1
  # PATCH/PUT /first_year_checkups/1.json
  def update
    respond_to do |format|
      if @first_year_checkup.update(first_year_checkup_params)
        format.html { redirect_to @first_year_checkup, notice: 'First year checkup was successfully updated.' }
        format.json { render :show, status: :ok, location: @first_year_checkup }
      else
        format.html { render :edit }
        format.json { render json: @first_year_checkup.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /first_year_checkups/1
  # DELETE /first_year_checkups/1.json
  def destroy
    @first_year_checkup.destroy
    respond_to do |format|
      format.html { redirect_to first_year_checkups_url, notice: 'First year checkup was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_first_year_checkup
      @first_year_checkup = FirstYearCheckup.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def first_year_checkup_params
      params[:first_year_checkup].permit(%w(absent nature success_chance comment objectives due_date post_it))
    end
end
