require 'spec_helper'

describe PagesController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:mypage) { FactoryGirl.create(:page) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
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