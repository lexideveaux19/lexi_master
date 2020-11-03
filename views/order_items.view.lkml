view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]


  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: inventory_item_id {
    group_label: "test"
    group_item_label: ""
    type: number
    # hidden: yes
    sql: ${TABLE}.inventory_item_id ;;
  }

  dimension: order_id {
    group_label: "test"
    type: number
    # hidden: yes
    sql: ${TABLE}.order_id ;;

  }

  dimension_group: returned {
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
    sql: ${TABLE}.returned_at ;;
  }

  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
  }

  measure: avg_unique_sale {
    type: average_distinct
    sql_distinct_key: ${id} ;;
    sql: ${sale_price} ;;
    value_format_name: usd_0
  }

  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
    value_format_name: usd
  }
}
