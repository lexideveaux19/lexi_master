view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  parameter: timeframe_picker {
    label: "Date Granularity"
    type: string
    allowed_value: { value: "Date" }
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Month"
  }
  dimension: dynamic_timeframe {
    type: date
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Date' THEN ${orders.created_date}
    WHEN {% parameter timeframe_picker %} = 'Week' THEN ${orders.created_week}
    WHEN{% parameter timeframe_picker %} = 'Month' THEN ${orders.created_month}
    END ;;
    html: {% if timeframe_picker._parameter_value == "'Month'" %}
          {{ created_month_name._value }}
          {% else %}
          {{rendered_value}}
          {% endif %}
          ;;
  }
#  dimension: dynamic_timeframe_test {
#     type: string
#     sql:
#     CASE
#     WHEN {% parameter timeframe_picker %} = 'Date' THEN ${orders.created_date}
#     WHEN {% parameter timeframe_picker %} = 'Week' THEN ${orders.created_week}
#     WHEN{% parameter timeframe_picker %} = 'Month' THEN ${orders.created_month_name}
#     END ;;
# }

dimension: created_month {
  type: date
  group_label: "Created Date"
  sql: concat((DATE_FORMAT(${TABLE}.created_at, '%Y-%m')), '-01');;
}
  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      quarter,
      fiscal_year,
      year,
      month_name
    ]
    sql: ${TABLE}.created_at ;;
  }
  filter: status_filter {
    type: string
    suggest_dimension: status
  }

  dimension: status_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition status_filter %} ${status} {% endcondition %} ;;
  }
  measure: count_dynamic_status {
    type: count
    # filters: {
    #   field: status_satisfies_filter
    #   value: "yes"
    # }
  }

  dimension: created_one_day {
    type: date
    sql:DATE_ADD(${created_date}, INTERVAL 1 day);;
  }

  dimension: status {
    type: string
    sql: ${TABLE}.status ;;
    link: {
      label: "Drill Dashboard"
      url: "/dashboards/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"
    }
    link: {
      label: "Drill Explore"
      url:"/explore/lexi_bug_testing/order_items?fields=orders.status,users.age&f[orders.status]={{ value }}&f[orders.created_date]={{ _filters['orders.created_date'] | url_encode }}"
    }

    # html:
    # <a href="/dashboards/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"</a> ;;

  }

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    drill_fields: [id, users.last_name, users.id, users.first_name, order_items.count]
  }
}
