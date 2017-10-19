window.Scheduleless.sidebar = {
  appendAndOpen: function (content) {
    $(".view-sidebar > .popup > .content").html(content);

    this.open();
  },

  addErrors: function(content) {
    $(".view-sidebar > .popup > .content").html(content);
    window.Scheduleless.reinstantiatePickers();
  },

  close: function () {
    $('[data-toggle="tooltip"]').tooltip("hide");
    $(".view-sidebar > .popup").removeClass("open");

    // add back sidebar tooltips
    $('.view-sidebar [data-toggle="tooltip"]').tooltip();
  },

  open: function () {
    $('[data-toggle="tooltip"]').tooltip("hide");

    // completely remove tooltips to prevent them from popping through
    $('.view-sidebar [data-toggle="tooltip"]').tooltip("dispose");

    $(".view-sidebar > .popup").show().addClass("open");
    window.Scheduleless.reinstantiatePickers();
  },

  togglePublishedShiftHint: function (shiftsPresent) {
    if(shiftsPresent) {
      $("#unpublished-shift-hint").removeClass("hidden");
    } else {
      $("#unpublished-shift-hint").addClass("hidden");
    }
  }
}
