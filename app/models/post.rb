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
  after_create :schedule

  belongs_to :user

  def schedule
    begin
      ScheduleJob.set(wait_until: scheduled_at).perform_later(self)
      self.update_attributes(state: 'scheduled')
    rescue Exception => e
      self.update_attributes(state: 'scheduling error', error: e.message)
    end
  end

  def display
    begin
      unless state == 'canceled'
        if facebook == true
          to_facebook
        end
        if twitter == true
          to_twitter
        end
      end
      self.update_attributes(state: 'posted')
    rescue Exception => e
      self.update_attributes(state: 'posting error', error: e.message)
    end
  end

  def to_twitter
    client = Twitter::REST::Client.new do |config|
      config.access_token = self.user.twitter.oauth_token
      config.access_token_secret = self.user.twitter.secret
      config.consumer_key = ENV['TWITTER_KEY']
      config.consumer_secret = ENV['TWITTER_SECRET']
    end
    client.update(self.content)
  end

  def to_facebook
    graph = Koala::Facebook::API.new(self.user.facebook.oauth_token)
    graph.put_connections('me', 'feed', message: self.content)
  end
end
