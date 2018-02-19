# == Schema Information
#
# Table name: categories
#
#  id         :integer          not null, primary key
#  name       :string
#  icon       :string
#  sort       :integer
#  is_hidden  :boolean          default(FALSE)
#  is_lock    :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Category < ApplicationRecord
    validates :name, presence: {message: "請輸入種類名稱!"}
    validates :icon, presence: {message: "請輸入icon代碼!"}
    has_many :jobs
    scope :isshow, -> { where(is_hidden: false) }
    scope :orderbysort, -> { order("sort ASC") }
    scope :descbysort, -> { order("sort DESC") }
end
