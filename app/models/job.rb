# == Schema Information
#
# Table name: jobs
#
#  id               :integer          not null, primary key
#  title            :string
#  description      :text
#  wage_upper_bound :integer
#  wage_lower_bound :integer
#  contact_email    :string
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  is_hidden        :boolean          default(FALSE)
#  user_id          :integer
#

class Job < ApplicationRecord
    validates :title, :description,:contact_email ,presence: {message: "必填項目!"}
    validates :wage_upper_bound,numericality: { greater_than: 0, message: "請輸入金額而且大於0!" }
    validates :wage_lower_bound, numericality: { greater_than: 0, message: "請輸入金額而且大於0!"  }
    scope :desc_by_created, ->{ order("created_at DESC") }
    scope :desc_by_wage_lower_bound, ->{ order("wage_lower_bound DESC") }
    scope :desc_by_wage_upper_bound, ->{ order("wage_upper_bound DESC") }
    scope :ishidden, ->{ where(is_hidden: false) }
    belongs_to :user
    has_many :resumes, dependent: :destroy    
    def publish!
        self.is_hidden = false
        self.save
    end
    def hide!
        self.is_hidden = true
        self.save
    end
end
