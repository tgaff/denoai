GoodJob::Engine.middleware.use(Rack::Auth::Basic) do |username, password|
  creds = Rails.application.credentials.good_job
  ActiveSupport::SecurityUtils.secure_compare(creds.username, username) &&
    ActiveSupport::SecurityUtils.secure_compare(creds.password, password)
end