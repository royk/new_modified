window.NM_SESSION = (function() {
    var _active_drill_id = -1;
    var _active_session_id = -1;
    var _active_result_id = -1;
    var _initAddDrill = function _initAddDrill() {
        $("#newDrillButton").click(function() {
            $.ajax({
                type: "GET",
                url: "/training_drills/new",
                success: function(data, status) {
                    if (status==="success") {
                        $("#drillForm").html(data);
                    }
                }
            });
            return false;
        });
        $("#existingDrillButton").click(function() {
            $.ajax({
                type: "GET",
                url: "/training_drills/select",
                success: function(data, status) {
                    if (status==="success") {
                        $("#drillForm").html(data);
                    }
                }
            });
            return false;
        });

    };
    var _initNewDrillForm = function _initNewDrillForm() {
        $("#newDrillForm input[type='submit']").click(function() {
            var data = {};
            $("#newDrillForm input[type='text']").each(function() {
                data[$(this).attr("name")] = $(this).val();
            });
            $.ajax({
                type: "POST",
                url: "training_drills",
                data: data,
                success: function(_data, status) {
                    if (status==="success") {
                        _registerDrill(_data.id);
                    }
                }
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
                $("#drillResult input[type='text']").each(function() {
                    data[$(this).attr("name")] = $(this).val();
                });
                $.ajax({
                    type: "POST",
                    url: "training_drill_results",
                    data: data,
                    success: function(data, status) {
                        $("#drillForm").html('<a href="" id="existingDrillButton">Existing drill</a> or <a href="" id="newDrillButton">New drill</a>');
                        $("#sessionInfo").append(data);
                        _initAddDrill();
                    }
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
        $.ajax( {
            type: "GET",
            data: {training_drill:{id:_active_drill_id}},
            url: "training_drill_results/new",
            success: function(data, status) {
                if (status==="success") {
                    $("#drillForm").html(data);
                    _initResultsForm();
                }
            }
        });
    };

    var _registerSession = function _registerSession(cb) {
        var data = {};
        $("#session_form input[type='text']").each(function() {
            data[$(this).attr("name")] = $(this).val();
        });
        $.ajax( {
            type: "POST",
            url: "/training_sessions",
            data: data,
            success: function(_data, status) {
                if (status==="success") {
                    _active_session_id = _data.id;
                    cb();
                }
            }
        });
    };

    $(document).ready(function() {
        _initAddDrill();
    });
    return {
        initNewDrillForm: _initNewDrillForm,
        initExistingDrillForm: _initExistingDrillForm
    }
}());
