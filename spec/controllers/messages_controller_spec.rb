require 'spec_helper'

describe MessagesController do 
	let(:user) { FactoryGirl.create(:user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
		
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