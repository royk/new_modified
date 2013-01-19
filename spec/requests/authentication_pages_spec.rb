require 'spec_helper'

describe "AuthenticationPages" do
	before(:all)  { User.delete_all }
	
	subject { page }

	describe "sign in" do
    	before { visit signin_path }
	    context "with no info" do
	    	before {click_button "Sign in"}
	    	it { should have_selector('div.alert.alert-error', :text => 'Invalid') }
		end
		context "with valid info" do
			let(:user) { FactoryGirl.create(:user) }
			before do
				fill_in "Email",    with: user.email
				fill_in "Password", with: user.password
				click_button "Sign in"
	      	end
	      	it { should_not have_selector('div.alert.alert-error', :text => 'Invalid') }
	    end
	end

	describe "sign up" do
		before { visit signup_path }
		context "with no info" do
			before {click_button "Create my account"}
	    	it { should have_selector('div.alert.alert-error', :text => 'Wrong') }
	    end
	    context "with valid info" do
    		before do
	    		fill_in "Name", with: "Samus Aran"
	    		fill_in "Email", with: "samus@gmail.com"
	    		fill_in "Password", with: "my_valid_password"
	    		fill_in "Confirmation", with: "my_valid_password"
	    	end
	    	context "and wrong answer to challenge question" do
	    		before do
	    			fill_in "challenge", with: "Balloons"
	    			click_button "Create my account"
	    		end
	    		it { should have_selector('div.alert.alert-error', :text => 'Wrong') }	
	    	end
	    	context "and correct answer to challenge question" do
	    		before do
	    			fill_in "challenge", with: "freestyle"
	    			click_button "Create my account"
	    		end
	    		it { should_not have_selector('div.alert.alert-error', :text => 'Wrong') }	
	    	end
	    end
	    context "with mismatched password confirmation" do
	    	before do
	    		fill_in "Name", with: "Samus Aran"
	    		fill_in "Email", with: "samus@gmail.com"
	    		fill_in "Password", with: "my_valid_password"
	    		fill_in "Confirmation", with: "ertvetdgdf"
	    		fill_in "challenge", with: "freestyle"
	    		click_button "Create my account"
	    	end
	    	it { should have_selector('div.alert.alert-error', :text => 'Could not') }	
	    	it { should have_selector('li', text: "doesn't match") }
	    end
	end
end
