class ModuleInstancesController < ApplicationController
    before_action :set_epitech_module_instance, only: [:show, :edit, :update, :destroy, :generate_datas, :generate_definition]

    add_breadcrumb 'Home', :root_path
    add_breadcrumb 'Modules', :epitech_modules_path

    # GET /epitech_module_instances
    # GET /epitech_module_instances.json
    def index
        add_breadcrumb 'Instances', :module_instances_path

        @scholar_years = ModuleInstance.select(:scholar_year).order(scholar_year: 'desc').map(&:scholar_year)
        redirect_to module_instances_path({scholar_year: @scholar_years.first}) unless params[:scholar_year]
        @module_instances = ModuleInstance.all.includes(:epitech_module).where(scholar_year: params[:scholar_year])
    end

    # GET /epitech_module_instances/1
    # GET /epitech_module_instances/1.json
    def show
        add_breadcrumb @epitech_module.code, epitech_module_path(@epitech_module)
        add_breadcrumb "#{@module_instance.scholar_year}-#{@module_instance.code}", module_instance_path(@module_instance)

        @registrations = @module_instance.module_instance_student_relations.includes(:student)
    end

    def generate_definition
    end

    def generate_datas
    end

    # GET /epitech_module_instances/new
    def new
        @module_instance = ModuleInstance.new
    end

    # GET /epitech_module_instances/1/edit
    def edit
    end

    # POST /epitech_module_instances
    # POST /epitech_module_instances.json
    def create
        @module_instance = ModuleInstance.new(epitech_module_instance_params)

        respond_to do |format|
            if @module_instance.save
                format.html { redirect_to @module_instance, notice: 'Epitech module instance was successfully created.' }
                format.json { render :show, status: :created, location: @module_instance }
            else
                format.html { render :new }
                format.json { render json: @module_instance.errors, status: :unprocessable_entity }
            end
        end
    end

    # PATCH/PUT /epitech_module_instances/1
    # PATCH/PUT /epitech_module_instances/1.json
    def update
        respond_to do |format|
            if @module_instance.update(epitech_module_instance_params)
                format.html { redirect_to @module_instance, notice: 'Epitech module instance was successfully updated.' }
                format.json { render :show, status: :ok, location: @module_instance }
            else
                format.html { render :edit }
                format.json { render json: @module_instance.errors, status: :unprocessable_entity }
            end
        end
    end

    # DELETE /epitech_module_instances/1
    # DELETE /epitech_module_instances/1.json
    def destroy
        @module_instance.destroy
        respond_to do |format|
            format.html { redirect_to epitech_module_instances_url, notice: 'Epitech module instance was successfully destroyed.' }
            format.json { head :no_content }
        end
    end

    private

    # Use callbacks to share common setup or constraints between actions.
    def set_epitech_module_instance
        @module_instance = ModuleInstance.find(params[:id])
        @epitech_module = @module_instance.epitech_module
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def epitech_module_instance_params
        params[:module_instance]
    end
end
