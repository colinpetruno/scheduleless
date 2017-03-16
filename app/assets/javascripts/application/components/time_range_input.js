(function ( $ ) {
  var hoursInDay = 24;
  var minutesInHour = 60;
  var timeRangeInput = function(elem, options) {
    this.$elem = elem;
    this.$slider = this.$elem.find(".slider");
    this.$leftGrip = this.$elem.find(".left-grip");
    this.$rightGrip = this.$elem.find(".right-grip");
    this.$slideBar = this.$elem.find(".slide-bar");
    this.$start = this.$elem.find("input.start");
    this.$startLabel = this.$elem.find(".labels .start");
    this.$end = this.$elem.find("input.end");
    this.$endLabel = this.$elem.find(".labels .end");
    this.startTime = this.$elem.find("div.start").val();
    this.endTime = this.$elem.find("div.end").val();
    this.settings = $.extend(this.defaults, options );
  };

  timeRangeInput.prototype = {
    defaults: {
      interval: 0.5 // TODO: Interval in hours might be confusing vs minutes
    },
    init: function() {
      var $timeRangeInput = this;

      this.$slideBar.css("left", this.initialLeftPosition());
      this.$slideBar.css("right", this.initialRightPosition());

      this.setInitialHandlePositions();

      this.$leftGrip.draggable({
        axis: "x",
        containment: this.$slider,
        drag: function() {
          var position = $(this).position().left;
          var startTime = (position / $timeRangeInput.snapWidth()) * (minutesInHour * $timeRangeInput.settings.interval);

          $timeRangeInput.$startLabel.text(startTime);
          $timeRangeInput.$start.val(startTime);
          $timeRangeInput.$slideBar.css("left", $(this).position().left + 8);
        },
        grid: [this.snapWidth(), 0]
      });

      this.$rightGrip.draggable({
        axis: "x",
        containment: this.$slider,
        drag: function() {
          var position = $(this).position().left;
          var sliderWidth = $(this).outerWidth();
          // get position / interval width to get start point then
          // multiply by number of minutes each interval represents
          var endTime = ((position + sliderWidth) / $timeRangeInput.snapWidth()) * (minutesInHour * $timeRangeInput.settings.interval);

          $timeRangeInput.$endLabel.text(endTime - 30);
          $timeRangeInput.$end.val(endTime);
          $timeRangeInput.$slideBar.css("right", 384 - position - 8);
        },
        grid: [this.snapWidth(), 0]
      });
    },

    setInitialHandlePositions: function() {
      var intervalNumber = this.$start.val() / (minutesInHour * this.settings.interval);
      this.$leftGrip.css("left", intervalNumber * this.snapWidth() - 8);

      var intervalNumber = this.$end.val() / (minutesInHour * this.settings.interval);
      this.$rightGrip.css("left", intervalNumber * this.snapWidth() - 8);
    },

    initialLeftPosition: function() {
      // minutes / interval = num of intervals
      // num of intervals * pixel value of interval
      var intervalNumber = this.$start.val() / (minutesInHour * this.settings.interval);
      return intervalNumber * this.snapWidth();
    },

    initialRightPosition: function() {
      var intervalNumber = this.$end.val() / (minutesInHour * this.settings.interval);
      return 392 - (intervalNumber * this.snapWidth());
    },

    snapWidth: function() {
      var numIntervals = (hoursInDay / this.defaults.interval) + 1;
      return (392 / numIntervals);
    }
  };

  $.fn.timeRangeInput = function(options) {
    this.each( function() {
      new timeRangeInput($(this)).init(options);
    });

    return this;
  };
}( jQuery ));

$(document).on("turbolinks:load", function() {
  $(".time-range-input").timeRangeInput();
});
