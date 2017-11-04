class MultiTagSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_html_options
    super.merge(multiple: true)
  end

  def input_html_classes
    super.push("multi-tag-select-input").push("select")
  end
end
