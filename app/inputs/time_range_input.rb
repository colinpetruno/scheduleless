class TimeRangeInput < SimpleForm::Inputs::Base
  include ActionView::Context

  def input(wrapper_options)
    template.content_tag(:div, class: "time-range-input") do
      header + slider
    end
  end

  def label(_wrapper_options)
    I18n.t("date.day_names")[object.day - 1]
  end

  private

  def header
    template.content_tag(:header, { class: "labels" }) do
      template.concat template.content_tag(:div, object.start, class: "start")
      template.concat template.content_tag(:div, object.end, class: "end")
    end
  end

  def slider
    template.content_tag(:section) do
      template.concat (
        "<div class='slider'>" +
          start_hidden_input +
          end_hidden_input +
          slide_bar +
          left_grip +
          right_grip +
        "</div>"
      ).html_safe
    end
  end

  def start_hidden_input
    @builder.hidden_field(:start, { class: "start", data: { testing: @builder.object.start}})
  end

  def end_hidden_input
    @builder.hidden_field(:end, { class: "end" })
  end

  def slide_bar
    template.content_tag(:div, nil, class: "slide-bar")
  end

  def left_grip
    template.content_tag(:div, nil, class: "left-grip")
  end

  def right_grip
    template.content_tag(:div, nil, class: "right-grip")
  end

  def object
    @builder.object
  end
end
