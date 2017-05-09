$(document).on("turbolinks:load", function() {
  if($("#dev-credit-card-select").length) {
    var cards = [
      {card: "4242424242424242", cvv: "123", first: "Jane", last: "Doe"},
      {card: "5555555555554444", cvv: "123", first: "Jane", last: "Doe"},
      {card: "378282246310005", cvv: "1234", first: "Jane", last: "Doe"},
      {card: "4000000000000002", cvv: "123", first: "Jane", last: "Doe"}, // not in use
      {card: "4444444444444448", cvv: "123", first: "Jane", last: "Doe"},
      {card: "4222222222222220", cvv: "123", first: "Jane", last: "Doe"},
      {card: "5112000200000002", cvv: "200", first: "Jane", last: "Doe"},
      {card: "4457000300000007", cvv: "901", first: "Jane", last: "Doe"},
      {card: "6500000000000002", cvv: "123", first: "John", last: "Doe"}
    ];

    $("#dev-credit-card-select").change(function(){
      var card = cards[$(this).val() - 1];
      $("#stripe_credit_card_mock_card_number").val(card.card).trigger("change");
      $("#stripe_credit_card_mock_name").val(card.first + card.last);
      $("#stripe_credit_card_mock_cvc").val(card.cvv);
      $("#stripe_credit_card_mock_exp_month").val(12);
      $("#stripe_credit_card_mock_exp_year").val(2020);
    });
  }
});
