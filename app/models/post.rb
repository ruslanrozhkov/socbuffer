# == Schema Information
#
# Table name: posts
#
#  id           :integer          not null, primary key
#  content      :text
#  scheduled_at :datetime
#  state        :string
#  user_id      :integer
#  facebook     :boolean
#  twitter      :boolean
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#

class Post < ApplicationRecord
  validates_presence_of :content
  validates_presence_of :scheduled_at
  validates_length_of :content, maximum: 140, message: 'Less than 140 please'
  validates_datetime :scheduled_at, :on => :create, :on_or_after => Time.zone.now

  belongs_to :user
end
