# Checkbox Disable

<img src="example.jpg" alt="Disable Toggle" width="150" style="width: 150px;"/>

Disable toggles allow us to disable fields in a certain target section when 
a checkbox is clicked. To use simply specify the disable-toggle class on the 
boolean input and add a data-target attribute to specify the container of the
fields you want to disable.

**Example:**
```erb
  <%= f.input :all_shifts,
    as: :boolean,
    input_html: {
      class: "disable-toggle",
      data: { target: ".posting-date-range" }
    } %>

  <div class="posting-date-range">
    <%= f.input :date_start, as: :datepicker_range %>
  </div>
```
