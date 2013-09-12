class CreateMasterusers < ActiveRecord::Migration
  def change
    create_table :masterusers, :primary_key =>:master_user_id do |t|
      t.integer :master_user_id
      t.string :url_name
      t.string :password
	  t.string :shop_name
	  t.string :first_name
	  t.string :last_name
      t.string :address
      t.string :landmark
      t.string :city
      t.string :state
      t.string :pincode
      t.string :country
      t.string :phone
      t.string :master_email
      t.boolean :validate
	  t.string :theam
	  
      t.timestamps
    end
	add_index :masterusers, [:url_name], :unique => true
	add_index :masterusers, [:master_email], :unique => true
  end
end
