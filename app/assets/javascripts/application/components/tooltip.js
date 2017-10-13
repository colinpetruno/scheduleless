$(document).on("turbolinks:load", function() {
  $('[data-toggle="tooltip"]').tooltip();
});

$(document).on("turbolinks:before-visit", function() {
  $('[data-toggle="tooltip"]').tooltip('dispose');
});
