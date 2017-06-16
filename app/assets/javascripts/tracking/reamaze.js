document.addEventListener('turbolinks:load', function(event) {
  if (typeof Reamaze !== 'undefined') {
    Reamaze.reload();
  }
});
