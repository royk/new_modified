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
//= require jquery.idle-timer
//= require jquery.ez-pinned-footer
//= require jquery.qtip-1.0.0-rc3.min
//= require bootstrap
//= require feed_entity
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
    var _currentToggleMenu = null;
    var _periodify_intervals = {};
    var _feeds = [];

    return {
        initForm: function initForm(formID, submit_url, dataFunction, options) {

            (function form(formID, submit_url, dataFunction, options) {
                options = options || {};
                if (options.resetForm===undefined) {
                    options.resetForm = true;
                }
                var submitting = false;
                var submit_btn = $("#"+formID+"_submit_btn");
                var loading_indicator = $("#"+formID+"_loading_indicator");
                submit_btn.click(function() {
                    if (submitting) {
                        return;
                    }
                    submitting = true;
                    NM.clearAlerts();
                    submit_btn.hide();
                    loading_indicator.show();
                    var data = dataFunction();
                    $.ajax( {
                        type: "POST",
                        url:submit_url,
                        data: data,
                        success: function(request) {
                            NM.showAlert(request.message, request.success);
                            if (request.success && options.resetForm) {
                                $("#"+formID+" input").val("");
                            }

                        },
                        error: function(request) {
                            NM.showAlert(request.statusText, false);
                        },
                        complete: function() {
                            submitting = false;
                            submit_btn.show();
                            loading_indicator.hide();
                        }
                    });
                    return false;
                });
            })(formID, submit_url, dataFunction, options);
        },
        clearAlerts: function clearAlerts() {
            $("#bodyMainContainer > .alert").remove();
        },
        showAlert: function showAlert(message, success) {
            var type = "success";
            if (success==false) {
                type = "error";
            }
            this.clearAlerts();
            var html = '<div class="alert alert-'+type+'">'+message+'</div>';
            $("#bodyMainContainer").prepend(html);
        },
        tooltip: function tooltip(elem_name, content, params) {
            if (!params) {
                params = {style:{
                    tip:true,
                    background: "black",
                    color: "white",
                    border:{radius:4, color:"black"}
                }};
            }
            params.content = content;
            $(document).ready(function() {
                $(elem_name).qtip(params);
            });
        },

        multiField: function multiField(params) {
            (function multiFieldInst(params) {
                var idParts = $(params.mold).attr('id').split('_');
                params.idPrefix = params.idPrefix || "";
                $(params.container).append("<a id='"+params.idPrefix+"moreButton' class='multifield'><img class='add-icon' src='/assets/plus-icon.png'>"+params.moreText+"</a>");
                var index = params.startIndex;
                var moreButton = $("#"+params.idPrefix+"moreButton").click(function() {
                    var _id = idParts[0]+'_'+index;
                    var dup = $(params.mold).clone().attr('id', _id).val("").attr('name', _id).attr('placeholder', params.placeholder);
                    dup.children().each(function(i, child) {
                        $(child).attr('id', $(child).attr('id').replace("_"+(params.startIndex-1), "_"+index));
                        $(child).attr('name', $(child).attr('name').replace("_"+(params.startIndex-1), "_"+index));
                        $(child).val("");
                    });
                    dup.appendTo(params.container);
                    moreButton.detach().appendTo($(params.container));
                    index++;
                });
            })(params);
        },
        freeze: function freeze() {
            for (var o in _periodify_intervals) {
                clearInterval(_periodify_intervals[o].id);
            }
        },

        unfreeze: function unfreeze() {
            for (var o in _periodify_intervals) {
                _periodify_intervals[o].f();
                _periodify_intervals[o].id = setInterval(_periodify_intervals[o].f, _periodify_intervals[o].period);
            }
        },
        // Call supported functions every *period* miliseconds. Default: every 10 seconds
        every: function every(period) {
            period = period || 10000;
            var init = function (f, id) {
                if (_periodify_intervals[id]) {
                    clearInterval(_periodify_intervals[id].id);
                }
                _periodify_intervals[id] = {
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

        refreshFeedItems: function refreshFeedItems() {
            _feeds.forEach(function(feed) {
                feed.refresh();
            });
        },
        // updates a container via an ajax call.
        // Takes:
        // url:			name of the call
        // type:		request type (get, post, delete...) default: get
        // container:	jquery identifier for the html container where the results will be stored (e.g. "#item5")
        ajaxify: function ajaxify(params) {
            params.type = params.type || 'get';
            params.callback = params.callback || function(){};
            $.ajax({
                url: params.url,
                type: params.type,
                statusCode: {
                    302: function(response) {
                        window.location.href = response.redirect;
                        params.callback();
                    },
                    200: function(response) {
                        if (response && response==="session-ended")    {
                            window.location.reload();
                        } else {
                            if (response && /^\s*$/.test(response)==false) {
                                $(params.container).html(response);
                            }
                            params.callback();
                        }
                    }
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
            _currentToggleMenu = items;
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
            _currentToggleMenu.forEach(function(elem, index) {
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
        },
        clearToggleMenu: function clearToggleMenu() {
            _currentToggleMenu = null;
        },

        registerFeed: function registerFeed(params) {
            _feeds.push(new FeedEntity(params));
        }

    };
}());



$(window).unload( function () { NM.clearToggleMenu(); });