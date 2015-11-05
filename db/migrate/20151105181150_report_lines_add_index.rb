class ReportLinesAddIndex < ActiveRecord::Migration
  def change
    add_index :report_lines, :service, :name => 'report_lines_service_idx'
    add_index :report_lines, :resource_id, :name => 'report_lines_resource_id_idx'
    add_index :report_lines, :date, :name => 'report_lines_date_idx'
    add_index :report_lines, :custo, :name => 'report_lines_custo_idx'
  end
end
