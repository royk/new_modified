require 'spec_helper'

describe "AuthenticationPages" do
	subject { page }

	describe "sign in" do
    	before { visit signin_path }
	    describe "with no info" do
	    	before {click_button "Sign in"}
	    	it { should have_selector('div.alert.alert-error', :text => 'Invalid') }
		end
		describe "with existing user" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",    with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
	      	end
	      	it { should have_selector('title', text: user.name) }
	    end
	end
end
