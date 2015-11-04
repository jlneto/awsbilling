class ReportsDropColumns < ActiveRecord::Migration
  def change
    remove_column :reports, :value
    remove_column :reports, :previous_value
    remove_column :reports, :day_average
    remove_column :reports, :previous_day_average
  end
end
