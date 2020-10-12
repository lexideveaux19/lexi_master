view: sql_runner_query {
  derived_table: {
    sql: SELECT
        products.brand  AS `products.brand`,
        DATE_FORMAT(CONVERT_TZ(users.created_at ,'UTC','America/Los_Angeles'),'%Y-%m') AS `users.created_month`,
        products.retail_price  AS `products.retail_price`,
        COUNT(DISTINCT products.id ) AS `products.count`,
        COUNT(DISTINCT users.id ) AS `users.count`
      FROM demo_db.order_items  AS order_items
      LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id
      LEFT JOIN demo_db.inventory_items  AS inventory_items ON order_items.inventory_item_id = inventory_items.id
      LEFT JOIN demo_db.users  AS users ON orders.user_id = users.id
      LEFT JOIN demo_db.products  AS products ON inventory_items.product_id = products.id

      WHERE
        (((users.created_at ) >= (CONVERT_TZ(TIMESTAMP('2019-10-01'),'America/Los_Angeles','UTC')) AND (users.created_at ) < (CONVERT_TZ(TIMESTAMP('2019-12-01'),'America/Los_Angeles','UTC'))))
      GROUP BY 1,2,3
      ORDER BY DATE_FORMAT(CONVERT_TZ(users.created_at ,'UTC','America/Los_Angeles'),'%Y-%m') DESC
      LIMIT 500
       ;;
  }

  measure: count {
    type: count
    drill_fields: [detail*]
  }

  dimension: products_brand {
    type: string
    sql: ${TABLE}.`products.brand` ;;
  }

  dimension: users_created_month {
    type: string
    sql: ${TABLE}.`users.created_month` ;;
  }

  dimension: products_retail_price {
    type: number
    sql: ${TABLE}.`products.retail_price` ;;
  }

  measure: products_count {
    type: number
    sql: ${TABLE}.`products.count` ;;
  }

  measure: users_count {
    type: number
    sql: ${TABLE}.`users.count` ;;
  }

  set: detail {
    fields: [products_brand, users_created_month, products_retail_price, products_count, users_count]
  }
}
