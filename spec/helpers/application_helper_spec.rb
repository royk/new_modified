require 'spec_helper'
include ApplicationHelper

describe "Application helper" do
	describe "site title" do
		describe "title exists" do
			it "should include the title" do
				full_title("foo").should =~ /foo/
			end
			it "should include the site name" do
				full_title("foo").should =~ /#{Regexp.escape(site_name)}/
			end
		end
		describe "title doesn't exist" do
			it "should include the site name" do
				full_title("").should =~ /#{Regexp.escape(site_name)}/
			end
			it "should not include the separator" do
				full_title("").should_not =~ /\|/
			end
		end
	end
end
