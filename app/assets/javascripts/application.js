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
//= require tinymce-jquery

// two minutes time idle
$.idleTimer(120000);
        
        
$(document).bind("idle.idleTimer", function(){
 NM.freeze();
});


$(document).bind("active.idleTimer", function(){
 NM.unfreeze();
});


NM = (function() {
	var currentToggleMenu = null;
	var currentPage = 1;
	var maxPages = 0;
	var scrollPath = '';
	var _loadingNextPage = false;
	var periodify_intervals = {};

	var _requestNextPage = function _requestNextPage() {
		if (++currentPage<=maxPages) {
			_loadingNextPage = true;
			$("#loading-indicator").show().fadeTo('slow', 1);
			$.ajax({
				url: scrollPath+'?page='+currentPage,
				type: 'get',
				success: function(response) {
					_loadingNextPage = false;
					$("#loading-indicator").fadeTo('fast', 0);
					$(".feed").append(response);
					$("#footer").pinFooter("relative");
				}
			});
		}
	};
	

	return {
		tooltip: function tooltip(elem_name, content, params) {
			if (!params) {
				params = {style:{tip:true, border:{width:3}}};
			}
			params.content = content;
			$(document).ready(function() {
				$(elem_name).qtip(params);
			});
		},

		multiField: function multiField(params) {
			var idParts = $(params.mold).attr('id').split('_');
			$(params.container).append("<a id='moreButton' class='multifield'>"+params.moreText+"</a>");
			var index = params.startIndex;
			var moreButton = $("#moreButton").click(function() {
				var _id = idParts[0]+'_'+index;
				$(params.mold).clone().attr('id', _id).val("").attr('name', _id).attr('placeholder', params.placeholder).appendTo(params.container);
				moreButton.detach().appendTo($(params.container));
				index++;
			});
		},
		freeze: function freeze() {
			for (var o in periodify_intervals) {
				clearInterval(periodify_intervals[o].id);
			}
		},

		unfreeze: function unfreeze() {
			for (var o in periodify_intervals) {
				periodify_intervals[o].f();
				periodify_intervals[o].id = setInterval(periodify_intervals[o].f, periodify_intervals[o].period);
			}
		},
		// Call supported functions every *period* miliseconds. Default: every 10 seconds
		every: function every(period) {
			period = period || 10000;
			var init = function (f, id) {
				if (periodify_intervals[id]) {
						clearInterval(periodify_intervals[id].id);
					}
					periodify_intervals[id] = {
						period: period,
						f: f,
						id: setInterval(f, period)
					};
			};
			return {
				ajaxify: function(params) {
					init(function() {NM.ajaxify(params);}, params.container);
				},
				refreshFeedItems: function () {
					init(function() {NM.refreshFeedItems();}, "feed");
				}
			};
		},
		// updates a container via an ajax call.
		// Takes:
		// url:			name of the call
		// type:		request type (get, post, delete...) default: get
		// container:	jquery identifier for the html container where the results will be stored (e.g. "#item5")
		ajaxify: function ajaxify(params) {
			params.type = params.type || 'get';
			$.ajax({
				url: params.url,
				type: params.type,
				statusCode: {
					302: function(response) {
						window.location.href = response.redirect;
					},
					200: function(response) {
						$(params.container).html(response);
					}
				}
				

			});
		},

		endlessScroll: function endlessScroll(params) {
			maxPages = params.maxPages;
			scrollPath = params.path;
			currentPage = params.currentPage || 1;

			$(window).scroll(function(){
				if ($(window).scrollTop() + $(window).innerHeight()>=document.body.scrollHeight) {
					if (!_loadingNextPage) {
						_requestNextPage();
					}
				}
			});
		},

		refreshFeedItems: function refreshFeedItems() {
			$.ajax({
				url: scrollPath+'?page=1+&items_count='+currentPage*10,
				type: 'get',
				success: function(response) {
					_loadingNextPage = false;
					$(".feed").html(response);
				}
			});
		},

		toggleVisibility: function toggleVisibility(elem) {
			elem = $(elem);
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
		},

		registerToggleMenu: function registerToggleMenu(items, buttons) {
			currentToggleMenu = items;
			buttons = buttons || [];
			buttons.forEach(function(button, index) {
				elem = $(button);
				elem.addClass("clickable");
				elem.click(function() {
					NM.selectMenuItem(index);
				});
			});
		},

		selectMenuItem: function selectMenuItem(itemIndex) {
			currentToggleMenu.forEach(function(elem, index) {
				elem = $(elem);
				var mode = index==itemIndex ? "block" : "none";
				elem.css('display', mode);
				if (index==itemIndex) {
					elem.addClass("toggle-selected");
				} else {
					if (elem.hasClass("toggle-selected")) {
						elem.removeClass("toggle-selected");
					}
				}

			});
			$("#footer").pinFooter("relative");
		},
		clearToggleMenu: function clearToggleMenu() {
			currentToggleMenu = null;
		}

	};
}());



$(window).unload( function () { NM.clearToggleMenu(); });