class AddActivation2ToUsers < ActiveRecord::Migration[5.1]
  def change
    add_column :users, :activation_digest, :string
  end
end
