$(document).on("turbolinks:load", function() {
  $("body").on("click", ".editable .edit-button", function(event) {
    event.preventDefault();

    $frame = $(this).closest(".editable");
    $frame.toggleClass("editing");
  });
});
