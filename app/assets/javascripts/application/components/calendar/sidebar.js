window.Scheduleless.sidebar = {
  appendAndOpen: function (content) {
    $(".view-sidebar > .popup > .content").html(content);

    this.open();
  },

  close: function () {
    $('[data-toggle="tooltip"]').tooltip("hide");
    $(".view-sidebar > .popup").removeClass("open");
  },

  open: function () {
    $('[data-toggle="tooltip"]').tooltip("hide");
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
