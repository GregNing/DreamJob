class RenameTableCatrgories < ActiveRecord::Migration[5.1]
  def change    
    rename_table :categories, :category
  end
end
