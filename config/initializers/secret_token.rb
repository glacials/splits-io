# The secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

Rails.application.config.secret_key_base = if Rails.env.development? || Rails.env.test?
  'x' * 30
else
  ENV['SECRET_KEY_BASE']
end
