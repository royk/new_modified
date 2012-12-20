require 'spec_helper'

describe PagesController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:mypage) { FactoryGirl.create(:page) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	describe "show->" do
		context "when page exists" do
			context "and user is signed out" do
				it "should show" do
					get :show, name: mypage.name
					response.should render_template :show
				end
			end
			context "and user is signed in" do
				before do
					sign_in user
				end
				it "should show" do
					get :show, name: mypage.name
					response.should render_template :show
				end
			end
		end
		context "when page doesn't exist" do
			before do
				@new_page_name = "new page"
			end
			context "and user is signed out" do
				it "shouldn't create a page" do
					expect do
						get :show, name: @new_page_name
					end.to_not change(Page, :count)
				end
				it "should redirect to unauthorized" do
					get :show, name: @new_page_name
					response.should redirect_to unauthorized_url
				end
			end
			context "and user is signed in" do
				it "shouldn't create a page" do
					expect do
						get :show, name: @new_page_name
					end.to_not change(Page, :count)
				end
				it "should redirect to unauthorized" do
					get :show, name: @new_page_name
					response.should redirect_to unauthorized_url
				end
				context "but is also an admin" do
					before do
						make_signed_in_admin(user)
					end
					it "should create a page" do
						expect do
							get :show, name: @new_page_name
						end.to change(Page, :count).by 1
					end
					it "should show" do
						get :show, name: mypage.name
						response.should render_template :show
					end
				end
			end
		end
	end

	describe "update->" do
		before do
			@new_content = "I am the new content"
		end
		context "when user is signed out" do
			it "should redirect to unauthorized" do
				post :update, name: mypage.name, content: @new_content
				response.should redirect_to unauthorized_url
			end
		end
		context "when user is signed in" do
			before do
				sign_in user
			end
			it "should redirect to unauthorized" do
				post :update, name: mypage.name, content: @new_content
				response.should redirect_to unauthorized_url
			end
			context "but is an admin" do
				before do
					make_signed_in_admin(user)
				end
				it "should change content" do
					post :update, name: mypage.name, content: @new_content
					mypage.reload
					mypage.content.should eq @new_content
				end
				it "should redirect to the page" do
					post :update, name: mypage.name, content: @new_content
					response.should redirect_to page_path(mypage.name)
				end

			end
		end
	end


	describe "edit->" do
		context "when logged out" do
			it "should not allow editing" do
				get :edit, name:mypage.name
				response.should_not render_template :edit
			end
		end
		context "when signed in" do
			context "with non-admin" do
				before do
					sign_in user
				end
				it "should not allow editing" do
					get :edit, name:mypage.name
					response.should_not render_template :edit
				end
			end
			context "with an admin" do
				before do
					@admin = User.new
					@admin.name = "loko boko"
					@admin.email = "lala@fofo.com"
					@admin.admin = true
					@admin.password = "lalalalal"
					@admin.password_confirmation = "lalalalal"
					@admin.save!
					sign_in @admin
				end
				it "should allow editing" do
					get :edit, name:mypage.name
					response.should render_template :edit
				end
			end
		end
	end
end