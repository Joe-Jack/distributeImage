class CreatePictures < ActiveRecord::Migration
  def change
    create_table :pictures do |t|
      t.text :pic
      t.integer :index_id

      t.timestamps null: false
    end
  end
end
