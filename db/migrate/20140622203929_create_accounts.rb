class CreateAccounts < ActiveRecord::Migration
  def change
    create_table :accounts do |t|
      t.string :name
      t.string :aws_account_id
      t.string :bucket_name
      t.string :access_key
      t.string :secret
      t.integer :user_id

      t.timestamps
    end
    add_column :users, :account_id, :integer
  end
end
