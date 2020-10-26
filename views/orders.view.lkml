view: orders {
  sql_table_name: demo_db.orders ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

dimension_group: duration {
label: "24-hour days duration"
type: duration
sql_start: ${created_date};;
sql_end: coalesce(${order_items.returned_date}, now()) ;;
intervals: [hour]
}

dimension: duration_8 {
  label: "business day hours"
  sql:  concat(round((${hours_duration}/24)*8,1), " hours") ;;
  value_format: "string"
}

measure: count_month {
  type: sum
  sql: case when ${created_month} IS NOT NULL then 1 else 0 end ;;
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
      day_of_week,
      time_of_day,
      year,
      month_name
    ]
    sql: ${TABLE}.created_at ;;
  }
  dimension: time_of_day_number{
    type: number
    sql: cast(${created_time_of_day} as decimal(4,2)) ;;
    value_format_name: decimal_2
  }

  filter: status_filter {
    type: string
    suggest_dimension: orders.status
    default_value: "-cancelled"
     sql: {% condition status_filter %} ${status} {% endcondition %} ;;
  }

  dimension: status_satisfies_filter {
    type: yesno
    hidden: yes
    sql: {% condition status_filter %} ${status} {% endcondition %} ;;
  }
  measure: count_dynamic_status {
    type: count
    filters: {
      field: status_satisfies_filter
      value: "yes"
    }
  }

  dimension: created_one_day {
    type: date
    sql:DATE_ADD(${created_date}, INTERVAL 1 day);;
  }

  dimension: status_with_links {
    type: string
    sql: ${TABLE}.status ;;
    html: {% if value == 'cancelled' %}
    <div class="vis-single-value"  style="margin:0; padding:0; border-radius:0; color: black; background-color: lightblue; text-align:center">{{ rendered_value }}</div>
    {% elsif value == 'complete' %}
    <div style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</div>
    {% else %}
    <div style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</div>
    {% endif %}
    ;;

    link: {
      label: "Drill Dashboard"
      url: "/dashboards-next/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"
    }
    link: {
      label: "Drill Explore"
      url:"/explore/lexi_bug_testing/order_items?fields=orders.status,users.age&f[orders.status]={{ value }}&f[orders.created_date]={{ _filters['orders.created_date'] | url_encode }}"
    }
    # html:
    # <a href="/dashboards/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"</a> ;;
  }

  dimension: status{
  type:string
  sql:${TABLE}.status;;
}

  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count {
    type: count
    # filters: [status: "-NULL"]
    label: "{% if orders.status._in_query %} Status Count {% else %} Regular Count {% endif %}"
    # label: "status count"
    link: {
      label: "drill count"
      url: "{{link}}"
    }
    link: {
      label: "Drill Dashboard"
      url: "/dashboards/4304"
    }
    drill_fields: [drill_test*]
  }
set: drill_test {
  fields: [id, users.last_name, users.id, users.first_name, order_items.count]
}
}
