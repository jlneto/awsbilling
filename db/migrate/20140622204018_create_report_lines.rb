class CreateReportLines < ActiveRecord::Migration
  def change
    create_table :report_lines do |t|
      t.string :report_id
      t.string :service
      t.decimal :value, scale: 2

      t.timestamps
    end
  end
end
