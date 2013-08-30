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
                success: function(data, status) {
                    data = JSON.parse(data);
                    if (status==="success") {
                        _registerDrill(data.id);
                        _active_drill_id = data.id;
                        $("#drillForm").html("");
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
            var data = {training_drill_result:{}};
            data.training_drill_result.training_drill_id = _active_drill_id;
            data.training_drill_result.training_session_id = _active_session_id;
            $("#drillResult input[type='text']").each(function() {
                data.training_drill_result[$(this).attr("name")] = $(this).val();
            });
            $.ajax({
                type: "POST",
                url: "training_drill_results",
                data: data,
                success: function(data, status) {
                    $("#drillForm").html('<a href="" id="existingDrillButton">Existing drill</a> or <a href="" id="newDrillButton">New drill</a>');
                    $("#drillInfo").append(data);
                    _initAddDrill();
                }
            });
            return false;
        });
    };

    var _registerDrill = function _registerDrill(drillId) {
        _active_drill_id = drillId;
        $("#drillForm").html("");
        $.ajax( {
            type: "GET",
            url: "training_drill_results/new",
            success: function(data, status) {
                if (status==="success") {
                    $("#drillForm").html(data);
                    _initResultsForm();
                }
            }
        });
    }

    $(document).ready(function() {
        _initAddDrill();
    });
    return {
        initNewDrillForm: _initNewDrillForm,
        initExistingDrillForm: _initExistingDrillForm
    }
}());
