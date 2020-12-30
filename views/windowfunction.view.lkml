# view: windowfunction {
#     derived_table: {
#       sql: SELECT
#         DATE(CONVERT_TZ(order_items.returned_at ,'UTC','America/Los_Angeles')) AS `order_items.returned_date`,
#         DATE(CONVERT_TZ(orders.created_at ,'UTC','America/Los_Angeles')) AS `orders.created_date`,
#         order_items.sale_price  AS `order_items.sale_price`,

#       FROM demo_db.order_items  AS order_items
#       LEFT JOIN demo_db.orders  AS orders ON order_items.order_id = orders.id

#       GROUP BY 1,2,3,4
#       ORDER BY DATE(CONVERT_TZ(order_items.returned_at ,'UTC','America/Los_Angeles')) DESC
#       ;;
#     }

#     measure: count {
#       type: count
#       drill_fields: [detail*]
#     }

#     dimension: order_items_returned_date {
#       type: date
#       sql: ${TABLE}.`order_items.returned_date` ;;
#     }

#     dimension: orders_created_date {
#       type: date
#       sql: ${TABLE}.`orders.created_date` ;;
#     }

#     dimension: order_items_sale_price {
#       type: number
#       sql: ${TABLE}.`order_items.sale_price` ;;
#     }



#     set: detail {
#       fields: [order_items_returned_date, orders_created_date, order_items_sale_price, days_late]
#     }
#   }
