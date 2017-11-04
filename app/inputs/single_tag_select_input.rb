class SingleTagSelectInput < SimpleForm::Inputs::CollectionSelectInput
  def input_html_classes
    super.push("single-tag-select-input").push("select")
  end
end
