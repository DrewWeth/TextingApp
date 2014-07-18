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
		if Log.find(:all).empty?
			log = Log.new
			log.last_serve = DateTime.now
			log.save
		end

		log = Log.find(1)
		logDate = log.last_serve
		# .where(DateSent >= logDate.strftime("%Y/%m/%d"))
		# Change this to notifications
		messagesFromTwilio = @client.account.messages.list({:date_created => logDate})
		messagesFromTwilio.each do |m|
			begin
				message = Message.new(
					:sid => m.sid,
					:body => m.body,
					:to => m.to,
					:from => m.from,
					:created => m.date_created,
					:response => false
					)
				message.save
			rescue Exception => e
				puts e
			end
		end
		puts "Messages from Twilio"
		puts messagesFromTwilio.count
		log.last_serve = DateTime.now
		log.save

		temp = Message.all.where(response: false).where.not(from: "+13147363270")
		puts temp.count
		temp.each do |t|
			first_time = Message.all.where(from: t.from).count
			if first_time == 1
				text_to_send = "Hi, I'm CleverBot. Text me anything! Made by Drew."
			else
				@params = Cleverbot::Client.write t.body
				text_to_send = @params['message']
			end
			
			
			message = Message.find(t.id)
			begin
				message.res_text = text_to_send
				message.save
			
				@client.account.messages.create(
					:from => '+13147363270',
					:to => t.from,
					:body => text_to_send
				)
				message.response = true
				message.save
			rescue Exception => e
				puts e
			end
		end
		
		@update_message = temp.all
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


end