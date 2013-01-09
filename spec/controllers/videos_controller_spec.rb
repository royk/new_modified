require 'spec_helper'

describe VideosController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user) }
	let(:video) { FactoryGirl.create(:video, user: user) }

	before do
		sign_in user
	    request.env["HTTP_REFERER"] = "where_i_came_from"
  	end

	context "show->" do
		it "should assign the correct video" do
			get :show, id: video
			assigns(:video).should eq(video)
		end
		it "should render the show view" do
			get :show, id: video
			response.should render_template :show
		end
		describe "when video is private" do
			before do
				video.public = false
				video.save!
			end
			describe "and user is signed out" do
				before { sign_out }
				it "should not return for signed out user" do
					get :show, id: video
					assigns(:video).should be_nil
					response.should_not render_template :show
				end
			end

			describe "and user is logged in" do
				it "should return a usual" do
					get :show, id: video
					assigns(:video).should eq(video)
					response.should render_template :show
				end
			end
		end
	end


	describe "index" do
		before do
			video.save!
		end
		it "should return a list of videos" do
			
			get :index
			assigns(:videos).should eq([video])
		end
		it "should render the video list view" do
			get :index
			response.should render_template :index
		end
		context "in ATOM format" do
			before do
				get :index, format: "atom"
			end
			it "should return a list of videos" do
				assigns(:videos).should eq([video])
			end
		end
		context "when requested via AJAX" do
			before do
				xhr :get, :index
			end
			it "should return a list of videos" do
				assigns(:videos).should eq([video])
			end
			it "should not render the entire template" do
				response.should_not render_template :index
			end
		end

	end

	describe "Create" do
		context "with long youtube url" do
			it "should create a new youtube video" do
				uid = "CoyEILQHJyc"
				url = "http://www.youtube.com/watch?feature=player_embedded&v=#{uid}"
				expect do
					post :create, video: {url: url}
				end.to change(Video, :count).by(1)
				assigns[:video][:url].should eq(url)
				assigns[:video][:uid].should eq(uid)
				assigns[:video][:vendor].should eq("youtube")
			end
		end
		context "with shortened youtube url" do
			it "should create a new youtube video" do
				uid = "CoyEILQHJyc"
				expect do
					post :create, video: {url: "http://www.youtu.be/#{uid}"}
				end.to change(Video, :count).by(1)

				assigns[:video][:uid].should eq(uid)
				assigns[:video][:vendor].should eq("youtube")
			end
		end
		context "with vimeo url" do
			it "should create a new vimeo video" do
				uid = "53369314"
				expect do
					post :create, video: {url: "http://vimeo.com/#{uid}"}
				end.to change(Video, :count).by(1)

				assigns[:video][:uid].should eq(uid)
				assigns[:video][:vendor].should eq("vimeo")
				
			end
		end
		context "with footbag.org url" do
			it "should create a new footbagorg video" do
				uid = "1938/Utterfailure.MOV"
				VCR.use_cassette 'controller/video_scrape' do
					expect do
						post :create, video: {url:"http://www.footbag.org/gallery/show/18168"}
					end.to change(Video, :count).by(1)
				assigns[:video][:uid].should eq(uid)
				assigns[:video][:vendor].should eq("footbagorg")
				end
			end
		end
		context "with a non-video url" do
			it "should not create a new video" do
				expect do
					post :create, video: { url: "https://www.google.com/search?q=rspec+running+specific&oq=rspec+running+specific&aqs=chrome.0.57j60.6091&sugexp=chrome,mod=3&sourceid=chrome&ie=UTF-8#hl=en&tbo=d&biw=1163&bih=817&sclient=psy-ab&q=rspec+create+get+created+&oq=rspec+create+get+created+&gs_l=serp.3...3500.4636.7.4981.12.11.0.0.0.0.221.1825.0j10j1.11.0.les%3B..0.0...1c.1.RkNzV62l5c4&pbx=1&bav=on.2,or.r_gc.r_pw.r_cp.r_qf.&fp=6be1df0b8d8277dc&bpcl=38626820" }
				end.not_to change(Video, :count)
			end
		end

	end

	describe "Update->" do
		before do
			@to_edit = Video.create
			@to_edit.url = "http://vimeo.com/53369314"
			@to_edit.uid = "53369314"
			@to_edit.vendor = "vimeo"
		end
		context "with admin" do
			pending "check that timestamps aren't affected by admin change"
		end
		context "with wrong user" do
			before do
				@to_edit.user = user2
				@to_edit.save!
			end
			it "should not change the video's url" do
				put :update, id: @to_edit, video: {url: "http://www.youtu.be/CoyEILQHJyc"}

				assigns[:video].should be_nil
				@to_edit.reload
				@to_edit.url.should_not eq("http://www.youtu.be/CoyEILQHJyc")
			end
		end

		context "with new url" do
			before do
				@to_edit.user = user
				@to_edit.save!
			end
			it "should change the video's url" do
				put :update, id: @to_edit, video: {url: "http://www.youtu.be/CoyEILQHJyc"}

				assigns[:video].should eq(@to_edit)
				assigns[:video][:uid].should eq("CoyEILQHJyc")
				@to_edit.reload
				@to_edit.url.should eq("http://www.youtu.be/CoyEILQHJyc")
			end
		end

		context "with already existing uid" do
			before do
				@other = Video.create
				@other.url = "http://www.youtu.be/CoyEILQHJyc"
				@other.uid = "CoyEILQHJyc"
				@other.vendor = "vimeo"
				@other.user = user
				@other.save!

				@to_edit.user = user
				@to_edit.save!
			end
			it "should not change the video's url" do
				put :update, id: @to_edit, video: {url: "http://www.youtu.be/CoyEILQHJyc"}

				response.should_not redirect_to @to_edit
				@to_edit.reload
				@to_edit.url.should_not eq("http://www.youtu.be/CoyEILQHJyc")

			end
		end
		context "public status" do
			before do
				@to_edit.public = false
				@to_edit.user = user
				@to_edit.save!
			end
			it "should change pubic attribute" do
				put :update, id: @to_edit, video: {public: true}
				@to_edit.reload
				@to_edit.public.should be_true
			end
		end
		context "title" do
			before do
				@new_title = "New Title!"
				@old_title = "old title"
				video.title = @old_title
				video.save!
			end
			it "should change the title" do
				put :update, id: video, video: {url: video.url, title: @new_title} 
				video.reload
				video.title.should eq @new_title
			end
			it "should be found in search using the new title" do
				put :update, id: video, video: {url: video.url, title: @new_title} 
				video.reload
				Video.tagged_with(@new_title.split[0]).should include video
			end
			it "should not be found in search using the old title" do
				put :update, id: video, video: {url: video.url, title: @new_title} 
				video.reload
				Video.tagged_with(@old_title.split[0]).should_not include video
			end
			it "should not delete user tags" do
				put :update, id: video, video: {url: video.url}, Player_0: "some Guy"
				video.reload
				Video.tagged_with("some").should include video
				put :update, id: video, video: {url: video.url, title: @new_title}, Player_0: "some Guy"
				video.reload
				Video.tagged_with("some").should include video
			end

		end
		context "players:" do
			context "adding" do
				context "a named player" do
					it "should add the player to the players list" do
						put :update, id: video, video: {url: video.url}, Player_0: "Some Guy"
						video.reload
						video.players_names.count.should eq 1
						video.players.count.should eq 1
					end
					it "searching the video according to the player name should return results" do
						put :update, id: video, video: {url: video.url}, Player_0: "Some Guy"
						video.reload
						Video.tagged_with("Some").should include video
						Video.tagged_with("Guy").should include video
						Video.tagged_with("some guy".split).should include video
					end
				end
				context "a user player" do
					it "should add the player to the players list" do
						put :update, id: video, video: {url: video.url}, Player_0: user.name
						video.reload
						video.players_names.count.should eq 1
						video.user_players.count.should eq 1
					end
					it "searching the video according to the player name should return results" do
						put :update, id: video, video: {url: video.url}, Player_0: user.name
						video.reload
						Video.tagged_with(user.name.split).should include video
					end
				end
			end
			context "removing" do
				context "a named player" do
					before do
						video.add_player("Some guy")
						video.save!
					end
					it "should remove the player" do
						video.players_names.count.should eq 1 # precondition for the test
						put :update, id: video, video: {url: video.url}, Player_0: ""
						video.reload
						video.players_names.should be_empty
						video.players.should be_empty
					end
					it "Should remove the related tags" do
						Video.tagged_with("Some").should include video # sanity
						put :update, id: video, video: {url: video.url}, Player_0: ""
						video.reload
						Video.tagged_with("Some").should_not include video
						Video.tagged_with("Guy").should_not include video
					end
				end
				context "a user player" do
					before do
						video.add_player(user.name)
						video.save!
					end
					it "should remove the player" do
						video.players_names.count.should eq 1 # precondition for the test
						put :update, id: video, video: {url: video.url}, Player_0: ""
						video.reload
						video.players_names.should be_empty
						video.user_players.should be_empty
					end
					it "Should remove the related tags" do
						Video.tagged_with(user.name.split).should include video # sanity
						put :update, id: video, video: {url: video.url}, Player_0: ""
						video.reload
						Video.tagged_with(user.name.split).should_not include video
					end
				end
			end
		end

	end

	describe "Destroy" do
		before :each do
			post :create, video: { url: "http://vimeo.com/53369314" }
		end
		it "should delete video" do
			vid_id = assigns[:video][:id]
			expect do
				delete :destroy, id: vid_id
			end.to change(Video, :count).by(-1)
			lambda { Video.find(vid_id) }.should raise_error(ActiveRecord::RecordNotFound)
		end
	end


	

end