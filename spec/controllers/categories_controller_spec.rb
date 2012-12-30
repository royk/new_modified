require 'spec_helper'

describe CategoriesController do
	let(:user) { FactoryGirl.create(:user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	describe "create->" do
		before {@name = "yay"}
		context "when signed out" do
			it "should not be allowed" do
				expect do
					post :create, category: {name: @name}
				end.to_not change(Category, :count).by 1
				response.should redirect_to signin_path
			end
		end

		context "when signed in" do
			before { sign_in user }
			context "as non-admin" do
				it "should not be allowed" do
					user.admin.should_not eq true #sanity
					expect do
						post :create, category: {name: @name}
					end.to_not change(Category, :count).by 1
				end
			end
			context "as admin" do
				before { make_signed_in_admin user}
				it "should be allowed" do
					user.admin.should eq true #sanity
					expect do
						post :create, category: {name: @name}
					end.to change(Category, :count).by 1
				end
			end
		end
	end
end