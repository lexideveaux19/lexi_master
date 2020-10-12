view: users {
  sql_table_name: demo_db.users ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: age {
    type: number
    # label: "hours"
    sql: ${TABLE}.age ;;
    html:
    {% if value >0 and value <20 %}
    <p style="color: red; font-size: 80%">{{ rendered_value }}</p>
    {% elsif value >1000 %}
    <p style="color: blue; font-size:80%">{{ rendered_value }}</p>
    {% else %}
    <p style="color: black; font-size:100%">{{ rendered_value }}</p>
    {% endif %};;
  }
  dimension: age_tier {
    type: tier
    tiers: [0, 10, 20, 30, 40, 50, 60, 70, 80]
    style:  integer
    sql: ${age} ;;
  }

  dimension: city {
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
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: email {
    type: string
    sql: ${TABLE}.email ;;
    html:<p style="font-size: 100%"; "font-family:'Times New Roman'">{{rendered_value}};;
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

  dimension: gender {
    type: string
    sql: ${TABLE}.gender ;;
  }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
  }

  dimension: state {
    type: string
    sql: ${TABLE}.state ;;
  }

  dimension: zip {
    type: zipcode
    sql: ${TABLE}.zip ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
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
