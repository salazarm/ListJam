class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.string :email
    	t.boolean :temp, :default => false
		  t.string :password_digest
		  t.string :password_salt
      t.integer :active_list_id

      t.timestamps
    end
  end
end
