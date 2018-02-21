class RenameCategoryToJobs < ActiveRecord::Migration[5.1]
  def change
    rename_column :jobs, :categorie_id, :category_id
  end
end
