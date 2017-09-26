window.Scheduleless.wages = {
  refresh: function(location_id) {
    var url = "/remote/calendar/locations/24/wages"
    $.get({
      url: url,
      success: function(success){
        console.log("im done");
        console.log(success);
      },
      dataType: "script"
    });
  }
}
