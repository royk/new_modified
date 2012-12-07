require 'spec_helper'

describe UsersController do 
	let(:user) { FactoryGirl.create(:user) }

	

	describe "show"  do
		it "should assign the correct user" do
			get :show, id: user
			assigns(:user).should eq(user)
		end
		it "should populate posts" do
			get :show, id: user
			assigns(:posts).should_not be_nil
		end
		it "should render the show view" do
			get :show, id: user
			response.should render_template :show
		end
	end

	describe "new" do
		it "should assign a new user" do
			get :new
			assigns(:user).should_not be_nil
		end
		it "should render the new view" do
			get :new
			response.should render_template :new
		end
	end

	describe "index" do
		it "should return a list of users" do
			get :index
			assigns(:users).should eq([user])
		end
		it "should render the index view" do
			get :index
			response.should render_template :index
		end
	end

	context "create->" do
		context "successfully" do
			it "should create a user" do
				expect do
					post :create, challenge: "freestyle", user: {name: "fifi", email: "fifi@wix.com", gravatar_suffix: "fufu", password: "123456", password_confirmation: "123456"}
					@to_delete = assigns(:user)
				end.to change(User, :count).by(1)
			end

			it "should create new user notification" do
				expect do
					post :create, challenge: "freestyle", user: {name: "fifi", email: "fifi@wix.com", gravatar_suffix: "fufu", password: "123456", password_confirmation: "123456"}
					@to_delete = assigns(:user)
				end.to change(Notification, :count).by(1)
			end
		end

		describe "when sending wrong challenge answer" do
			it "should not create a user" do
				expect do
					post :create, challenge: "shux", user: {name: "fifi", email: "fifi@wix.com", gravatar_suffix: "fufu", password: "123456", password_confirmation: "123456"}
					@to_delete = assigns(:user)
				end.to_not change(User, :count).by(1)
				response.should render_template :new
			end
		end

		describe "with an already registered email" do
			before do
				user.email = "fifi@wix.com"
				user.save!
			end
			it "should not create a user" do
				expect do
					post :create, challenge: "freestyle", user: {name: "fifi", email: "fifi@wix.com", gravatar_suffix: "fufu", password: "123456", password_confirmation: "123456"}
					@to_delete = assigns(:user)
				end.to_not change(User, :count).by(1)
				response.should render_template :new
			end

		end

		describe "with mismatched password confirmation" do
			it "should not create a user" do
				expect do
					post :create, challenge: "freestyle", user: {name: "fifi", email: "fifi@wix.com", gravatar_suffix: "fufu", password: "123456", password_confirmation: "12345"}
					@to_delete = assigns(:user)
				end.to_not change(User, :count).by(1)
				response.should render_template :new
			end

		end

	end

	

	describe "update" do
		before { sign_in user }
		before :each do
			
			@userWithPWD = {password: "123456", password_confirmation: "123456"}
			@userWithInvalidPWD1 = {password: "123456", password_confirmation: "23456"}
			@userWithInvalidPWD2 = {password: "1234", password_confirmation: "1234"}
		end
		it "should locate the correct user" do
			put :update, id: user, user: @userWithPWD
			assigns(:user).should eq(user)
		end

		it "should update with correct password" do
			@userWithPWD["name"] = "RoyK"
			@userWithPWD["email"] = "Roy@la.com"
			@userWithPWD["gravatar_suffix"] = "suff"
			put :update, id: user, user: @userWithPWD
			user.reload

			user.name.should eq("RoyK")
			user.email.should eq("roy@la.com")
			user.gravatar_suffix.should eq("suff")
		end

		it "should allow blog title update" do
			@userWithPWD[:blog_title] = "my old blog"
			user.build_blog(title: "My new blog")
			user.blog.save!
			put :update, id: user, user: @userWithPWD
			user.reload

			user.blog_title.should eq("my old blog")
		end

		it "should update without password" do
			someUser = {name: "fifi", email: "fifi@wix.com", gravatar_suffix: "fufu"}
			put :update, id: user, user: someUser
			user.reload

			user.name.should eq("fifi")
			user.email.should eq("fifi@wix.com")
			user.gravatar_suffix.should eq("fufu")
		end

		it "should reject update with mismatched pwd confirmation" do
			@userWithInvalidPWD1["name"] = "Roy"
			@userWithInvalidPWD1["email"] = "Roy@la.com"
			@userWithInvalidPWD1["gravatar_suffix"] = "suff"
			put :update, id: user, user: @userWithInvalidPWD1
			user.reload

			user.name.should_not eq("Roy")
			user.email.should_not eq("roy@la.com")
			user.gravatar_suffix.should_not eq("suff")
		end

		it "should reject update with mismatched pwd confirmation 2" do
			@userWithInvalidPWD2["name"] = "Roy"
			@userWithInvalidPWD2["email"] = "Roy@la.com"
			@userWithInvalidPWD2["gravatar_suffix"] = "suff"
			put :update, id: user, user: @userWithInvalidPWD2
			user.reload

			user.name.should_not eq("Roy")
			user.email.should_not eq("roy@la.com")
			user.gravatar_suffix.should_not eq("suff")
		end

		it "should redirec to user on success" do
			put :update, id: user, user: @userWithPWD

			response.should redirect_to user
		end

		it "should render edit view on failure" do
			put :update, id: user, user: @userWithInvalidPWD1

			response.should render_template :edit
		end
	end

	describe "update when logged out" do
		before do 
			sign_out
			@userWithPWD = {password: "123456", password_confirmation: "123456"}
		end

		it "should not respond" do
			put :update, id: user, user: @userWithPWD
			assigns(:user).should be_nil
		end

	end
end
