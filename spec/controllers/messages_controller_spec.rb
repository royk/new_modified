require 'spec_helper'

describe MessagesController do 
	let(:user) { FactoryGirl.create(:user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	describe "show->" do
		context "with an existing message" do
			before do
				@message = Message.new
				@message.content = "message body"
				@message.read = false
				@message.save!
			end
			context "when signed out" do
				it "shouldn't show" do
					get :show, id: @message
					response.should_not render_template :show
				end
			end
			context "when signed in" do
				before { sign_in user }
				context "and neither sender or recipient" do
					it "shouldn't show" do
						get :show, id: @message
						response.should_not render_template :show
					end
					context "but is an admin" do
						before { make_signed_in_admin user}
						it "should show" do
							get :show, id: @message
							response.should render_template :show
						end
						it "should remain unread" do
							get :show, id: @message
							@message.reload
							@message.read.should be_false
						end
					end
				end
				context "and is sender" do
					before do
						@message.sender = user
						@message.save!
					end
					it "should show" do
						get :show, id: @message
						response.should render_template :show
					end
					it "should remain unread" do
						get :show, id: @message
						@message.reload
						@message.read.should be_false
					end
				end
				context "and is recipient" do
					before do
						@message.recipient = user
						@message.save!
					end
					it "should show" do
						get :show, id: @message
						response.should render_template :show
					end
					it "should mark as read" do
						get :show, id: @message
						@message.reload
						@message.read.should be_true
					end
				end
			end
		end
	end

	describe "create->" do
		context "when signed in" do
			before do
				sign_in user
			end
			context "with a recipient" do
				before do
					@recipient = User.new
					@recipient.name = "loko boko"
					@recipient.email = "lala@fofo.com"
					@recipient.admin = false
					@recipient.password = "lalalalal"
					@recipient.password_confirmation = "lalalalal"
					@recipient.save!
				end
				context "and with a valid message" do
					context "without a prior conversation" do
						it "should create a message" do
							expect do
								post :create, recipient: @recipient.name, message: {content: "yayo"}
							end.to change(Message, :count).by(1)
						end
						it "should create a conversation" do
							expect do
								post :create, recipient: @recipient.name, message: {content: "yayo"}
							end.to change(Conversation, :count).by(1)
						end
					end
				end
				context "and with an invalid message" do
					it "shouldn't create a message" do
						expect do
								post :create, recipient: @recipient.name, message: {content: ""}
						end.to_not change(Message, :count)
					end
				end
			end
			context "with a recipient that is the sender" do
				it "shouldn't create a message" do
					expect do
						post :create, recipient: user.name, message: {content: "yaya"}
					end.to_not change(Message, :count)
				end
			end
		end
	end
end