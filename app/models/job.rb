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
#  categorie_id     :integer
#  location_id      :integer
#  company          :string
#

class Job < ApplicationRecord
    validates :title, :description,:contact_email ,presence: {message: "必填項目!"}
    validates :wage_upper_bound,numericality: { greater_than: 0, message: "請輸入金額而且大於0!" }
    validates :wage_lower_bound, numericality: { greater_than: 0, message: "請輸入金額而且大於0!"  }
    validates :company, presence: { message: "請填寫公司名稱" }
    validates :category, presence: { message: "請選擇職位類型" }
    validates :location, presence: { message: "請選擇公司地點" }
    validates_format_of :contact_mail, :with => /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\Z/i , message: "請輸入正確的信箱格式"

    scope :desc_by_created, ->{ order("created_at DESC") }
    scope :desc_by_wage_lower_bound, ->{ order("wage_lower_bound DESC") }
    scope :desc_by_wage_upper_bound, ->{ order("wage_upper_bound DESC") }
    scope :isshow, ->{ where(is_hidden: false) }
    scope :lowerbound5, -> { where('wage_lower_bound <= 5 or wage_upper_bound <= 5') }
    scope :lowerbound10, -> { where('wage_lower_bound between 5 and 10 or wage_upper_bound between 5 and 10') }
    scope :lowerbound15, -> { where('wage_lower_bound between 10 and 15 or wage_upper_bound between 10 and 15') }
    scope :lowerbound25, -> { where('wage_lower_bound between 15 and 25 or wage_upper_bound between 15 and 25') }
    scope :lowerbound30, -> { where('wage_lower_bound >= 25 or wage_upper_bound >= 25') }
    scope :random5, -> { limit(5).order("RANDOM()") }
    
    belongs_to :user
    belongs_to :location
    belongs_to :category
    has_many :resumes, dependent: :destroy
    has_many :collections, dependent: :destroy
    has_many :members, through: :collections, source: :user
    
    def publish!
        self.is_hidden = false
        self.save
    end
    def hide!
        self.is_hidden = true
        self.save
    end
end
