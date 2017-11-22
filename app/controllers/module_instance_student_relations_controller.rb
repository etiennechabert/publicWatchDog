class ModuleInstanceStudentRelationsController < ApplicationController
  before_action :set_epitech_module_instance_student_relationship, only: [:show, :edit, :update, :destroy]

  # GET /epitech_module_instance_student_relationships
  # GET /epitech_module_instance_student_relationships.json
  def index
    @module_instance_student_relations = ModuleInstanceStudentRelation.all
  end

  # GET /epitech_module_instance_student_relationships/1
  # GET /epitech_module_instance_student_relationships/1.json
  def show
  end

  # GET /epitech_module_instance_student_relationships/new
  def new
    @module_instance_student_relations = ModuleInstanceStudentRelation.new
  end

  # GET /epitech_module_instance_student_relationships/1/edit
  def edit
  end

  # POST /epitech_module_instance_student_relationships
  # POST /epitech_module_instance_student_relationships.json
  def create
    @module_instance_student_relations = ModuleInstanceStudentRelation.new(epitech_module_instance_student_relationship_params)

    respond_to do |format|
      if @module_instance_student_relations.save
        format.html { redirect_to @module_instance_student_relations, notice: 'Epitech module instance student relationship was successfully created.' }
        format.json { render :show, status: :created, location: @module_instance_student_relations }
      else
        format.html { render :new }
        format.json { render json: @module_instance_student_relations.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /epitech_module_instance_student_relationships/1
  # PATCH/PUT /epitech_module_instance_student_relationships/1.json
  def update
    respond_to do |format|
      if @module_instance_student_relations.update(epitech_module_instance_student_relationship_params)
        format.html { redirect_to @module_instance_student_relations, notice: 'Epitech module instance student relationship was successfully updated.' }
        format.json { render :show, status: :ok, location: @module_instance_student_relations }
      else
        format.html { render :edit }
        format.json { render json: @module_instance_student_relations.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /epitech_module_instance_student_relationships/1
  # DELETE /epitech_module_instance_student_relationships/1.json
  def destroy
    @module_instance_student_relations.destroy
    respond_to do |format|
      format.html { redirect_to epitech_module_instance_student_relationships_url, notice: 'Epitech module instance student relationship was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_epitech_module_instance_student_relationship
      @module_instance_student_relations = ModuleInstanceStudentRelation.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def epitech_module_instance_student_relationship_params
      params[:module_instance_student_relations]
    end
end
