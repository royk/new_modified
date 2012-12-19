require 'spec_helper'

describe ArticlesController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:article) { FactoryGirl.create(:article, user: user) }

	before do
		request.env["HTTP_REFERER"] = "where_i_came_from"
	end

	describe "show->" do
		it "should return an article" do
			get :show, id: article
			assigns(:article).should_not be_nil
		end
	end

	describe "edit->" do
		context "when signed out" do
			it "should not be allowed" do
				get :edit, id: article
				response.should_not render_template :edit
			end
		end
		context "when signed in" do
			 pending("Article editing")
=begin					
			describe "as the owner" do

				it "should be allowed" do
					get :edit, id: article
					response.should render_template :edit
				end
			end
=end		
		end
	end

	describe "create->" do
		context "when signed out" do
			it "should not be allowed" do
				post :create, id: article
				response.should redirect_to signin_path
			end
		end
		context "when signed in" do
			before do
				sign_in user
			end
			context "as a normal user" do
				it "should not be allowed" do
					post :create, id: article
					response.should redirect_to root_url
				end
			end
		end
	end

	describe "destroy->" do
		before do
			article.save!
			article.generate_permalink!
		end
		context "when signed out" do
			it "should not be allowed" do
				expect do
					delete :destroy, id: article
				end.to_not change(Article, :count).by(-1)
				response.should redirect_to signin_path
			end
		end

		context "when signed in" do
			before do
				sign_in user
			end
			context "as a normal user" do
				before do
					sign_out
					@user2 = User.new
					@user2.name = "loko boko"
					@user2.email = "lala@fofo.com"
					@user2.admin = false
					@user2.password = "lalalalal"
					@user2.password_confirmation = "lalalalal"
					@user2.save!
					sign_in @user2
				end
				it "should not be allowed" do
					expect do
						delete :destroy, id: article
					end.to_not change(Article, :count).by(-1)
					response.should redirect_to root_url
				end
			end
			context "as the article writer" do
				it "should be allowed" do
					expect do
						delete :destroy, id: article
					end.to change(Article, :count).by(-1)
				end
			end
		end
	end

	describe "index->" do
		it "should return a list of articles" do
			get :index
			assigns(:articles).should_not be_nil
		end
		it "should render the the appropriate view" do
			get :index
			response.should render_template :index
		end
		context "when signed in" do
			before do
				sign_in user
			end
			context "when admin" do
				before do
					sign_out
					user.admin = true
					user.save!
					sign_in user
				end
				context "published and public" do
					before do
						article.public = true
						article.published = true
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "public but not published" do
					before do
						article.public = true
						article.published = false
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "private and published" do
					before do
						article.public = false
						article.published = true
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "private and unpublished" do
					before do
						article.public = false
						article.published = false
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
			end
			context "when author" do
				before do
					sign_out
					user.author = true
					user.save!
					sign_in user
				end
				context "published and public" do
					before do
						article.public = true
						article.published = true
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "public but not published" do
					before do
						article.public = true
						article.published = false
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "private and published" do
					before do
						article.public = false
						article.published = true
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "private and unpublished" do
					before do
						article.public = false
						article.published = false
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
			end
			context "when normal user" do
				context "published and public" do
					before do
						article.public = true
						article.published = true
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "public but not published" do
					before do
						article.public = true
						article.published = false
						article.save!
					end
					it "should be not be shown" do
						get :index
						assigns(:articles).should be_empty
					end
				end
				context "private and published" do
					before do
						article.public = false
						article.published = true
						article.save!
					end
					it "should be shown" do
						get :index
						assigns(:articles).count.should eq 1
					end
				end
				context "private and unpublished" do
					before do
						article.public = false
						article.published = false
						article.save!
					end
					it "should be not be shown" do
						get :index
						assigns(:articles).should be_empty
					end
				end
			end
		end
		context "when signed out" do
			context "published and public" do
				before do
					article.public = true
					article.published = true
					article.save!
				end
				it "should be shown" do
					get :index
					assigns(:articles).count.should eq 1
				end
			end
			context "public but not published" do
				before do
					article.public = true
					article.published = false
					article.save!
				end
				it "should be not be shown" do
					get :index
					assigns(:articles).should be_empty
				end
			end
			context "private and published" do
				before do
					article.public = false
					article.published = true
					article.save!
				end
				it "should be not be shown" do
					get :index
					assigns(:articles).should be_empty
				end
			end
			context "private and unpublished" do
				before do
					article.public = false
					article.published = false
					article.save!
				end
				it "should be not be shown" do
					get :index
					assigns(:articles).should be_empty
				end
			end
		end
	end
end
