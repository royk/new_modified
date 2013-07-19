function FeedEntity(__params) {
	var _params = __params || {};
	var _container;
	var _loadingNextPage = false;
	var _currentPage = 1;
    var _loadToggler;
    if (_params.loadNow) {
        _currentPage = 0;
    }

    var _callback = _params.callbackName;

	var _initScroll = function initScroll() {
        // temporary. remove once selector is canonized
        var containerSel = _params.container;
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
			$(_params.ajaxIconSelector).show().fadeTo('slow', 1);
			var delimiter = '?';
			if (_params.path.indexOf(delimiter)>-1) {
				delimiter = '&';
			}
			$.ajax({
				url: _params.path+delimiter+'page='+_currentPage,
				type: 'get',
				success: function(response) {
					_loadingNextPage = false;
                    $(_params.ajaxIconSelector).fadeTo('fast', 0);
					_container.append(response);
                    if (_callback) {
                        (0, eval)(_callback);
                    }
				}
			});
		}
	};

	if (_params.scrollable) {
		_initScroll();
	}
    if (_params.loadNow) {
        _requestNextPage();
    }
    if (_params.loadOnClick && _params.loadToggler) {
        _loadToggler = $(_params.loadToggler);
        if (_loadToggler.length) {
            _currentPage = 0;
            _loadToggler.on("click.feed", function() {
                _requestNextPage();
                _loadToggler.off("click.feed");
            });
        }
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