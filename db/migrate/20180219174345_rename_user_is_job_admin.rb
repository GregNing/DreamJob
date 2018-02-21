class RenameUserIsJobAdmin < ActiveRecord::Migration[5.1]
  def change
    rename_column :users, :is_job_admin, :is_dreamjob_admin
  end
end
