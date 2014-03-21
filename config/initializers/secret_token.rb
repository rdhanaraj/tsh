# Be sure to restart your server when you modify this file.

# Your secret key is used for verifying the integrity of signed cookies.
# If you change this key, all old signed cookies will become invalid!

# Make sure the secret is at least 30 characters and all random,
# no regular words or you'll be exposed to dictionary attacks.
# You can use `rake secret` to generate a secure secret key.

# Make sure your secret_key_base is kept private
# if you're sharing your code publicly.
Tsh::Application.config.secret_key_base = ENV['SECRET_TOKEN'] || '5e114875d36f6425f4e5e1e40eb749a66357f4eb755a4fa6e73771ed31ea02d1a08fdf7e87e419a6ae3d30758f5f386d865e43b10197f326e7d493d262f10744'
