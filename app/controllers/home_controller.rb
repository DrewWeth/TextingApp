class HomeController < ApplicationController
	private 
	
	def page_visited
		
		if !Utility.take.blank?
			update = Utility.take
			update.general_counts += 1
			update.save
		else
			Utility.create
		end
		update.general_counts
	end

	public
	def index
		@count = page_visited
	end

	def update
		page_visited
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

		temp = Message.all.where(response: false).where.not(from: "+13147363270").where.not(from: "+14152339273")
		temp.each do |t|
			first_time = Message.all.where(from: t.from).count
			text_to_send = "Woopsi. Error!"
			if first_time == 1
				text_to_send = "Hi, I'm Clever Text. Text me anything! Made by Drew."
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
	end

	def subscribe
		require 'twilio-ruby'

		number = params[:number]
		number = number.to_s.gsub('/\D/','').to_i
		

		if number.to_s.length == 11
			puts "Twilio authentication"
			account_sid = 'AC29e7b96239c5f0bfc6ab8b724e263f30'
			auth_token = 'e9befab8a2ea884e92db21709fe073e1'
			text_to_send = "Hi, I'm Clever Text. Text me anything! Made by Drew."

			begin
				@client = Twilio::REST::Client.new account_sid, auth_token
				@client.account.messages.create(
					:from => '+13147363270',
					:to => number,
					:body => text_to_send
				)
				respond_to do |format|
	          		format.html { redirect_to root_path, notice: 'Text sent to ' + number.to_s }
      		        format.json { render :show, status: :created, location: root_path }
	          	end
			end	
		else
			respond_to do |format|
          		format.html { redirect_to root_path, notice: 'Number invalid. Must be 11 digits. Text not sent.' }
          		format.json { render :show, status: :created, location: root_path }

			end
		end
		
	end


	def all
		page_visited
		@messages = Message.all
	end



end