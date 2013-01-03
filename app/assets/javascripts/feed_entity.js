function FeedEntity(__params) {
	var _params = __params || {};
	var _container;
	var _loadingNextPage = false;
	var _currentPage = 1;
	var _initScroll = function initScroll() {
		_container = $(_params.container);
		if (_container) {
			$(window).scroll(function(){
				if ($(window).scrollTop() + $(window).innerHeight()>=document.body.scrollHeight) {
					if (_container.is(":visible")) {
						if (!_loadingNextPage) {
							_requestNextPage();
						}
					}
				}
			});
		} else {
			console.log("Can't start scroll on container", params.container);
		}
	};
	var _requestNextPage = function _requestNextPage() {
		if (++_currentPage<=_params.maxPages) {
			_loadingNextPage = true;
			$(".loading-indicator").show().fadeTo('slow', 1);
			var delimiter = '?';
			if (_params.path.indexOf(delimiter)>-1) {
				delimiter = '&';
			}
			$.ajax({
				url: _params.path+delimiter+'page='+_currentPage,
				type: 'get',
				success: function(response) {
					_loadingNextPage = false;
					$(".loading-indicator").fadeTo('fast', 0);
					_container.append(response);
					$("#footer").pinFooter("relative");
				}
			});
		}
	};

	if (_params.scrollable) {
		_initScroll();
	}
	return {
		refresh: function refresh() {
			if (_container && _container.is(":visible")) {
				$.ajax({
					url: _params.path+'?page=1+&items_count='+_currentPage*10,
					type: 'get',
					success: function(response) {
						_loadingNextPage = false;
						_container.html(response);
					}
				});
			}
		}
	};
}