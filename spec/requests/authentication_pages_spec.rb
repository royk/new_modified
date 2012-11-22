require 'spec_helper'

describe "AuthenticationPages" do
	before(:all)  { User.delete_all }
	
	subject { page }

	describe "sign in" do
    	before { visit signin_path }
	    describe "with no info" do
	    	before {click_button "Sign in"}
	    	it { should have_selector('div.alert.alert-error', :text => 'Invalid') }
		end
		describe "with valid info" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",    with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
	      	end
	      	it { should_not have_selector('div.alert.alert-error', :text => 'Invalid') }
	      	it { should have_selector('title', text: user.shown_name) }
	    end
	end
end
