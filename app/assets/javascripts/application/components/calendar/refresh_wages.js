window.Scheduleless.wages = {
  refresh: function(location_id) {
    var url = "/remote/calendar/locations/" + location_id + "/wages"

    $.get({
      url: url,
      dataType: "script"
    });
  }
}
