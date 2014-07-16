class HomeController < ActionController::Base
	def update
		require 'twilio-ruby'
		require 'cleverbot'

		puts "Twilio authentication"
		account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
		auth_token = 'e9befab8a2ea884e92db21709fe073e1'
		begin
			@client = Twilio::REST::Client.new account_sid, auth_token
		rescue Twilio::RESR::RequestError => e
			puts e.message
		end
		
		puts "Messages from Twilio"		

		sendMessage

	
	end

	def index

		messages = Message.all.where(response: false)
		messages.each do |m|
			user = Message.find(m.id)
			user.response = true
			user.save
		end
		puts messages.count

	end

	private 
	def sendMessage
		require 'twilio-ruby'
		require 'cleverbot'
		# temp = Message.all.where(response: false).where.not(from: "+13147363270")
		# puts temp.count
		prng = Random.new_seed
		arr = ["It's my birthday", "Hey it's my bday", "Tell me happy birthday", "Guess whose birthday it is!", "Is it my birthday", "What is today? Its my birthday", "Yay its my birthday"]
		20.times do
			num = rand(arr.size)
			@params = Cleverbot::Client.write arr[num]
			begin
				res_text = @params['message']			
				# 
				@client.account.messages.create(
					:from => '+13147363270',
					:to => '+14172092813',
					:body => @params['message']
				)
			rescue Exception => e
				puts e
			end
		end
		@client.account.messages.create(
			:from => '+13147363270',
			:to => '+14172092813',
			:body => 'This one isnt random. Happy birthday -- 21 texts for 21 years.'
		)
	end
end