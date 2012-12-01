module ContentTrait
	def content_view
	    ret = self.content.bbcode_to_html!({}, true, :enable, :bold).html_safe
	    ret = BBCodeizer.bbcodeize(self.content).html_safe
	end
end