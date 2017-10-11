window.Scheduleless.calendar.redraw = function(html) {
  console.log("redraw base");
  $html = $(html);

  if($html.find(".calendars-weekly-schedule").length > 0) {
    this.redrawWeeklyCalendar($html);
  } else {
    this.redrawDailyCalendar($html);
  }
};


window.Scheduleless.calendar.redrawWeeklyCalendar = function($html) {
  console.log("redraw wekly");
  var $header = $html.find(".calendars-weekly-schedule > header");
  var $body = $html.find(".calendars-weekly-schedule > section");

  $(".calendars-weekly-schedule > header").html($header.html());
  $(".calendars-weekly-schedule > section").html($body.html());
}

window.Scheduleless.calendar.redrawDailyCalendar = function($html) {
  console.log("redraw daily");
  var $shifts = $html.find(".calendars-daily-schedule .shifts-container");

  $(".calendars-daily-schedule .shifts-container").html($shifts.html());
}
