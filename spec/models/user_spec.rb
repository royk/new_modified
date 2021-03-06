# == Schema Information
#
# Table name: users
#
#  id               :integer          not null, primary key
#  name             :string(255)
#  email            :string(255)
#  remember_token   :string(255)
#  password_digest  :string(255)
#  admin            :boolean
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  gravatar_suffix  :string(255)
#  nickname         :string(255)
#  reset_code       :string(255)
#  country          :string(255)
#  city             :string(255)
#  modified_user    :string(255)
#  author           :boolean          default(FALSE)
#  birthday         :datetime
#  started_playing  :datetime
#  bap              :boolean          default(FALSE)
#  bap_name         :string(255)
#  bap_induction    :datetime
#  motto            :string(255)
#  hobbies          :text
#  privacy_settings :integer          default(0)
#  latitude         :float
#  longitude        :float
#  last_visit       :datetime
#  about_title      :string(255)
#  about_content    :text
#  registered       :boolean          default(TRUE)
#  website          :string(255)
#  last_online      :datetime
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
	it { should respond_to(:gravatar_suffix) }
	it { should respond_to(:gravatar_email) }
	it { should respond_to(:notifications) }
	it { should respond_to(:blog) }
	it { should respond_to(:blog_title) }
	it { should respond_to(:nickname) }
	it { should respond_to(:shown_name) }
	it { should respond_to(:country) }
	it { should respond_to(:city) }
	it { should respond_to(:create_reset_code) }
	it { should respond_to(:modified_user) }
	it { should respond_to(:age) }
	it { should respond_to(:years_playing) }
	it { should respond_to(:location) }

	it {should be_valid}
	it {should_not be_admin}

	describe "unread notifications" do
		before do
			@user2 = User.new
			@user2.name = "loko boko"
			@user2.email = "lala@fofo.com"
			@user2.admin = false
			@user2.password = "lalalalal"
			@user2.password_confirmation = "lalalalal"
			@user2.save!
			@like_item = FactoryGirl.create(:like)
			@post_item = FactoryGirl.create(:post)
			@comment_item = FactoryGirl.create(:comment)
		end
		context "When there are no notifications of any kind" do
			before { @notifications = @user.unread_notifications}
			it "should not have likes and texts notification" do
				@notifications["likes"].any?.should be_false
				@notifications["texts"].any?.should be_false
			end
		end
		context "When there is a like notification" do
			before do
				notif = @user.notifications.build(sender: @user2, item: @like_item, action: @post_item)
				notif.user = @user
				notif.public = false
				notif.read = false
				notif.save!
				@notifications = @user.unread_notifications
			end
			it "should have likes notification" do
				@notifications["likes"].any?.should be_true
				@notifications["texts"].any?.should be_false
			end
		end
		context "When there is a text notification" do
			before do
				notif = @user.notifications.build(sender: @user2, item: @comment_item, action: @post_item)
				notif.user = @user
				notif.public = false
				notif.read = false
				notif.save!
				@notifications = @user.unread_notifications
			end
			it "should have text notification" do
				@notifications["likes"].any?.should be_false
				@notifications["texts"].any?.should be_true
			end
		end

	end

	describe "age:" do
		context "when birthday isn't set," do
			its(:age) { should eq 0 }
		end
		context "when birthday is set," do
			before { @user.birthday = "24/02/1982" }
			its(:age) { should_not eq 0 }
		end
	end
 	
 	describe "years_playing:" do
 		context "when started_playing isn't set," do
 			its(:years_playing) { should eq 0 }
 		end
 		context "when started_playing is set," do
 			before { @user.started_playing = "24/02/1892" }
 			its(:years_playing) { should_not eq 0 }
 		end
 	end

 	describe "location:" do
 		context "when city & country are empty," do
 			its(:location) { should be_empty }
 		end
 		context "when city is set," do
 			before { @user.city = "Tel Aviv" }
 			its(:location) { should eq @user.city}
 		end
 		context "when country is set," do
 			before { @user.country = "Israel" }
 			its(:location) { should eq @user.country }
 			context "and city is set," do
	 			before { @user.city = "Tel Aviv" }
	 			its(:location) { should include @user.city }
	 			its(:location) { should include @user.country }
	 		end

 		end
 	end


	describe "Shown name" do
		describe "when user doesn't have nickname" do
			its(:shown_name) { should eq(@user.name) }
		end
		describe "when user has empty string nickname" do
			before { @user.nickname = "" }
			its(:shown_name) { should eq(@user.name) }
		end
		describe "when user has a nickname" do
			before { @user.nickname = "nickname" }
			its(:shown_name) { should eq(@user.nickname) }
		end
	end

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

	context "invalidates" do
		describe "when name is not present" do
			before {@user.name = " "}
			it {should_not be_valid}
		end

		describe "when name is too long" do
			before {@user.name = "a" * 51}
			it {should_not be_valid}
		end

		describe "when name is too short" do
			before {@user.name = "aaa"}
			it {should_not be_valid}
		end

		describe "when nick is set and is too short" do
			before {@user.nickname = "aa"}
			it {should_not be_valid}
		end

		describe "when nick is set and is too long" do
			before {@user.nickname = "a" * 51}
			it {should_not be_valid}
		end

		describe "when mail is not present" do
			before {@user.email = " "}
			it {should_not be_valid}
		end

		describe "when password isn't present" do
			before {@user.password = " " }
			it {should_not be_valid}
		end

		describe "when confirmation isn't present" do
			before {@user.password_confirmation = " " }
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

		describe "with a password that's too short" do
		  before { @user.password = @user.password_confirmation = "a" * 5 }
		  it { should be_invalid }
		end

		context "email" do
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
		end
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
			FactoryGirl.create(:video, uid: "lala", vendor:"fofo", user: @user, created_at: 1.day.ago)
		end
		let!(:newer_video) do
			FactoryGirl.create(:video, uid: "fufu", vendor: "fofo", user: @user, created_at: 1.hour.ago)
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

	context "Gravatar" do
		context "when gravatar suffix" do
			describe "is empty" do
				its(:gravatar_email) { should==@user.email }
			end
			describe "is set" do
				before do 
					@user.email = "test@email.com"
					@user.gravatar_suffix = "suffix"
				end
				its(:gravatar_email) { should== "test+suffix@email.com"}
			end
		end
	end

	context "Blog" do
		context "when doesn't have one" do
			describe "blog title is nil" do
				its(:blog_title) { should be_nil }
			end
			describe "writing to blog title shouldn't fail" do
				before do
					@user.blog_title = "something"
				end
			end
		end
		context "when has one" do
			before :each do
				@user.build_blog(title: "something")
			end
			describe "its title should be what we set via constructor" do
				its(:blog_title) { should eq("something") }
			end
			describe "writing to blog title should change title" do
				before do
					@user.blog_title = "something else"
				end
				its(:blog_title) { should eq("something else") }
			end
		end
	end

	context "reset code" do
		it "should create a reset code" do
			code = @user.create_reset_code
			@user.reset_code.should_not be_nil
			@user.reset_code.should eq code
		end
	end

end
