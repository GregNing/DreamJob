class CreateResumes < ActiveRecord::Migration[5.1]
  def change
    create_table :resumes do |t|
      t.string :attachment
      t.text :content
      t.integer :user_id
      t.integer :job_id
      t.timestamps
    end
  end
end
