require 'lol'

# Initialize the API client
$client = Lol::Client.new(Rails.application.secrets.sulai_api_key, {region: "na"})