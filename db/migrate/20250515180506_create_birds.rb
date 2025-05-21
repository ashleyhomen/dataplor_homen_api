class CreateBirds < ActiveRecord::Migration[8.0]
  def change
    create_table :birds do |t|
      t.integer :node_id
      t.string :name
      t.timestamps
    end
  end
end
