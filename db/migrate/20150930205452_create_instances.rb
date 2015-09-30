class CreateInstances < ActiveRecord::Migration
  def change
    create_table :instances do |t|
      t.references :account, index: true
      t.string :name
      t.string :description
      t.string :instance_id
      t.string :instance_type
      t.string :region
      t.string :availability_zone
      t.string :dns_address
      t.string :public_ip_address
      t.string :public_dns_name
      t.string :state
      t.datetime :started_at
      t.datetime :stopped_at
      t.timestamps
    end
  end
end
