# == Schema Information
#
# Table name: collections
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Collection < ApplicationRecord
    belongs_to :user
    belongs_to :job
end
