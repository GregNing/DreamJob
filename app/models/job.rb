class Job < ApplicationRecord
    validates :title, :description,:contact_email ,presence: {message: "必填項目!"}
    validates :wage_upper_bound,numericality: { greater_than: 0, message: "請輸入金額而且大於0!" }
    validates :wage_lower_bound, numericality: { greater_than: 0, message: "請輸入金額而且大於0!"  }
    scope :desc_by_created, ->{ order("created_at DESC") }
    scope :desc_by_wage_lower_bound, ->{ order("wage_lower_bound DESC") }
    scope :desc_by_wage_upper_bound, ->{ order("wage_upper_bound DESC") }
end
