require 'lol'
require 'certified'

class LolClient

	def initialize
		@client = Lol::Client.new(Rails.application.secrets.sulai_api_key, {region: "na"})
	end

	private

	attr_reader :client
end