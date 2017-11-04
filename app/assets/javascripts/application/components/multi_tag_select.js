window.Scheduleless.instantiateMultiSelects = function() {
    $("select.multi_tag_select").each(function() {
      $(this).select2({
        placeholder: $(this).attr("placeholder"),
        selectOnClose: true,
        width: "100%"
      });
    });
  };

$(document).on("turbolinks:load", function() {
 window.Scheduleless.instantiateMultiSelects();
});
