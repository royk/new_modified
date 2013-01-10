require 'spec_helper'

describe EventsController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:event_item) { FactoryGirl.create(:event) }
	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end
	subject { event_item }
	describe "update->" do
		context "attributes" do
			before do
					@new_name = "new name"
			end
			context "when signed in" do
				before do
					sign_in user
				end
				it "should update the name" do
					post :update, id:event_item.id, event: {name:@new_name}
					event_item.reload
					event_item.name.should eq @new_name
				end
			end
			context "when not signed in" do
				it "should not update the name" do
					post :update, id:event_item.id, event: {name:@new_name}
					event_item.reload
					event_item.name.should_not eq @new_name
				end
			end
		end
		context "attendant" do
			before do
				sign_in user
			end
			context "when the user isn't listed as attending" do
				it "should add the user as attending" do
					expect do
						post :update, id:event_item.id, attendant: user.id
					end.to change(Attendant, :count).by 1
					event_item.attendants.first.user_id.should eq user.id
				end
			end
			context "when the user is already listed as attending" do
				before do
					event_item.attendants.build(user_id: user.id)
					event_item.save!
				end
				it "should remove the user from attendance" do
					expect do
						post :update, id:event_item.id, attendant: user.id
					end.to change(Attendant, :count).by -1
				end
			end
		end
		context "competitions" do
			before do
				sign_in user
			end
			context "sending a competition name" do
				before do
					@comp1 = Competition.new(name: "comp 1")
				end
				context "when there are no competitions" do
					it "should add a competition" do
						expect do
							post :update, id:event_item.id, Competition_0:@comp1.name
						end.to change(Competition, :count).by 1
						event_item.competitions.first.name.should eq @comp1.name
					end
				end
				context "when there is a competition" do
					before do
						event_item.competitions.build(name: "some comp", order_index: 0)
						event_item.save!
					end
					it "should rename the competition" do
						expect do
							post :update, id:event_item.id, Competition_0:@comp1.name
						end.to_not change(Competition, :count)
						event_item.competitions.first.name.should eq @comp1.name
					end
				end
			end
			context "not sending an empty competition name" do
				context "when there are no competitions" do
					it "should do nothing" do
						expect do
							post :update, id:event_item.id, Competition_0:""
						end.to_not change(Competition, :count)
					end
				end
				context "when there is a competition" do
					before do
						event_item.competitions.build(name: "some comp", order_index: 0)
						event_item.save!
					end
					it "should dissociate it" do
						expect do
							post :update, id:event_item.id, Competition_0: ""
						end.to_not change(Competition, :count) #Note that it should NOT change the count - it's a dissociation, not a delete.
						event_item.competitions.should be_empty
					end
				end
			end

		end
	end


end