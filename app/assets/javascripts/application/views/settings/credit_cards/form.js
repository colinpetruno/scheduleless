$(document).on("turbolinks:load", function() {
  function stripeResponseHandler(status, response) {
    if (response.error) {
      $form.find(".payment-errors").text(response.error.message);
      $form.find("button").prop("disabled", false);
    } else {
      var token = response.id;
      $("#credit_card_token").val(token);
      $("#new_credit_card,.edit_credit_card").off("submit").submit();
    }
  }

  $("#new_credit_card").submit(function (e) {
    e.preventDefault();
    clearValidations();

    if (valid()) {
      var $form = $("#credit-card-form");

      $form.find("input[type=text], input[type=tel], input[type=submit]").
        prop("disabled", "disabled");

      Stripe.card.createToken($form, stripeResponseHandler);
    } else {
      $("#new_credit_card input[type=submit]").prop("disabled", false);
      return false
    }
  });

  function clearValidations() {
    $(".stripe_credit_card_mock_name").removeClass("has-error").find(".help-block").hide();
    $(".stripe_credit_card_mock_card_number").removeClass("has-error").find(".help-block").hide();;
    $(".stripe_credit_card_mock_exp_month").removeClass("has-error").find(".help-block").hide();;
    $(".stripe_credit_card_mock_exp_year").removeClass("has-error").find(".help-block").hide();;
    $(".stripe_credit_card_mock_cvc").removeClass("has-error").find(".help-block").hide();;
  }

  function valid() {
    var valid = true;

    var cc_number = $("#stripe_credit_card_mock_card_number").val();
    if (!cc_number) {
      valid = false;
      $(".stripe_credit_card_mock_card_number").addClass("has-error");
      $(".stripe_credit_card_mock_card_number .help-block.blank").show();
    } else if(!$.isNumeric(cc_number)) {
      valid = false;
      $(".stripe_credit_card_mock_card_number").addClass("has-error");
      $(".stripe_credit_card_mock_card_number .help-block.numeric").show();
    }

    if (!$("#stripe_credit_card_mock_exp_month").val()) {
      valid = false;
      $(".stripe_credit_card_mock_exp_month").addClass("has-error");
      $(".stripe_credit_card_mock_exp_month .help-block.blank").show();
    }

    if (!$("#stripe_credit_card_mock_exp_year").val()) {
      valid = false;
      $(".stripe_credit_card_mock_exp_year").addClass("has-error");
      $(".stripe_credit_card_mock_exp_year .help-block.blank").show();
    }

    var cvc_number = $("#stripe_credit_card_mock_cvc").val();
    if (!cvc_number) {
      valid = false;
      $(".stripe_credit_card_mock_cvc").addClass("has-error");
      $(".stripe_credit_card_mock_cvc .help-block.blank").show();
    } else if (!/^[0-9]{3,4}$/.test(cvc_number)) {
      valid = false;
      $(".stripe_credit_card_mock_cvc").addClass("has-error");
      $(".stripe_credit_card_mock_cvc .help-block.numeric").show();
    }

    return valid;
  }
});
