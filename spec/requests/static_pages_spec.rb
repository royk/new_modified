require 'spec_helper'
include ApplicationHelper

describe "Static pages" do
	let(:user) { FactoryGirl.create(:user) }
	subject {page}

	shared_examples_for "all static pages" do
		it { should have_xpath('//a[@href="/#" and @class="brand"]') }
		it { should have_selector('title', :text => full_title(page_title))}

		# Site menu
		it { should have_link(I18n.t(:home)), href: root_path }
		it { should have_link(I18n.t(:videos)), href: videos_path }
		it { should have_link(I18n.t(:blogs)), href: blogs_path }
		it { should have_link(I18n.t(:users)), href: users_path }
	end
	shared_examples_for "logged-out header" do
		# Site top Header logged out
		it { should have_link(I18n.t(:register), href: signup_path)}
		it { should have_link(I18n.t(:login), href: signin_path)}
	end

	shared_examples_for "signed-in header" do
		it { should have_xpath('//ul[@id="header-notifications"]') }
		it { should have_xpath('//ul[@id="header-messages"]') }
		it { should have_link(user.shown_name, href:'#') }
		it { should have_link(I18n.t(:profile), href: user_path(user)) }
		it { should have_link(I18n.t(:edit), href: edit_user_path(user)) }
		it { should have_link(I18n.t(:log_out), href: signout_path) }
	end

	shared_examples_for "activity bar" do
		it { should have_selector('p', text: I18n.t(:activity)) }
	end

	describe "Home page" do
		before {visit root_path}
		let(:page_title) {I18n.t(:home)}
		it_should_behave_like "all static pages"
		it_has_behavior "logged-out header"

		describe "signed in view" do
			before do
				sign_in user
				visit root_path
			end
			it_should_behave_like "all static pages"
			it_has_behavior "signed-in header"
			it_has_behavior "activity bar"

		end
	end

	describe "Sign in" do
		before {visit signin_path}
		let(:page_title) { I18n.t(:login) }
		it_should_behave_like "all static pages"
		it_has_behavior "logged-out header"

		it {should have_selector("input", :name =>"session[email]")}
		it {should have_selector("input", :name =>"session[password]")}
		it {should have_selector("input", :type =>"submit")}
	end

	describe "Sign up" do
		before {visit signup_path}
		let(:page_title) { I18n.t(:register) }
		it_should_behave_like "all static pages"
		it_has_behavior "logged-out header"

		it {should have_selector("input", :name =>"user[name]")}
		it {should have_selector("input", :name =>"user[email]")}
		it {should have_selector("input", :name =>"user[password]")}
		it {should have_selector("input", :name =>"user[password_confirmation]")}
		it {should have_selector("input", :type =>"submit")}
	end

end
