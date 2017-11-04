window.Scheduleless.instantiateSingleSelects = function() {
  $("select.single_tag_select").each(function() {
    $(this).select2({
      placeholder: $(this).attr("placeholder"),
      selectOnClose: true,
      width: "100%"
    });
  });
};


$(document).on("turbolinks:load", function() {
  window.Scheduleless.instantiateSingleSelects();
});
