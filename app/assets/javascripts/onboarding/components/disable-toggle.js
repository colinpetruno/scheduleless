$(document).on("turbolinks:load", function() {
  $(".disable-toggle").each(function(){
    if ($(this).prop("checked")) {
      var target = $(this).data("target");
      $(target).find(".input").addClass("disabled");
      $(target).find("input,select").addClass("disabled").prop("disabled", true);;
    }
  });

  $(".disable-toggle").change(function(){
    console.log("changed");
    var target = $(this).data("target");
    console.log(target);

    if (this.checked) {
      $(target).find(".input").addClass("disabled");
      $(target).find("input,select").addClass("disabled").prop("disabled", true);
    } else {
      $(target).find(".input, input").removeClass("disabled");
      $(target).find("input,select").removeClass("disabled").prop("disabled", false);
    }
  });
});
