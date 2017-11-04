class DatepickerInput < SimpleForm::Inputs::StringInput
  def input(wrapper_options = nil)
    unless string?
      input_html_classes.unshift("datepicker")
      input_html_options[:type] ||= input_type if html5?
    end

    merged_input_options = merge_wrapper_options(
      input_html_options,
      wrapper_options
    )

    start_value = @builder.object.send(attribute_name)
    if start_value.present?
      start_value_date = Date.parse(start_value.to_s).to_s(:month_day_year)
    end

    @builder.text_field_tag(
      "#{attribute_name}_display",
      start_value_date,
      field_options
    ) +
    @builder.hidden_field(
      attribute_name,
      class: "datepicker-value"
    )
  end


  private

  def field_options
    new_options = { class: "datepicker", readonly: "readonly" }.merge(options)
    new_options.delete(:readonly) if options[:readonly] == false

    new_options
  end
end
