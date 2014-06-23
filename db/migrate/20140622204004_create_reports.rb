class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :account_id
      t.date :period
      t.decimal :value, scale: 2
      t.timestamps
    end
  end
end
