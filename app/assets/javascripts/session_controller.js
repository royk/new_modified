window.NM_SESSION = (function() {
    var _active_drill_id = -1;
    var _init = function _init() {
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
            _active_drill_id = parseInt($("#existingDrillForm select").val(), 10);
            $("#drillForm").html("");
            debugger;
            return false;
        });
    };

    $(document).ready(function() {
        _init();
    });
    return {
        initNewDrillForm: _initNewDrillForm,
        initExistingDrillForm: _initExistingDrillForm
    }
}());
