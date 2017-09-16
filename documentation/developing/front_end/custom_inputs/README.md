# Custom Inputs

Scheduleless uses many additions to simple form to render out the proper
javascript enhanced fields. This ensures that all our inputs are consistent
and standardized throughout the entire site. No inputs should ever require
custom javascript to enhance its functionality. Instead you should program
the options to be accessible from the simple form input options so we can
use the field enhancements across all the input fields.

#### Creating a new input type

* First make a new simple form input. [Source](/app/inputs/datepicker_range_input.rb)
* Then create a JS file to perform the enhancements. [Source](/app/assets/javascripts/application/components/datepicker_range.js) 

These files work in tandem. Everything needed to drive the input should be
rendered into the html from the backend ruby input. Then the javascript will
pick those values up and set defaults/perform translations etc. 


Inputs
======

* [CheckBox Disable](./check_box_disable)
  * Disable fields when checkbox is checked
* Currency
  * Handle currency inputs and formatting
* Datepicker
  * Select a single Date
* Datepicker Range
  * Select dates in a range
* Time Picker
  * Select a single Time
* Time Picker Range
  * Select a range of times
* Time Range
  * Alternate Style of Time Picker Range, we should look into removing?
