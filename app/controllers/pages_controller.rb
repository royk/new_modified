class PagesController < ApplicationController
	def show
		@page = Page.find_by_name(params[:name])
		if @page.nil?
			@page = Page.new
			@page.name = params[:name]
			@page.content = ""
			@page.save
		end
	end

	def edit
	end
end