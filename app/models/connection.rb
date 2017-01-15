# == Schema Information
#
# Table name: connections
#
#  id          :integer          not null, primary key
#  provider    :string
#  oauth_token :string
#  secret      :string
#  user_id     :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

class Connection < ApplicationRecord
  belongs_to :user

  def self.create_from_omniauth(auth_hash)
    create(
        provider: auth_hash.provider,
        oauth_token: auth_hash.credentials.token,
        secret: auth_hash.credentials.secret,
    )
  end
end
