class MessagesController < AuthenticatedController
	before_filter	:correct_user,	only: [:show]
	
	def index
		@messages = (current_user.received_messages + current_user.sent_messages).paginate(page: params[:page])
	end

	def new
		@message = Message.new
		@recipient = User.find(params[:recipient])
		@replies_to = Message.find(params[:replies_to]) unless params[:replies_to].nil?
	end

	def show
		@message = Message.find(params[:id])
		@message.read = true
		@message.save
	end

	def get_latest
		render partial: 'shared/messages/header_indicator'
	end



	def create
		recipient = User.find_by_name(params[:recipient])
		if recipient!=current_user
			if !recipient.nil?
				unless params[:replies_to].nil?
					replies_to = Message.find(params[:replies_to])
					conversation = replies_to.conversation
					message = conversation.messages.build(params[:message])
				else
					message = Message.create(params[:message])
					conversation = message.create_conversation()
				end
				message.sender = current_user
				message.recipient = recipient
				message.read = false
				if message.valid?
					if message.save
						flash[:success] = "Message sent"
					else
						flash[:error] = "Can't send message"
					end
				else
					flash[:error] = "Message can't be empty!"
				end
			else
				flash[:error] = "User not found"
			end
		else
			flash[:error] = "Can't send a message to yourself!"
		end
		redirect_to root_url
	end

	private
		def correct_user
			if !current_user.admin?
				my_message = false
				@message = Message.find_by_id(params[:id])
				if !@message.nil?
					my_message = @message.recipient==current_user || @message.sender==current_user
				end
				redirect_to root_url if !my_message
			end
		end
end