require 'spec_helper'

describe VideosController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:user2) { FactoryGirl.create(:user) }
	let(:video) { FactoryGirl.create(:video) }

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
		it "should return a list of videos" do
			video.save!
			get :index
			assigns(:videos).should eq([video])
		end
		it "should render the video list view" do
			get :index
			response.should render_template :index
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