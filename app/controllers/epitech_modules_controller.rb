class EpitechModulesController < ApplicationController
  before_action :set_epitech_module, only: [
                                       :show,
                                       :validation_stats,
                                       :project_stats,
                                       :edit,
                                       :update,
                                       :destroy
                                   ]

  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Modules', :epitech_modules_path

  # GET /epitech_modules
  # GET /epitech_modules.json
  def index
      @epitech_modules = EpitechModule.all.includes(:semesters, :courses, :schools)
  end

  def instances_2015
      @epitech_modules = EpitechModule.where(id: ModuleInstance.includes(:epitech_module).where(scholar_year: 2015).pluck(:epitech_module_id))
  end

  # GET /epitech_modules/1
  # GET /epitech_modules/1.json
  def show
      add_breadcrumb @epitech_module.name, epitech_module_path(@epitech_module)
  end

  def validation_stats
      add_breadcrumb @epitech_module.name, epitech_module_path(@epitech_module)
      add_breadcrumb 'Validation stats', validation_stats_epitech_module_path(@epitech_module)
  end

  def project_stats
      add_breadcrumb @epitech_module.name, epitech_module_path(@epitech_module)
      add_breadcrumb 'Project stats', validation_stats_epitech_module_path(@epitech_module)
  end

  # GET /epitech_modules/new
  def new
    @epitech_module = EpitechModule.new
  end

  # GET /epitech_modules/1/edit
  def edit
  end

  # POST /epitech_modules
  # POST /epitech_modules.json
  def create
    @epitech_module = EpitechModule.new(epitech_module_params)

    respond_to do |format|
      if @epitech_module.save
        format.html { redirect_to @epitech_module, notice: 'Epitech module was successfully created.' }
        format.json { render :show, status: :created, location: @epitech_module }
      else
        format.html { render :new }
        format.json { render json: @epitech_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /epitech_modules/1
  # PATCH/PUT /epitech_modules/1.json
  def update
    respond_to do |format|
      if @epitech_module.update(epitech_module_params)
        format.html { redirect_to @epitech_module, notice: 'Epitech module was successfully updated.' }
        format.json { render :show, status: :ok, location: @epitech_module }
      else
        format.html { render :edit }
        format.json { render json: @epitech_module.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /epitech_modules/1
  # DELETE /epitech_modules/1.json
  def destroy
    @epitech_module.destroy
    respond_to do |format|
      format.html { redirect_to epitech_modules_url, notice: 'Epitech module was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epitech_module
      @epitech_module = EpitechModule.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def epitech_module_params
      params[:epitech_module]
    end
end
