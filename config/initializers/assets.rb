# Be sure to restart your server when you modify this file.

# Version of your assets, change this if you want to expire all your assets.
Rails.application.config.assets.version = '1.0'
Rails.application.config.assets.precompile += [ 'sessions.css', 'profiles.css', 'password_resets.css',
																							'search.css', 'friendships.css' ]

# Add images here
Rails.application.config.assets.precompile += [ 'ahri_lol_small.png', 'login_banner.png', 'login_bg', 'signup_banner.png' ]
Rails.application.config.assets.precompile += %w( formValidate.js )
# Add additional assets to the asset load path
# Rails.application.config.assets.paths << Emoji.images_path

# Precompile additional assets.
# application.js, application.css, and all non-JS/CSS in app/assets folder are already added.
# Rails.application.config.assets.precompile += %w( search.js )
