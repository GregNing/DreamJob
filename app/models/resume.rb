# == Schema Information
#
# Table name: resumes
#
#  id         :integer          not null, primary key
#  attachment :string
#  content    :text
#  user_id    :integer
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Resume < ApplicationRecord
    belongs_to :job
    belongs_to :user
    validates :content,presence: {message: "請填入履歷相關內容!"}
    validates :attachment,presence: {message: "請上傳履歷!"}    
    mount_uploader :attachment, AttachmentUploader    
    serialize :attachment, JSON # If you use SQLite, add this line.
    scope :desc_by_created, ->{ order("created_at DESC") }
end
