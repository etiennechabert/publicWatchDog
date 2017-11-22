class EditOnModuleInstanceActivityRelation < ActiveRecord::Migration
  def change
      rename_column :module_instance_activity_relations, :as_grades, :is_grades
      change_column :module_instance_activity_relations, :is_grades, :boolean, default: false

      add_column :module_instance_activity_relations, :is_project, :boolean, default: false
      add_column :module_instance_activity_relations, :is_registration, :boolean, default: false
  end
end
