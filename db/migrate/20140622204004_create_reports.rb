class CreateReports < ActiveRecord::Migration
  def change
    create_table :reports do |t|
      t.string :account_id
      t.string :period
      t.string :value

      t.timestamps
    end
  end
end
