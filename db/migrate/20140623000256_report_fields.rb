class ReportFields < ActiveRecord::Migration
  def change
    add_column :reports, :previous_value, :decimal, scale: 2
    add_column :reports, :day_average, :decimal, scale: 2
    add_column :reports, :previous_day_average, :decimal, scale: 2
    add_column :reports, :reference_day, :integer
  end
end
