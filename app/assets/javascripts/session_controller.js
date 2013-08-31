window.NM_SESSION = (function() {
    var _active_drill_id = -1;
    var _active_session_id = -1;
    var _active_result_id = -1;
    /*
        params:
            container_selector
            controller_name
            action: optional (defualt: new)
            data: optional
            success_cb: optional
     */
    var _createForm = function(params) {
        $(params.container_selector).html("");
        params.action = params.action || "new";
        params.success_cb = params.success_cb || function(){};
        var url = "/"+params.controller_name+"/"+params.action;
        $.ajax({
            type: "GET",
            url: url,
            data: params.data,
            success: function(data, status) {
                if (status==="success") {
                    $(params.container_selector).html(data);
                    params.success_cb()
                }
            }
        })
    };
    /*
        form_selector
        container_selector: optional
        controller_name
        data
        success_cb
     */
    var _postForm = function(params) {
        var submit_data = {};
        $(params.form_selector + " input[type='text']").each(function() {
            submit_data[$(this).attr("name")] = $(this).val();
        });
        submit_data = $.extend(submit_data, params.data);
        $.ajax({
            type: "POST",
            url: params.controller_name,
            data: submit_data,
            success: function(data, status) {
                if (status==="success") {
                    if (data.content && params.container_selector) {
                        $(params.container_selector).html(data.content);
                    }
                    params.success_cb(data.payload);
                }
            }
        });
    };
    var _initAddDrill = function _initAddDrill() {
        $("#newDrillButton").click(function() {
            _createForm({   container_selector:"#drillForm",
                            controller_name:"training_drills",
                            success_cb:_initNewDrillForm});
            return false;
        });
        $("#existingDrillButton").click(function() {
            _createForm({   container_selector:"#drillForm",
                            controller_name:"training_drills",
                            action:"select",
                            success_cb: _initExistingDrillForm});
            return false;
        });

    };
    var _initNewDrillForm = function _initNewDrillForm() {
        $("#newDrillForm input[type='submit']").click(function() {
            _postForm({
                    form_selector: "#newDrillForm",
                    controller_name: "training_drills",
                    success_cb: _registerDrill
            });
            return false;
        });
    };
    var _initExistingDrillForm = function _initExistingDrillForm() {
        $("#existingDrillForm input[type='submit']").click(function() {
            _registerDrill(parseInt($("#existingDrillForm select").val(), 10));
            return false;
        });
    };

    var _initResultsForm = function _initResultsForm() {
        $("#drillResult input[type='submit']").click(function() {
            var saveResult = function saveResult() {
                var data = {training_drill_result:{}};
                data.training_drill_result.training_drill_id = _active_drill_id;
                data.training_drill_result.training_session_id = _active_session_id;
                _postForm({
                    form_selector: "#drillResult",
                    data: data,
                    controller_name: "training_drill_results",
                    container_selector: "#sessionInfo",
                    success_cb: _addAnotherDrill
                });
            };
            if (_active_session_id==-1) {
                _registerSession(saveResult);
            } else {
                saveResult();
            }
            return false;
        });
    };

    var _registerDrill = function _registerDrill(drillId) {
        _active_drill_id = drillId;
        $("#drillForm").html("");
        _createForm({
                container_selector: "#drillForm",
                controller_name: "training_drill_results",
                data: {training_drill:{id:_active_drill_id}},
                success_cb: _initResultsForm});
    };

    var _registerSession = function _registerSession(cb) {
        var onSuccess = function(payload) {
            _active_session_id = payload.id;
            cb();
        };
        _postForm({
            form_selector: "#session_form",
            controller_name: "training_sessions",
            success_cb: onSuccess
        });
    };

    var _addAnotherDrill = function _addAnotherDrill() {

        _createForm({
            container_selector: "#drillForm",
            controller_name: "training_drills",
            action: "init",
            success_cb: _initAddDrill
        });
    };

    $(document).ready(function() {
        _addAnotherDrill();
    });
    return {};
}());
