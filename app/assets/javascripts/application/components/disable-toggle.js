$(document).on("turbolinks:load", function() {
  $(".disable-toggle").change(function(){
    var target = $(this).data("target");

    if (this.checked) {
      $(target).find(".input").addClass("disabled");
      $(target).find("input").addClass("disabled").prop("disabled", true);;
    } else {
      $(target).find(".input, input").removeClass("disabled");
      $(target).find("input").removeClass("disabled").prop("disabled", false);
    }
  });
});
