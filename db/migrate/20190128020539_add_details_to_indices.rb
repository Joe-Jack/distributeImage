class AddDetailsToIndices < ActiveRecord::Migration
  def change
    add_column :indices, :parkname, :string
    add_column :indices, :playground, :string
    add_column :indices, :explanation, :string
    add_column :indices, :judge, :string
    add_column :indices, :remark, :string
  end
end
