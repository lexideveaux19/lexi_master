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


measure: yes_no {
  type: number
  sql: case when ${gender}="m" and ${count}>700 then 1 else 0 end  ;;
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
  measure: age_sum_distinct {
    type: sum
    sql_distinct_key: ${id} ;;
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
    drill_fields: [detail*]
  }

  measure:count_first_name{
    type: count_distinct
    sql: ${first_name} ;;
  }
  measure: count_distinct {
    type: count_distinct
    sql: concat(${first_name},${last_name}) ;;
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
