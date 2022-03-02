view: users {

  sql_table_name: demo_db.users ;;
  drill_fields: [id]

  parameter: test_param {
    type: unquoted
  }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  filter: date_filter {
    type: date
    sql:  {% condition date_filter %} ${date_date} {% endcondition %}  ;;
  }


  dimension: date_date {
    sql: cast( ${TABLE}.created_at as date) ;;
    type: date
  }



filter: age_filter {
  type: number
  sql:  {% condition age_filter %} ${age} {% endcondition %};;
}
  dimension: age {
    type: number
    # label: "hours"
    sql: ${TABLE}.age ;;
    # html:
    # {% if value >0 and value <20 %}
    # <p style="color: red; font-size: 80%">{{ rendered_value }}</p>
    # {% elsif value >1000 %}
    # <p style="color: blue; font-size:80%">{{ rendered_value }}</p>
    # {% else %}
    # <p style="color: black; font-size:100%">{{ rendered_value }}</p>
    # {% endif %};;
  }
measure: agg_age {
  type: number
  sql: (${age}/(${age}*3)-1) ;;
}

  dimension: age_tier {
    type: tier
    tiers: [20, 30, 40, 50, 60, 70, 80]
    style:  integer
    sql: ${age} ;;
  }
measure: age_num {
  type: number
  sql: ${age} ;;
}

measure: age_min {
  type: min
  sql: ${age} ;;
}

measure: age_median {
  type: median
  sql: ${age} ;;
}
  measure: age_max {
    type: max
    sql: ${age} ;;
  }

  measure: age_sum{
    type: sum
    sql: ${age};;
  }

  measure: avg_wait_time {
    value_format: "mm:ss"
    type: average_distinct
    sql_distinct_key: ${id};;
    sql: ${age}/86400.0 ;;
  }

  measure: age_sum_distinct {
    type: sum
    sql_distinct_key: ${id} ;;
    sql: ${age} ;;
  }

  measure: age_avg_distinct {
    type: average_distinct
    sql_distinct_key: ${id} ;;
    # filters: [orders.status: "Cancelled"]
    sql: ${age} ;;
  }
  measure: age_sum_distinct_test {
    type: number
    sql: sum(distinct ${age}) ;;
  }

  dimension: city {
  label: "{{ users.country._value }}"
    type: string
    sql: ${TABLE}.city ;;
  }

  dimension: country {
    type: string
    map_layer_name: countries
    sql: ${TABLE}.country ;;
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
      fiscal_year
    ]
    sql:${TABLE}.created_at ;;
  }
  dimension: year_lexi_users {
    type: date_year
    sql:${TABLE}.created_at;;
  }

  # parameter: main_metric_selector {
  #   type: unquoted
  #   allowed_value: {
  #     label: "Total Revenue"
  #     value: "total_revenue"
  #   }
  #   allowed_value: {
  #     label: "Total Users"
  #     value: "total_users"
  #   }
  # }
  # measure: dynamic_measure {
  #   label_from_parameter: main_metric_selector
  #   sql:
  #   {% if main_metric_selector._parameter_value == 'total_revenue' %}
  #     ${age_max} AND ${age_median}
  #   {% else %}
  #     ${total_users}
  #   {% endif %};;
  # }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    html:<p style="font-size: 100%"; "font-family:'Times New Roman'">{{rendered_value}};;
  }

  dimension: first_name {
      type: string
    sql: ${TABLE}.first_name ;;
    # label: "{% if orders._in_query %} orders first name
    # {% else %} reg first name {% endif %}"
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
      html: {% if age._value >30 %}
              <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
            {% else %}
              <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
            {% endif %}
        ;;

    }

  dimension: last_name {
    type: string
  # label: "{{ users.gender._value }}"
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
    map_layer_name: us_states
    # label: "{{ users.last_name._value }}"

  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }
measure: gender_distinct {
  type: count_distinct
  sql: ${gender} ;;
}

  measure: count {
    type: count
    value_format_name: decimal_0
    drill_fields: [id, city, gender]
  }

  measure: count_with_state {
    type: count
    value_format_name: decimal_0
    drill_fields: [id, city, gender]
    html: Count <br> {{ rendered_value }} <br> State <br> {{ state._rendered_value }} ;;  ## here we use || to concatenate the values

  }

  measure:count_first_name{
    type: count_distinct
    sql: ${first_name} ;;
  }
  measure: count_distinct {
    type: count_distinct
    sql: concat(${first_name},${last_name}) ;;
}


# dimension_group: dynamic_date {
#   type: time
# sql: {% if gender_distinct._in_query %}
#   ${created_raw}
# {% else %}
#   ${order_items.returned_raw}
# {% endif %}
# ;;
# }

  dimension:link {
    type: string
    sql: "https://google.com" ;;
    link: {
      label: "{{ value }}"
      url: "{{ value }}"
    }
  }

  dimension:linkhtml {
    type: string
    sql: "https://google.com" ;;
    html:<a href="{{ value }}">{{ value }}</a>
;;
  }

  dimension: state_html {
    type: string
    sql: ${TABLE}.state ;;
    html: <a href="https://www.google.com/search?q={{ value }}">{{ value }}</a> ;;
  }

  dimension: state_link {
    type: string
    sql: ${TABLE}.state ;;
    link: {
      label: "Search {{ value }} state"
      url: "https://www.google.com/search?q={{ value }}"
    }
  }


  # ----- Sets of fields for drilling ------
  set: detail {
    fields: [
      id,
      last_name,
      first_name,
      events.count,
      orders.count,
      saralooker.count,
      user_data.count
    ]
  }
}
