$(document).on("turbolinks:load", function() {
  $("select.country").each(function($select) {
    setValues($(this));
  });


  $("select.country").change(function() {
    setValues($(this));
  });

  function setValues($select) {
    var countriesWithStates = ["US", "CA", "AU"];
    var value = $select.val();

    $stateDropdown = $select.closest("form").find("#location_county_province");

    if(countriesWithStates.includes(value)) {
      $stateDropdown.closest(".input").removeClass("disabled");
      $stateDropdown.prop("disabled", false);

      $stateDropdown.find("option").hide();
      $stateDropdown.find("option:first-child").show();
      $stateDropdown.find("." + value).show();
    } else {
      $stateDropdown.val("");
      $stateDropdown.closest(".input").addClass("disabled");
      $stateDropdown.prop("disabled", "disabled");
    }
  }
});
