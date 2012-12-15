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
		@page = Page.find_by_name(params[:name])
	end

	def update
		@page = Page.find_by_name(params[:name])
		@page.update_attribute(:content, params[:content])
		if @page.save
			flash[:success] = "Page saved"
			redirect_to page_path(@page.name)
		end
	end
end