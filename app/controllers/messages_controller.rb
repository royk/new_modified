class MessagesController < AuthenticatedController
	before_filter	:correct_user,	only: [:show]
	
	def index
		@messages = (current_user.received_messages + current_user.sent_messages).sort_by {|f| -f.created_at.to_i}.paginate(page: params[:page])
	end

	def new
		@message = Message.new
		logger.debug params
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
		if recipient!=current_user
			conversation = Conversation.new

			if !recipient.nil?
				message = conversation.messages.build(params[:message])
				message.sender = current_user
				message.recipient = recipient
				message.read = false
				if message.valid?
					if conversation.save! && message.save!
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