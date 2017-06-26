class DatepickerRangeInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    unless string?
      input_html_classes.unshift("datepicker-range")
      input_html_options[:type] ||= input_type if html5?
    end

    options = merge_wrapper_options(input_html_options, wrapper_options)

    start_field(options) + end_field(options)
  end

  private

  def start_field(options)
    options[:class].push("datepicker-range-start")
    @builder.text_field(attribute_name, options)
  end

  def end_field(options)
    # TODO: find a better way to deal with the passed reference here
    options[:class].pop
    options[:class].push("datepicker-range-end")
    @builder.text_field(end_attribute_name, options)
  end

  def end_attribute_name
    attribute_name.to_s.gsub("start", "end").to_sym
  end
end
