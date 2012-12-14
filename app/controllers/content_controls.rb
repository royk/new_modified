module ContentControls

	def get_item(clazz, params)
		@item = clazz.find(params[:id])
		# check that item supports privacy, and that user can't see private stuff.
		# if so, don't show the object
		if @item && @item.respond_to?(:public) && @item.public==false && signed_in?()==false
			logger.debug "YAY #{@item.public}"
			@item = nil
			redirect_to unauthorized_url
		end
		return @item
	end
end