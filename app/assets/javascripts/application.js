// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, vendor/assets/javascripts,
// or vendor/assets/javascripts of plugins, if any, can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
// WARNING: THE FIRST BLANK LINE MARKS THE END OF WHAT'S TO BE PROCESSED, ANY BLANK LINE SHOULD
// GO AFTER THE REQUIRES BELOW.
//
//= require jquery
//= require jquery_ujs
//= require_tree .
//= require bootstrap

NM = (function() {
	return {
		toggleVisibility: function toggleVisibility(elem) {
			if (elem) {
				var mode = elem.css('display');
				if (mode=="none") {
					mode = "block";
				} else {
					mode = "none";
				}
				elem.css('display', mode);
			}
		},
		
		clearNotifications: function clearNotifications() {
			$.ajax({
				url: "/clear_notifications"
			});
		}
	};
}());