document.addEventListener('turbolinks:load', function(event) {
  $('[data-track-click="enabled"]').on("click", function(e) {
    mixpanel.track("Click", {
      page: $(this).data('page'),
      link_intent: $(this).data('link-intent'),
      link_location: $(this).data('link-name')
    });
  });
});
