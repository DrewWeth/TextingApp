class HomeController < ActionController::Base
	require 'twilio-ruby'
		
	def index
		
		puts "Twilio authentication"
		account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
		auth_token = 'e9befab8a2ea884e92db21709fe073e1'
		@client = Twilio::REST::Client.new account_sid, auth_token

		# @client.account.messages.create(
		# 	:from => '+13147363270',
		# 	:to => '+13147759588',
		# 	:body => 'Hey there shane, ryan, and dzu!'
		# 	)
		puts "Sent"
	end

end