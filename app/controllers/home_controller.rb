class HomeController < ActionController::Base
		
	def index
		require 'twilio-ruby'
		puts "Twilio authentication"
		account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
		auth_token = 'e9befab8a2ea884e92db21709fe073e1'
		begin
		@client = Twilio::REST::Client.new account_sid, auth_token

		# @client.account.messages.create(
		# 	:from => '+13147363270',
		# 	:to => '+13147759588',
		# 	:body => 'Hey there shane, ryan, and dzu!'
		# 	)
		puts "Sent"
		rescue Twilio::RESR::RequestError => e
			puts e.message
		end

		@client.account.messages.list.each do |m|
			puts "body{" +m.body+ "} to{" +m.to+ "} from{" +m.from+ "} created{" +m.date_created+ "}"
		end


		# -----------------------------------------------------

		require 'cleverbot'	

		@params = Cleverbot::Client.write 'Hi'
		@params['message']


	end

end