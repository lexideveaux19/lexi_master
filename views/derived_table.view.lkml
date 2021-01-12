view: derived_table {
  derived_table: {
    sql: SELECT
        users.state  AS `users.state`,
        DATE(users.created_at ) AS `users.created_date`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id

       WHERE  {% condition state_filter %} users.state {% endcondition %} AND
        {% condition my_date_filter %}  DATE(users.created_at ) {% endcondition %}
        AND {% condition users_state %} users.state {% endcondition %}


      GROUP BY 1,2
      ORDER BY DATE(users.created_at ) DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

filter: my_date_filter {
  type: date
  suggest_dimension: users_created_date
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

  dimension: users_created_date {
    type: date
    sql: ${TABLE}.`users.created_date` ;;
  }

  set: detail {
    fields: [users_state, users_created_date]
  }
}
