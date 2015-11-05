class ChangeFkTypes < ActiveRecord::Migration
  def change
    remove_column :report_lines, :report_id
    add_column :report_lines, :report_id, :integer

    remove_column :reports, :account_id
    add_column :reports, :account_id, :integer
  end
end
