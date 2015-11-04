class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :account_id
      t.date :period
      t.decimal :value, scale: 2, precision: 10
      t.timestamps
    end
  end
end
