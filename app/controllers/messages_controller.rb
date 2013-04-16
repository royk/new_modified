class MessagesController < AuthenticatedController
	before_filter	:correct_user,	only: [:show]
	
	def index
		@messages = (current_user.received_messages + current_user.sent_messages).sort_by {|f| -f.created_at.to_i}.paginate(page: params[:page])
	end

	def new
		@message = Message.new
		@recipient = User.find(params[:recipient])
		@replies_to = Message.find(params[:replies_to]) unless params[:replies_to].nil?
	end

	def show
		@message = Message.find(params[:id])
		if current_user==@message.recipient
			@message.update_attribute(:read, true)
			@message.save
		end
	end

	def get_latest
		render partial: 'shared/messages/header_indicator'
	end

	# mark the latest 10 unread messages as read
	def mark_as_read
		unread_messages = current_user.received_messages.where(read: false).order('id desc').limit(10)
		unread_messages.each do |m|
			m.update_attribute(:read, true)
			m.save
		end
		redirect_to request.referer
	end		


	def create
		recipient = User.find(params[:recipient_id])
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
		redirect_to messages_path
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