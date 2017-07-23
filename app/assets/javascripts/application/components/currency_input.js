$(document).on("turbolinks:load", function() {
  function padInputCurrency() {
    var value = parseFloat($('input.currency').val())
    $('input.currency').val(value.toFixed(2))
  }

  $('input.currency').change(function(e){
    padInputCurrency()
  })

  padInputCurrency()
})
