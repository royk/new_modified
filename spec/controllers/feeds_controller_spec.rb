require 'spec_helper'

describe FeedsController do 
	let(:feed) { FactoryGirl.create(:feed) }

	before do
	    request.env["HTTP_REFERER"] = "where_i_came_from"
  	end

  	context "show->" do
  		context "when in atom format" do
  			context "and there are no posts in the feed" do
  				it "should return the proper variables" do
  					get :show, format: "atom", permalink: feed.permalink
  					assigns(:feed).should_not be_nil
  					assigns(:feed_items).should_not be_nil
  				end
  			end
  		end
	end
end
