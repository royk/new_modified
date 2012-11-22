require 'spec_helper'

describe UsersController do 
	let(:user) { FactoryGirl.create(:user) }

	before { sign_in user }

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

	describe "update" do
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

	describe "create" do
		it "should create a user" do
			expect do
				post :create, challenge: "freestyle", user: {name: "fifi", email: "fifi@wix.com", gravatar_suffix: "fufu", password: "123456", password_confirmation: "123456"}
				@to_delete = assigns(:user)
			end.to change(User, :count).by(1)
		end
	end
end
