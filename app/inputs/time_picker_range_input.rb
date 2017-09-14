class TimePickerRangeInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    unless string?
      input_html_classes.unshift("timepicker-range")
      input_html_options[:type] ||= input_type if html5?
    end
    options = merge_wrapper_options(input_html_options, wrapper_options)
    options[:class].push("scrollable")


    "<div>" +
      "<section>" +
        start_field(options) + hidden_start_field(options) +
      "</section>" +
      "<section>" +
        end_field(options) + hidden_end_field(options) +
      "</section>" +
    "</div>"
  end

  private

  def start_field(options)
    options[:class].push("timepicker-range-start")
    @builder.text_field(attribute_name, options)
  end

  def hidden_start_field(options)
    @builder.hidden_field(:minute_start, { class: "start" })
  end

  def end_field(options)
    options[:class].pop
    options[:class].push('timepicker-range-end')
    @builder.text_field(end_attribute_name, options)
  end

  def hidden_end_field(options)
    @builder.hidden_field(:minute_end, { class: "end" })
  end

  def end_attribute_name
    attribute_name.to_s.gsub("start", "end").to_sym
  end
end
