# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.

SplitsIO::Application.config.secret_key_base =
  (Rails.env.development? || Rails.env.test?) ?  ('x' * 30) : ENV['splitsio_secret_key_base']
