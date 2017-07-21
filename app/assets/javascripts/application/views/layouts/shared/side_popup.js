$(document).on("turbolinks:load", function() {
  var $element = $("#sidebar-close-button");

  if (!$element.length) {
    return;
  }

  $element.on("click", function() {
    $(".popup").removeClass("open");
  });
});
