module ContentControls
	
	def get_item(clazz, params)
		@item = clazz.find(params[:id])
		# check that item supports privacy, and that user can't see private stuff.
		# if so, don't show the object
		if @item && @item.respond_to?(:public) && @item.public==false && signed_in?()==false
			@item = nil
		end
		return @item
	end
end