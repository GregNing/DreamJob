class AddCategoryandlocationToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :categorie_id, :integer
    add_column :jobs, :location_id, :integer
    add_column :jobs, :company, :string
  end
end
