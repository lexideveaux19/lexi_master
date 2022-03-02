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
  dimension_group: delivered_null {
    type: time
    timeframes: [
      date
    ]
    sql:CASE WHEN ${TABLE}.delivered_at IS NULL then "" ELSE ${TABLE}.delivered_at END;;
  }
  dimension: history_button {
    sql: ${TABLE}.id ;;
    html: <a href=
        "/explore/lexi_bug_testing/order_items?fields=order_items.order_id,order_items.count,order_items.created_date,inventory_items.product_id,inventory_items.cost&f[users.id]={{ value }}"
        ><button>Order History</button></a>;;
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
      hour_of_day,
      month_name
    ]
    # drill_fields: [returned_date]
    sql: ${TABLE}.returned_at ;;
  }

  dimension: year_number {
    type: number
    sql: ${returned_year}  ;;
  }

  measure: max_return {
    type: date
    sql: max(${returned_raw}) ;;
    convert_tz: no
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

  measure : sum_sales_price {
    type:  sum
    sql:  ${sale_price} ;;
    value_format_name: usd
  }

  measure: sale_formatted {
    type: sum
    sql: ${sale_price} ;;
    html:
       {% if value > 100 %}
         <p style="color: red; font-size: 50%">{{ rendered_value }}</p>
       {% elsif value >1000 %}
         <p style="color: blue; font-size:80%">{{ rendered_value }}</p>
       {% else %}
         <p style="color: black; font-size:100%">{{ rendered_value }}</p>
       {% endif %};;
  }


  measure: avg_sale {
    type: average
    sql: ${sale_price};;
    value_format_name: usd_0
  }

  measure: sum_sale {
    type: sum
    sql: (${sale_price}*3)-${sale_price};;
    filters: [date_filter: "2018-05-18 12:00:00 to
      2018-05-18 14:00:00 "]
  }


  measure: count {
    type: count
    drill_fields: [id, orders.id, inventory_items.id]
  }
}
