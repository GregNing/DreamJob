class AddIsHiddenToJobs < ActiveRecord::Migration[5.1]
  def change
    add_column :jobs, :is_hidden, :boolean, default: false
  end
end
