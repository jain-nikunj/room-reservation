OmniAuth.config.logger = Rails.logger

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :google_oauth2, '327097753764-d5kfqr6gid3b0q95sun0nbhpp55l7q4q.apps.googleusercontent.com', 'o0iODJDuhHYpgqFPU9Nw2HJL',
  {
      
      hd: 'berkeley.edu'
  }
end