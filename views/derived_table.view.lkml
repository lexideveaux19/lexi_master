view: derived_table {
  derived_table: {
    sql:SELECT
          `users`.`state` AS `users.state`,
          `users`.`age` AS `users.age`,
              (DATE(CONVERT_TZ(`users`.`created_at`,'UTC','America/Los_Angeles'))) AS `users.created_date`
      FROM
          `demo_db`.`order_items` AS `order_items`
          LEFT JOIN `demo_db`.`orders` AS `orders` ON `order_items`.`order_id` = `orders`.`id`
          LEFT JOIN `demo_db`.`users` AS `users` ON `orders`.`user_id` = `users`.`id`

          WHERE  {% condition state_filter %} users.state {% endcondition %}
          AND  {% condition age_filter %} users.age {% endcondition %}

        AND {% condition my_date_filter %} (DATE(CONVERT_TZ(`users`.`created_at`,'UTC','America/Los_Angeles'))) {% endcondition %}
      GROUP BY
          1,
          2
      ORDER BY
        (DATE(CONVERT_TZ(`users`.`created_at`,'UTC','America/Los_Angeles'))) DESC
      LIMIT 500


      ;;
  }
  filter: my_date_filter {
    type: date
    suggest_dimension: users_created_date
  }
  parameter: timeframe_picker {
    label: "Date Granularity"
    type: string
    allowed_value: { value: "Week" }
    allowed_value: { value: "Month" }
    default_value: "Week"
  }


  measure: count {
    type: count
    drill_fields: [detail*]
  }

  filter: age_filter {
    type: number
    suggest_dimension: age
    # sql:  {% condition age_filter %} ${age} {% endcondition %} ;;
  }

  dimension_group: created {
    timeframes: [week,month]
    datatype:date
    sql: ${TABLE}.`users.created_date` ;;
  }


  dimension: dynamic_timeframe {
    type: string
    sql:
    CASE
    WHEN {% parameter timeframe_picker %} = 'Week' THEN ${orders.created_week}
    WHEN{% parameter timeframe_picker %} = 'Month' THEN ${orders.created_month}
    END ;;
  }

  dimension: users_created_date {
    type: date
    sql: ${TABLE}.`users.created_date` ;;
  }

  dimension: age {
    type: number
    sql: ${TABLE}.`users.age`;;
  }

filter: state_filter {
  type: string
  suggest_dimension: users_state
}



parameter: date_format {
  type: string
  allowed_value: { value: "US" }
  allowed_value: { value: "EU" }
}

  dimension: users_state {
    type: string
    sql: ${TABLE}.`users.state` ;;
  }

dimension: dynamic_date {
  label_from_parameter: date_format
sql: ${users_created_date};;
  html:
  {% if date_format._parameter_value == "'US'" %}
  {{ rendered_value | date: "%m/%d/%y"}}
  {% else %}
  {{ rendered_value | date: "%m/%d/%y"}}
  {% endif %}
  ;;
}


  set: detail {
    fields: [users_state, users_created_date]
  }
}
