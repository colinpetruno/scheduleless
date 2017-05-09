$(document).on("turbolinks:load", function() {
  function stripeResponseHandler(status, response) {
    if (response.error) {
      $form.find(".payment-errors").text(response.error.message);
      $form.find("button").prop("disabled", false);
    } else {
      console.log("blah");
      console.log(response);
      var token = response.id;
      $("#credit_card_token").val(token);
      // $("#new_credit_card,.edit_credit_card").off("submit").submit();
    }
  }

  $("#new_credit_card,.edit_credit_card").submit(function (e) {
    e.preventDefault();

    var $form = $("#credit-card-form");

    $form.find("input[type=text], input[type=tel], input[type=submit]").
      prop("disabled", "disabled");

    Stripe.card.createToken($form, stripeResponseHandler);
    return false;
  });
});
