# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :string
#  last_sign_in_ip        :string
#  created_at             :datetime         not null
#  updated_at             :datetime         not null
#  is_admin               :boolean          default(FALSE)
#  nickname               :string
#  is_dreamjob_admin      :boolean          default(FALSE)
#

class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable
  validates :nickname, presence: {message: "請輸入姓名!"}  
  has_many :jobs, dependent: :destroy
  has_many :resumes
  has_many :collections
  has_many :collected_jobs, through: :collections, source: :job
  def admin?
    self.is_admin
  end
  def dreamjob_admin?
    self.is_dreamjob_admin
  end
  def is_colectedmember_of?(job)
    collected_jobs.include?(job)
  end

  # 加入收藏
  def add_collection!(job)
    collected_jobs << job
  end

  # 移除收藏
  def remove_collection!(job)
    collected_jobs.delete(job)
  end
end
