require 'spec_helper'
include ApplicationHelper

describe "Static pages" do
	subject {page}

	shared_examples_for "all static pages" do
		it {should have_selector('title', :text => full_title(page_title))}
		it {should have_link("Sign up", href: signup_path)}
		it {should have_link("Login", href: signin_path)}
		it {should have_link("Home", href: root_path)}
	end

	describe "Home page" do
		before {visit root_path}
		let(:page_title) {"Home"}
		it_should_behave_like "all static pages"
	end

	describe "Sign in" do
		before {visit signin_path}
		let(:page_title) {"Sign in"}
		it_should_behave_like "all static pages"
		it {should have_selector("input", :name =>"session[email]")}
		it {should have_selector("input", :name =>"session[password]")}
		it {should have_selector("input", :type =>"submit")}
	end

	describe "Sign up" do
		before {visit signup_path}
		let(:page_title) {"Sign up"}
		it_should_behave_like "all static pages"
		it {should have_selector("input", :name =>"user[name]")}
		it {should have_selector("input", :name =>"user[email]")}
		it {should have_selector("input", :name =>"user[password]")}
		it {should have_selector("input", :name =>"user[password_confirmation]")}
		it {should have_selector("input", :type =>"submit")}
	end

end
