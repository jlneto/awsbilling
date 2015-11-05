class ReportLinesAddNewColumns < ActiveRecord::Migration
  def change
    add_column :report_lines, :product_name, :string
    add_column :report_lines, :blended_cost, :decimal, scale: 2, precision: 10
    add_column :report_lines, :unblended_cost, :decimal, scale: 2, precision: 10
    add_column :report_lines, :date, :date
    add_column :report_lines, :resource_id, :string
    add_column :report_lines, :resource_name, :string
    add_column :report_lines, :az, :string
    add_column :report_lines, :custo, :string

    remove_column :report_lines, :value
  end
end
