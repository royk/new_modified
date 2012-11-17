require 'spec_helper'

describe VideosController do 
	let(:user) { FactoryGirl.create(:user) }
	let(:video) { FactoryGirl.create(:video) }

	before { sign_in user }

	describe "show" do
		it "should assign the correct video" do
			get :show, id: video
			assigns(:video).should eq(video)
		end
		it "should render the show view" do
			get :show, id: video
			response.should render_template :show
		end
	end


	describe "index" do
		it "should return a list of videos" do
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
				expect do
					post :create, video: {uid: "http://www.youtube.com/watch?feature=player_embedded&v=#{uid}"}
				end.to change(Video, :count).by(1)

				assigns[:video][:uid].should eq(uid)
				assigns[:video][:vendor].should eq("youtube")
			end
		end
		context "with shortened youtube url" do
			it "should create a new youtube video" do
				uid = "CoyEILQHJyc"
				expect do
					post :create, video: {uid: "http://www.youtu.be/#{uid}"}
				end.to change(Video, :count).by(1)

				assigns[:video][:uid].should eq(uid)
				assigns[:video][:vendor].should eq("youtube")
			end
		end
		context "with vimeo url" do
			it "should create a new vimeo video" do
				uid = "53369314"
				expect do
					post :create, video: {uid: "http://vimeo.com/#{uid}"}
				end.to change(Video, :count).by(1)

				assigns[:video][:uid].should eq(uid)
				assigns[:video][:vendor].should eq("vimeo")
				
			end
			it "should redirect to root" do
				post :create, video: { uid: "http://vimeo.com/53369314" }
				response.should redirect_to root_url
			end
		end
		context "with a non-video url" do
			it "should not create a new video" do
				expect do
					post :create, video: { uid: "https://www.google.com/search?q=rspec+running+specific&oq=rspec+running+specific&aqs=chrome.0.57j60.6091&sugexp=chrome,mod=3&sourceid=chrome&ie=UTF-8#hl=en&tbo=d&biw=1163&bih=817&sclient=psy-ab&q=rspec+create+get+created+&oq=rspec+create+get+created+&gs_l=serp.3...3500.4636.7.4981.12.11.0.0.0.0.221.1825.0j10j1.11.0.les%3B..0.0...1c.1.RkNzV62l5c4&pbx=1&bav=on.2,or.r_gc.r_pw.r_cp.r_qf.&fp=6be1df0b8d8277dc&bpcl=38626820" }
				end.not_to change(Video, :count)
			end
			it "should redirect to root" do
				post :create, video: { uid: "https://www.google.com/search?q=rspec+running+specific&oq=rspec+running+specific&aqs=chrome.0.57j60.6091&sugexp=chrome,mod=3&sourceid=chrome&ie=UTF-8#hl=en&tbo=d&biw=1163&bih=817&sclient=psy-ab&q=rspec+create+get+created+&oq=rspec+create+get+created+&gs_l=serp.3...3500.4636.7.4981.12.11.0.0.0.0.221.1825.0j10j1.11.0.les%3B..0.0...1c.1.RkNzV62l5c4&pbx=1&bav=on.2,or.r_gc.r_pw.r_cp.r_qf.&fp=6be1df0b8d8277dc&bpcl=38626820" }
				response.should redirect_to root_url
			end
		end
	end

	describe "Destroy" do
		before :each do
			post :create, video: { uid: "http://vimeo.com/53369314" }
		end
		it "should delete video" do
			expect do
				delete :destroy, id: assigns[:video][:id]
			end.to change(Video, :count).by(-1)
		end
	end


	

end