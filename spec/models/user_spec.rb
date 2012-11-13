# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  name            :string(255)
#  email           :string(255)
#  remember_token  :string(255)
#  admin           :boolean
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  password_digest :string(255)
#

require 'spec_helper'

describe User do
	before { @user = User.new(name: "Example User", email: "user@example.com",
		password: "foobar", password_confirmation: "foobar")}

	subject {@user}

	it { should respond_to(:name)}
	it { should respond_to{:email}}
	it { should respond_to(:password_digest)}
	it { should respond_to(:password_confirmation)}
	it { should respond_to(:authenticate) }
	it { should respond_to(:admin) }
	it { should respond_to(:posts) }
	it { should respond_to(:videos) }

	it {should be_valid}
	it {should_not be_admin}

	describe "with admin attribute set to 'true'" do
		before do
			@user.save!
			@user.toggle!(:admin)
		end
		it {should be_admin}
	end

	describe "remember token" do
		before {@user.save}
		its(:remember_token) {should_not be_blank}
	end

	describe "when name is not present" do
		before {@user.name = " "}
		it {should_not be_valid}
	end

	describe "when name is too long" do
		before {@user.name = "a" * 51}
		it {should_not be_valid}
	end

	describe "when mail is not present" do
		before {@user.email = " "}
		it {should_not be_valid}
	end

	describe "when password isn't present" do
		before {@user.password = @user.password_confirmation = " "}
		it {should_not be_valid}
	end

	describe "when password don't match" do
		before {@user.password_confirmation = "mismatch"}
		it {should_not be_valid}
	end

	describe "when password confirmation is nil" do
	  before { @user.password_confirmation = nil }
	  it { should_not be_valid }
	end

	describe "return value of authenticate method" do
		before {@user.save}
		let(:found_user) {User.find_by_email(@user.email)}

		describe "with valid password" do
			it {should == found_user.authenticate(@user.password)}
		end
		describe "with invalid password" do
			let(:user_for_invalid_password) { found_user.authenticate("invalid") }
			it {should_not == user_for_invalid_password}
			specify {user_for_invalid_password.should be_false}
		end
	end

	describe "with a password that's too short" do
	  before { @user.password = @user.password_confirmation = "a" * 5 }
	  it { should be_invalid }
	end

	describe "when email format is invalid" do
		it "should be invalid" do
			addresses = %w[foo@bar foo@bar,com something.org lala.is@invalid. also@this@is.com way@bad+thing.com]
			addresses.each do |addr|
				@user.email = addr;
				@user.should_not be_valid
			end
		end
	end

	describe "when email format is valid" do
		it "should be valid" do
			addresses = %w[user@foo.com a_us-er@f.o.org first.last@foo.jp a+b@baz.co.il]
			addresses.each do |addr|
				@user.email = addr;
				@user.should be_valid
			end
		end
	end

	describe "when email is already taken" do
		before do
			user_same_mail = @user.dup
			user_same_mail.email = @user.email.upcase
			user_same_mail.save
		end

		it {should_not be_valid}
	end

	describe "posts" do
		before { @user.save }
		let!(:older_post) do
			FactoryGirl.create(:post, user: @user, created_at: 1.day.ago)
		end
		let!(:newer_post) do
			FactoryGirl.create(:post, user: @user, created_at: 1.hour.ago)
		end
		it "should have the right order" do
			@user.posts.should == [newer_post, older_post]
		end
		it "should destroy associated posts" do
			posts = @user.posts.dup
			@user.destroy
			posts.should_not be_empty
			posts.each do |post|
				Post.find_by_id(post.id).should be_nil
			end
		end
	end

	describe "videos" do
		before { @user.save }
		let!(:older_video) do
			FactoryGirl.create(:video, url: "lala", user: @user, created_at: 1.day.ago)
		end
		let!(:newer_video) do
			FactoryGirl.create(:video, url: "fufu", user: @user, created_at: 1.hour.ago)
		end
		it "should have the right order" do
			@user.videos.should == [newer_video, older_video]
		end
		it "should not destroy associated videos" do
			videos = @user.videos.dup
			@user.destroy
			videos.should_not be_empty
			videos.each do |video|
				Video.find_by_id(video.id).should_not be_nil
			end
		end
	end
end
