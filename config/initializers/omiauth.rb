Rails.application.config.middleware.use OmniAuth::Builder do
  # provider :github, ENV['5d1107295ea37e9b3049'], 
  #                   ENV['dd05dcb96c4f8ade4357a0315cdb884323756b01'],
  #                   scope: "user:email"
  provider :github, ENV['client_id'], ENV['client_secret'], scope: "user:email"
end