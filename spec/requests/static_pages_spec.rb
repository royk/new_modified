require 'spec_helper'
include ApplicationHelper

describe "Static pages" do
	subject {page}

	shared_examples_for "all static pages" do
		it {should have_selector('title', :text => full_title(page_title))}
	end

	describe "Home page" do
		before {visit root_path}
		let(:page_title) {"Home"}
		it_should_behave_like "all static pages"
	end

end
