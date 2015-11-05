class AddKeys < ActiveRecord::Migration
  def change
    add_foreign_key "report_lines", "reports", name: "report_lines_report_id_fk"
    add_foreign_key "accounts", "users", name: "accounts_user_id_fk"
    add_foreign_key "instances", "accounts", name: "instances_account_id_fk"
    add_foreign_key "reports", "accounts", name: "reports_account_id_fk"
  end
end
