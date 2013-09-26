window.NM_SESSION = (function() {
    var _active_drill_id = -1;
    var _active_session_id = -1;
    var _active_result_id = -1;
    var _defaultValidationMessages = {
        empty: "This field is mandatory",
        number: {
            incorrect: "Please fill in with numbers only"
        }
    }
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
        append : optional (default: false)
     */
    var _postForm = function(params) {
        var submit_data = {};
        var validated = true;
        if (typeof params.append!="boolean") {
            params.append = false;
        }
        $(params.form_selector + " input[type='text'],"+params.form_selector + " input[type='hidden'] ").each(function() {
            var result = _validateField($(this));
            if (validated) {
                validated = result;
            }
            submit_data[$(this).attr("name")] = $(this).val();
        });
        if (validated) {
            submit_data = $.extend(submit_data, params.data);
            $.ajax({
                type: "POST",
                url: params.controller_name,
                data: submit_data,
                success: function(data, status) {
                    if (status==="success") {
                        if (data.content && params.container_selector) {
                            if (params.append) {
                                $(params.container_selector).append(data.content);
                            } else {
                                $(params.container_selector).html(data.content);
                            }
                        }
                        params.success_cb(data.payload);
                    }
                }
            });
        }
    };

    var _validateField = function(fieldElement) {
        var validatorType = fieldElement.data("validation");
        var value = fieldElement.val();
        var validationError = "";
        var mustBeFilled = fieldElement.data("mandatory");
        // remove all previously set tooltips so we don't have multiple tooltips on the same field.
        if ((mustBeFilled || validatorType) && fieldElement.data("qtip")) {
            fieldElement.qtip("api").destroy();
        }
        if (mustBeFilled && (!value || !value.match(/.+/gi))) {
            validationError = "empty";
        }
        fieldElement.removeClass("validation-error");
        // if the field is empty but not mandatory, there's no need to check for validation.
        var needToContinue = value || mustBeFilled;
        if (validatorType && !validationError && needToContinue) {
            switch (validatorType) {
                case "number":
                    var acceptedValue = value.match(/\d+/gi);
                    if (acceptedValue!=value) {
                        validationError = "incorrect";
                    }
                break;
            }
        }
        if (validationError) {
            fieldElement.addClass("validation-error");
            var errorString = fieldElement.data(validationError+"Msg");
            if (!errorString) {
                errorString = _defaultValidationMessages[validationError];
                if (!errorString) {
                    errorString = _defaultValidationMessages[validatorType][validationError];
                }
            }
            NM.tooltip(fieldElement, errorString,{show:{ready:true}});
        }
        return validationError==="";
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
        _forbidEndSession();
        $("#newDrillForm input.submit").click(function() {
            _postForm({
                    form_selector: "#newDrillForm",
                    controller_name: "training_drills",
                    success_cb: _registerDrill
            });
            return false;
        });
        $("#newDrillForm input.back").click(function() {
            _addAnotherDrill();
            return false;
        });
    };
    var _initExistingDrillForm = function _initExistingDrillForm() {
        _forbidEndSession();
        $("#existingDrillForm input.submit").click(function() {
            _registerDrill({id:parseInt($("#existingDrillForm select").val(), 10)});
            return false;
        });
        $("#existingDrillForm input.back").click(function() {
            _addAnotherDrill();
            return false;
        });
    };

    var _initResultsForm = function _initResultsForm() {
        $("#drillResult input.submit").click(function() {
            var data = {training_drill_result:{}};
            data.training_drill_result.training_drill_id = _active_drill_id;
            data.training_drill_result.training_session_id = _active_session_id;
            _postForm({
                form_selector: "#drillResult",
                append: true,
                data: data,
                controller_name: "training_drill_results",
                container_selector: "#sessionInfo",
                success_cb: _addAnotherDrill
            });
            return false;
        });
        $("#drillResult input.back").click(function() {
            var confirmMsg = $(this).data("confirm");
            if (!confirmMsg || confirm(confirmMsg)) {
                _addAnotherDrill();
            }
        });
    };
    var _initSessionForm = function _initSessionForm() {

        $("#endSessionButton").click(function() {
            var data = {id:_active_session_id, training_session:{endTime:new Date().toString()}};
            $.ajax({
                type: "POST",
                url: "update_training_session",
                data: data,
                success: function(data, status) {
                    if (status==="success") {
                        $("#sessionTitle").hide();
                        $("#sessionDrill-input").hide();
                        $("#endSessionButton").hide();
                        window.location = "/training_sessions/"+_active_session_id;
                    }
                }
            });
        });
        $("#session_form input[name='training_session[startTime]']").val(new Date().toString());
        $("#session_form input.submit").click(function() {
            _postForm( {
                form_selector: "#session_form",
                controller_name: "training_sessions",
                container_selector: "#sessionTitle",
                success_cb: function(payload) {
                    _active_session_id = payload.id;
                    _addAnotherDrill();
                }
            });
            return false;
        });
    };

    var _registerDrill = function _registerDrill(payload) {
        _active_drill_id = payload.id;
        $("#drillForm").html("");
        _createForm({
                container_selector: "#drillForm",
                controller_name: "training_drill_results",
                data: {training_drill:{id:_active_drill_id}},
                success_cb: _initResultsForm});
    };

    var _addAnotherDrill = function _addAnotherDrill() {
        $("#sessionInfo").show();
        $("#session-form-title").hide();
        _allowEndSession();
        _createForm({
            container_selector: "#drillForm",
            controller_name: "training_drills",
            action: "init",
            success_cb: _initAddDrill
        });
    };

    var _allowEndSession = function _allowEndSession() {
        $("#endSessionButton").show();
    };

    var _forbidEndSession = function _forbidEndSession() {
        $("#endSessionButton").hide();
    };

    $(document).ready(function() {
        _initSessionForm();
    });
    return {};
}());
