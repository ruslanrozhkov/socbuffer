Rails.application.config.middleware.use OmniAuth::Builder do
  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']
  provider :facebook, ENV['FB_ID'], ENV['FB_KEY'], scope: 'email,publish_actions'
end

OmniAuth.config.on_failure = Proc.new do |env|
  ConnectionsController.action(:omniauth_failure).call(env)
end