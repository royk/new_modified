class MessagesController < ApplicationController

	def new
		@message = Message.new
		@recipient = User.find(params[:recipient])
	end

	def show
		@message = Message.find(params[:id])
		@message.read = true
		@message.save
		@conversation = @message.conversation
	end



	def create
		recipient = User.find_by_name(params[:recipient])
		conversation = Conversation.new

		if !recipient.nil?
			message = conversation.messages.build(params[:message])
			message.sender = current_user
			message.recipient = recipient
			message.read = false
			if conversation.save! && message.save!
				flash[:success] = "Message sent"
			else
				flash[:error] = "Can't send message"
			end
		else
			flash[:error] = "User not found"
		end
		redirect_to root_url
	end
end