class ModuleActivitiesController < ApplicationController
  before_action :set_epitech_module_activity, only: [:show, :edit, :update, :destroy]
  add_breadcrumb 'Home', :root_path
  add_breadcrumb 'Module', :epitech_modules_path

  # GET /module_activities/1
  # GET /module_activities/1.json
  def show
      add_breadcrumb @module_activity.epitech_module.name, epitech_module_path(@module_activity.epitech_module)
      add_breadcrumb @module_activity.title, module_activity_path(@module_activity)
      gon.push({module_activity: @module_activity})
  end

  # GET /module_activities/new
  def new
    @module_activity = ModuleActivity.new
  end

  # GET /module_activities/1/edit
  def edit
  end

  # POST /module_activities
  # POST /module_activities.json
  def create
    @module_activity = ModuleActivity.new(epitech_module_activity_params)

    respond_to do |format|
      if @module_activity.save
        format.html { redirect_to @module_activity, notice: 'Epitech module activity was successfully created.' }
        format.json { render :show, status: :created, location: @module_activity }
      else
        format.html { render :new }
        format.json { render json: @module_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /module_activities/1
  # PATCH/PUT /module_activities/1.json
  def update
    respond_to do |format|
      if @module_activity.update(epitech_module_activity_params)
        format.html { redirect_to @module_activity, notice: 'Epitech module activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @module_activity }
      else
        format.html { render :edit }
        format.json { render json: @module_activity.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /module_activities/1
  # DELETE /module_activities/1.json
  def destroy
    @module_activity.destroy
    respond_to do |format|
      format.html { redirect_to epitech_module_activities_url, notice: 'Epitech module activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epitech_module_activity
      @module_activity = ModuleActivity.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def epitech_module_activity_params
      params[:module_activity]
    end
end
