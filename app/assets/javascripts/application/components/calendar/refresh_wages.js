window.Scheduleless.wages = {
  refresh: function(location_id, date) {
    var url = "/remote/calendar/locations/" + location_id + "/wages"

    $.get({
      url: url,
      data: { date: date },
      dataType: "script"
    });
  }
}
