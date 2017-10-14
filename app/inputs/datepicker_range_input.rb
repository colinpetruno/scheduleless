class DatepickerRangeInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    unless string?
      input_html_classes.unshift("datepicker-range")
      input_html_options[:type] ||= input_type if html5?
    end

    options = merge_wrapper_options(input_html_options, wrapper_options)
    # prevent typing in the fields
    options[:readonly] = "readyonly"


    "<div>" +
      "<section>" + start_field(options) + "</section>" +
      "<section>" + end_field(options) + "</section>" +
    "</div>"
  end

  private

  def start_field(options)
    options[:class].push("datepicker-range-start")
    start_value = @builder.object.send(attribute_name)

    if start_value.present?
      start_value_date = Date.parse(start_value.to_s).to_s(:month_day_year)
    end

    @builder.text_field_tag("#{attribute_name}_display", start_value_date, options) +
      @builder.hidden_field(attribute_name, class: "datepicker-range-start-value")
  end

  def end_field(options)
    # TODO: find a better way to deal with the passed reference here
    options[:class].pop
    options[:class].push("datepicker-range-end")
    end_value = @builder.object.send(attribute_name)

    if end_value.present?
      end_value_date = Date.parse(end_value.to_s).to_s(:month_day_year)
    end

    @builder.text_field_tag("#{end_attribute_name}_display", end_value_date, options) +
      @builder.hidden_field(end_attribute_name, class: "datepicker-range-end-value")
  end

  def end_attribute_name
    attribute_name.to_s.gsub("start", "end").to_sym
  end
end
