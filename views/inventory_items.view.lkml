view: inventory_items {
  sql_table_name: demo_db.inventory_items ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }
  filter: date_filter {
    type: date
    sql:  {% condition date_filter %} ${created_date} {% endcondition %}  ;;
  }
  dimension: cost {
    type: number
    sql: ${TABLE}.cost ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year,
      hour_of_day,
      week_of_year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: created_time_format {
    type: date_time
    sql: ${created_time} ;;
    html: {{ rendered_value | date: "%r" }} ;;
  }

  dimension: created_quarter_test {
    # type: date_quarter
    type: date
    sql: date(${created_quarter}) ;;
  }

  dimension: test_15 {
    type: date
    sql: date_add(now(),-15);;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    type: string
    allowed_value: { value: "Date" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Year" }
    allowed_value: { value: "Week of Year" }
    default_value: "Date"
  }
  filter: timeframe_picker_filter {
    type: string
  }
  dimension: dynamic_timeframe {
    type:date
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Date' THEN ${inventory_items.created_date}
    WHEN {% parameter timeframe_picker %} = 'Week' THEN ${inventory_items.created_week}
    WHEN {% parameter timeframe_picker %} = 'Week of Year' THEN STR_TO_DATE(${inventory_items.created_week_of_year},'%U')
    WHEN{% parameter timeframe_picker %} = 'Month' THEN STR_TO_DATE(${inventory_items.created_year},'%Y')
    END ;;
  }




  dimension: product_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.product_id ;;
  }

  dimension_group: sold {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.sold_at ;;
  }
measure: count_test {
  type: number
  sql: count(${id}) ;;
}
  measure: count {
    type: count
    drill_fields: [id, products.id, products.item_name, order_items.count]
  }
}
