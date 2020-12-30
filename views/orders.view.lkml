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
  # value_format: "string"
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
      day_of_month,
      day_of_week,
      time_of_day,
      hour_of_day,
      year,
      month_name
    ]
    sql: ${TABLE}.created_at ;;
  }


  dimension: fiscal_year {
    type: string
    sql: CAST(${created_fiscal_year} as CHAR) ;;
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

  dimension: link_field {
    label: "Link"
    link: {
      label: "Link to dashboard"
      url: "/dashboards-next/4304?Status={{ _filters['orders.status'] }}&Category={{ _filters['products.category._value'] }}"
    }
    sql: 'dashboard';;
  }

  dimension: created_one_day {
    type: date
    sql:DATE_ADD(${created_date}, INTERVAL 1 day);;
  }

  dimension: status_with_links {
    type: string
    sql: ${TABLE}.status ;;
    # html: {% if value == 'cancelled' %}
    # <div class="vis-single-value"  style="margin:0; padding:0; border-radius:0; color: black; background-color: lightblue; text-align:center">{{ rendered_value }}</div>
    # {% elsif value == 'complete' %}
    # <div style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</div>
    # {% else %}
    # <div style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</div>
    # {% endif %}
    # ;;
    link: {
      label: "Drill Dashboard"
      url: "/dashboards-next/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"
    }
    link: {
      label: "Drill Explore"
      url:"/explore/lexi_bug_testing/order_items?fields=orders.status_with_links,users.age&f[orders.status_with_links]={{ value }}&f[orders.created_date]={{ _filters['orders.created_date'] | url_encode }}"
    }
    link: {
      label:"external dash"
      url: "https://master.dev.looker.com/dashboards/4303"
    }
    link: {
      label: "pivoted drill"
      url: "/explore/lexi_bug_testing/order_items?fields=orders.status_with_links,orders.count,orders.created_month_name&pivots=orders.status_with_links&fill_fields=orders.created_month_name&f[orders.status_with_links]={{ value }}&sorts=orders.status_with_links,orders.count+desc+0&limit=500&query_timezone=America%2FLos_Angeles&vis=%7B%7D&filter_config=%7B%22orders.status_with_links%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22cancelled%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%2C%22error%22%3Afalse%7D%5D%7D&origin=share-expanded"
    }
    # html:
    # <a href="/dashboards/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"</a> ;;
  }
  dimension: status{
    description: "this is my description"
    type:string
    sql:${TABLE}.status;;
      html:{% if value == 'cancelled' %}
      <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% elsif value == 'pending' %}
      <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% else %}
      <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
    {% endif %}
    ;;

  }

dimension: cancelled {
    type: yesno
    sql: ${status}='cancelled';;
  }
  measure: count_cancelled {
    type: count
    filters: [cancelled: "yes"]
  }

  dimension: status_sort {
  type: string
      case: {
        when: {
          sql: ${status} = "complete" ;;
          label: "complete"
        }
        when: {
          sql: ${status} = "cancelled" ;;
          label: "cancelled"
        }
        when: {
          sql: ${status} = "pending" ;;
          label: "pending"
        }
      }
    }


  dimension: user_id {
    type: number
    # hidden: yes
    sql: ${TABLE}.user_id ;;
  }

  measure: count_with_links {
    type: count
    link: {
      url:"/explore/lexi_bug_testing/order_items?fields=orders.count&f[orders.status]={{ orders.status._value }}&limit=500&column_limit=50&vis=%7B%7D&filter_config=%7B%22orders.status%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22%22%7D%2C%7B%7D%5D%2C%22id%22%3A2%7D%5D%7D&origin=share-expanded"
    }
    }
    measure: count {
      type: count
         # drill_fields: [drill_test*]
  }
set: drill_test {
  fields: [id, users.last_name, users.id, users.first_name, order_items.count]
}
}
