# == Schema Information
#
# Table name: locations
#
#  id         :integer          not null, primary key
#  name       :string
#  sort       :integer
#  is_hidden  :boolean          default(FALSE)
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Location < ApplicationRecord
    validates :name, presence: { message: "請輸入工作地點" }
    has_many :jobs
    scope :isshow, -> { where(is_hidden: false) }
    scope :orderbysort, -> { order("sort ASC") }
    scope :descbysort, -> { order("sort DESC") }
end
