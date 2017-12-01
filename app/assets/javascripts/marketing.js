//= require_self
//= require jquery
//= require jquery_ujs
//= require typeahead.js.js
//= require pikaday


// we cant remove turbolinks or tracking breaks
//= require turbolinks
//= require_tree ./tracking
//= require tether
//= require bootstrap-sprockets
//= require_tree ./shared
//= require_tree ./marketing

window.Scheduleless = {
  pickers: [],
  picker_options: function(field) {
        return {
      field: field[0],
      i18n: window.Scheduleless.i18n.dates,
      minDate: new Date(),
      toString: function(date) {
        return window.Scheduleless.dateUtils.datePickerFormat(date);
      }
    };
  },
};
