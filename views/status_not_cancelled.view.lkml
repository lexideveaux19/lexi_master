
view: status_not_cancelled {
  derived_table: {
    sql: SELECT
          `users`.`first_name` AS `users.first_name`,
          `users`.`id` AS `users.id`

      FROM
          `demo_db`.`order_items` AS `order_items`
          LEFT JOIN `demo_db`.`orders` AS `orders` ON `order_items`.`order_id` = `orders`.`id`
          LEFT JOIN `demo_db`.`users` AS `users` ON `orders`.`user_id` = `users`.`id`
         WHERE   {% condition status_filter %} orders.status {% endcondition %}

      GROUP BY
          1,
          2
      ORDER BY
          `users`.`first_name`
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }


  filter: status_filter {
    type: string
  }

  dimension: users_first_name {
    type: string
    sql: ${TABLE}.`users.first_name` ;;
  }

  dimension: users_id {
    type: number
    sql: ${TABLE}.`users.id` ;;
  }

  set: detail {
    fields: [users_first_name, users_id]
  }
}
