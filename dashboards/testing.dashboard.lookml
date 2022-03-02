- dashboard: diff_model
  title: table dash
  layout: newspaper
  preferred_viewer: dashboards-next
  crossfilter_enabled: true
  description: ''
  elements:
  - title: New Tile
    name: New Tile
    model: test_test_change
    explore: order_items
    type: looker_grid
    fields: [orders.status, orders.count]
    sorts: [orders.status]
    limit: 500
    column_limit: 50
    dynamic_fields: [{category: table_calculation, expression: "${orders.count}/sum(${orders.count})",
        label: percent total, value_format: !!null '', value_format_name: percent_2,
        _kind_hint: measure, table_calculation: percent_total, _type_hint: number}]
    query_timezone: America/Los_Angeles
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    listen: {}
    row: 0
    col: 0
    width: 8
    height: 6
  - title: New Tile
    name: New Tile (2)
    model: lexi_bug_testing
    explore: order_items
    type: looker_pie
    fields: [orders.status, orders.count]
    sorts: [orders.status]
    limit: 500
    column_limit: 50
    query_timezone: America/Los_Angeles
    value_labels: legend
    label_type: labPer
    show_view_names: false
    show_row_numbers: true
    transpose: false
    truncate_text: true
    hide_totals: false
    hide_row_totals: false
    size_to_fit: true
    table_theme: white
    limit_displayed_rows: false
    enable_conditional_formatting: false
    header_text_alignment: left
    header_font_size: 12
    rows_font_size: 12
    conditional_formatting_include_totals: false
    conditional_formatting_include_nulls: false
    defaults_version: 1
    series_types: {}
    listen: {}
    row: 6
    col: 0
    width: 8
    height: 6
