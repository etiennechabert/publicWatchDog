class ModuleInstanceActivityRelationsController < ApplicationController
    before_action :set_epitech_module_instance_activity, only: [:show, :edit, :update, :destroy]
    before_action :set_epitech_module_instance, only: [:show, :edit, :update, :destroy]
    before_action :set_epitech_module_activity, only: [:show, :edit, :update, :destroy]
    before_action :set_epitech_module, only: [:show, :edit, :update, :destroy]

    add_breadcrumb 'Home', :root_path
    add_breadcrumb 'Modules', :epitech_modules_path

    # GET /module_instance_activities
  # GET /module_instance_activities.json
  def index
    @module_instance_activity_relations = ModuleInstanceActivityRelation.all
  end

  # GET /module_instance_activities/1
  # GET /module_instance_activities/1.json
  def show
      add_breadcrumb @epitech_module.name, epitech_module_path(@epitech_module)
      add_breadcrumb "#{@module_instance.code}(#{@module_instance.scholar_year})", module_instance_path(@module_instance)
      add_breadcrumb "#{@module_activity.title}", module_activity_path(@module_activity)
      add_breadcrumb "#{@module_instance_activity_relation.code}", module_instance_activity_relation_path(@module_instance_activity_relation)
  end

  # GET /module_instance_activities/new
  def new
    @module_instance_activity_relation = ModuleInstanceActivityRelation.new
  end

  # GET /module_instance_activities/1/edit
  def edit
  end

  # POST /module_instance_activities
  # POST /module_instance_activities.json
  def create
    @module_instance_activity_relation = ModuleInstanceActivityRelation.new(epitech_module_instance_activity_params)

    respond_to do |format|
      if @module_instance_activity_relation.save
        format.html { redirect_to @module_instance_activity_relation, notice: 'Epitech module instance activity was successfully created.' }
        format.json { render :show, status: :created, location: @module_instance_activity_relation }
      else
        format.html { render :new }
        format.json { render json: @module_instance_activity_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /module_instance_activities/1
  # PATCH/PUT /module_instance_activities/1.json
  def update
    respond_to do |format|
      if @module_instance_activity_relation.update(epitech_module_instance_activity_params)
        format.html { redirect_to @module_instance_activity_relation, notice: 'Epitech module instance activity was successfully updated.' }
        format.json { render :show, status: :ok, location: @module_instance_activity_relation }
      else
        format.html { render :edit }
        format.json { render json: @module_instance_activity_relation.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /module_instance_activities/1
  # DELETE /module_instance_activities/1.json
  def destroy
    @module_instance_activity_relation.destroy
    respond_to do |format|
      format.html { redirect_to epitech_module_instance_activities_url, notice: 'Epitech module instance activity was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

    private
    def set_epitech_module
        @epitech_module = @module_instance.epitech_module
    end

    def set_epitech_module_activity
        @module_activity = @module_instance_activity_relation.module_activity
    end

    def set_epitech_module_instance
        @module_instance = @module_instance_activity_relation.module_instance
    end

    # Use callbacks to share common setup or constraints between actions.
    def set_epitech_module_instance_activity
      @module_instance_activity_relation = ModuleInstanceActivityRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def epitech_module_instance_activity_params
      params[:module_instance_activity_relation]
    end
end
