view: users_sqldt {
    derived_table: {
      sql: SELECT
        * from demo_db.users
      where
      {% if state_param._parameter_value == "'all states'" %}
      1=1
      {% elsif state_param._parameter_value == "'NYC Area only'" %}
      users.state IN ('New York', 'Pennsylvania', 'New Jersey', 'Connecticut' )
      {% elsif state_param._parameter_value == "'non-NYC Area only'" %}
      users.state NOT IN ('New York', 'Pennsylvania', 'New Jersey', 'Connecticut' )
      {% endif %}
      ;;
    }
    drill_fields: [id]


    filter: state_filter {
      type: string
    }


    dimension: state {
      type: string
      sql:  ${TABLE}.state ;;
    }


    parameter: state_param {
      label: "State Parameter"
      type:  string
      allowed_value: {value: "all states" }
      allowed_value: {value: "NYC Area only" }
      allowed_value: {value: "non-NYC Area only" }
      default_value: "all states"
    }

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
    tags: ["user_id"]
  }

  dimension: age {
    type: number
    sql: ${TABLE}.age ;;
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
    tags: ["email"]
  }

  dimension: first_name {
    type: string
    sql: ${TABLE}.first_name ;;
  }

#   commented out while testing https://looker.atlassian.net/browse/DD-1160
#   https://master.dev.looker.com/looks/10726
#
#   dimension: gender {
#     type: string
#     sql: ${TABLE}.gender ;;
#   }

  dimension: last_name {
    type: string
    sql: ${TABLE}.last_name ;;
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
      first_name,
      last_name ]
#       events.count,
#       orders_test.count,
#       user_data.count
#     ]
    }

    dimension: deantest {
      type:  string
      sql: ${TABLE}.deantest ;;
    }
    }
