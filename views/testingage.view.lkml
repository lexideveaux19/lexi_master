view: testingage {
    derived_table: {
      sql: SELECT
        users.id  AS `users.id`,
        users.age  AS `users.age`,
        users.age  AS `users.age_num`,
        MAX(users.age ) AS `users.age_max`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id

      GROUP BY 1,2
      ORDER BY users.age
      LIMIT 500
       ;;
    }

    measure: count {
      type: count
      drill_fields: [detail*]
    }

    dimension: users_id {
      type: number
      sql: ${TABLE}.`users.id` ;;
    }

    dimension: users_age {
      type: number
      sql: ${TABLE}.`users.age` ;;
    }

 measure: useragenum{
      type: sum
      sql: ${users_age} ;;
    }



    set: detail {
      fields: [users_id, users_age, ]
    }
  }
