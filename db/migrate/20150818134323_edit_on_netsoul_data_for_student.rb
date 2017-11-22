class EditOnNetsoulDataForStudent < ActiveRecord::Migration
  def change
      remove_column :students, :log_time_week_1
      remove_column :students, :log_time_week_2
      remove_column :students, :log_time_week_3
      remove_column :students, :log_time_week_4
      remove_column :students, :log_time_month_1
      remove_column :students, :log_time_month_2
      remove_column :students, :log_time_month_3
      add_column :students, :logs, :text, :limit => 4294967295
  end
end
