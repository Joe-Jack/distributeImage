class CreateIndices < ActiveRecord::Migration
  def change
    create_table :indices do |t|
      t.string :name
      t.integer :num
      t.integer :pictures_count

      t.timestamps null: false
    end
  end
end
