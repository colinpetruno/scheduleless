$(document).on("turbolinks:load", function() {
  window.Scheduleless.instantiateCurrencyInputs();
})

window.Scheduleless.instantiateCurrencyInputs = function () {
  function padInputCurrency($input) {
    var value = $input.val();

    if(value) {
      value = parseFloat($input.val())
      $input.val(value.toFixed(2))
    }
  }

  $('input.currency').each(function(index, input){
    $(input).off("change.currency").on("change.currency", function(e){
      padInputCurrency($(this));
    });

    padInputCurrency($(this));
  });
};
