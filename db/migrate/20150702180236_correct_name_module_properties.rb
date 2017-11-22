class CorrectNameModuleProperties < ActiveRecord::Migration
    def change
        rename_column :epitech_modules, :hide_on_resume, :hidden_on_resume
    end
end
