$(document).on("turbolinks:load", function() {
  window.Scheduleless.instantiateDisableToggles = function () {
    $(".disable-toggle").each(function(){
      if ($(this).prop("checked")) {
        var target = $(this).data("target");
        $(target).find(".input").addClass("disabled");
        $(target).find("input,select").addClass("disabled").prop("disabled", true);;
      }
    });

    $(".disable-toggle").off("change").change(function(){
      var target = $(this).data("target");

      if (this.checked) {
        $(target).find(".input").addClass("disabled");
        $(target).find("input,select").addClass("disabled").prop("disabled", true);;
      } else {
        $(target).find(".input, input").removeClass("disabled");
        $(target).find("input,select").removeClass("disabled").prop("disabled", false);
      }
    });
  }

  window.Scheduleless.instantiateDisableToggles();
});
