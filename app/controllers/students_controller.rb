class StudentsController < ApplicationController
  before_action :set_student, only: [:show, :edit, :update, :destroy]

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Students', :followed_students_users_path

  # GET /students
  # GET /students.json
  def index
      @students = Student.all
      if params['term']
          @students = Student.where(Student.arel_table[:login].matches("#{params[:term]}%")).limit(10)
      end
  end

  # GET /students/1
  # GET /students/1.json
  def show
      add_breadcrumb @student.login, student_path(@student.login)
      @student_data = gon.jbuilder template: 'app/views/students/show.json.jbuilder', as: 'student_data' if request.format.symbol != :json
  end

  def chances
      add_breadcrumb 'By % of chances'

      params[:value] = 0 unless params[:value].to_i.to_s == params[:value] # Hook to filter only integer values

      @students = current_user.students.where(success_chance: params[:value]).includes(:student_checkup_relations)
  end

  def checkups
      add_breadcrumb 'By date of checkups'

      @day_values, @students = current_user.students_checkup_range(params[:value].to_sym)
  end

  # GET /students/new@
  def new
    @student = Student.new
  end

  # GET /students/1/edit
  def edit
  end

  # POST /students
  # POST /students.json
  def create
    @student = Student.new(student_params)

    respond_to do |format|
      if @student.save
        format.html { redirect_to @student, notice: 'Student was successfully created.' }
        format.json { render :show, status: :created, location: @student }
      else
        format.html { render :new }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /students/1
  # PATCH/PUT /students/1.json
  def update
    respond_to do |format|
      if @student.update(student_params)
        format.html { redirect_to @student, notice: 'Student was successfully updated.' }
        format.json { render :show, status: :ok, location: @student }
      else
        format.html { render :edit }
        format.json { render json: @student.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /students/1
  # DELETE /students/1.json
  def destroy
    @student.destroy
    respond_to do |format|
      format.html { redirect_to students_url, notice: 'Student was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def checkup_submission

  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_student
      @student = Student.find_by_login(params[:login])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def student_params
      params[:student]
    end
end
