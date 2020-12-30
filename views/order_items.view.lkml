view: order_items {
  sql_table_name: demo_db.order_items ;;
  drill_fields: [id]

  filter: date_filter {
    type: date
    sql:  {% condition date_filter %} ${returned_date} {% endcondition %}  ;;
  }
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
      year,
      hour_of_day
    ]
    sql: ${TABLE}.returned_at ;;
  }

  parameter: year {
    type: string
    allowed_value: { value: "2020" }
    allowed_value: { value: "2019" }
    allowed_value: { value: "2018" }
    default_value: "Date"
  }


  dimension: dynamic_timeframe {
    type: yesno
    sql:
    CASE
    WHEN {% parameter year %} = '2020' THEN ${returned_year} = '2020'
    WHEN {% parameter year %} = '2019' THEN ${returned_year} = '2019'
    WHEN{% parameter year %} = '2018' THEN ${returned_year} = '2018'
    END ;;
  }


  # dimension: dynamic_timeframe {
  #   type: string
  #   sql:
  #   CASE
  #   WHEN {% parameter year %} = '2020' THEN ${returned_date} between date('2020-01-01') and date('2020-05-01')
  #   WHEN {% parameter year %} = '2019' THEN ${returned_date} between date('2019-01-01') and date('2019-05-01')
  #   WHEN{% parameter year %} = '2018' THEN ${returned_date} between date('2018-01-01') and date('2018-05-01')
  #   END ;;
  # }

  dimension: sale_price {
    type: number
    value_format_name: usd
    sql: ${TABLE}.sale_price ;;
    # value_format: "[>=1000000]$0.0,,\" M\";[>=1000]$0.0,\" K\";[<= -1000000] $0.0,,\" M\";[<= -1000]$0.0,\"K\"; $0.0;"

  }



  measure: avg_sale {
    type: average
    sql: ${sale_price};;
    value_format_name: usd_0
  }

  measure: sum_sale {
    type: sum
    sql: (${sale_price}*3)-${sale_price};;
    value_format_name: usd_0
    filters: [date_filter: "2018-05-18 12:00:00 to
      2018-05-18 14:00:00 "]
  }


  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
    value_format_name: usd
  }
}
