connection: "thelook"
include: "/views/**/*.view"
include: "/dashboards/*.dashboard"

explore: order_items {
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }
}

explore: users {}
#test for derived one date filter for multiple explores
# include: "/views/orders.view"
# explore: test_a {
#   hidden: yes # IMPORTANT - keep explores hidden to avoid clutter
#   join: test_b {
#     sql_on: test_a.id = test_b.id ;;
#   }
#   join: test_c {
#     sql_on: test_a.id = test_c.id ;;
#   }
# }
# view: test_a  {
#   derived_table: {
#     sql:
#       SELECT id, created_at, status FROM demo_db.orders
#       WHERE {% condition ${test_a.master_date} %} created_at {% endcondition %}
#       GROUP BY 1,2,3
#       ;;
#   }
#   dimension: id {}
#   dimension_group: created_at_a {
#     type: time
#     sql: ${TABLE}.created_at ;;
#   }
#   dimension: status {}
#   filter: master_date {
#     type: date
#   }
# }
# view: test_b  {
#   derived_table: {
#     sql:
#       SELECT id, created_at, status FROM demo_db.orders
#       WHERE {% condition ${test_a.master_date} %} created_at {% endcondition %}
#       GROUP BY 1,2,3
#       ;;
#   }
#   dimension: id {}
#   dimension_group: created_at_b {
#     type: time
#     sql: ${TABLE}.created_at ;;
#   }
#   dimension: status {}
# }
# view: test_c  {
#   derived_table: {
#     sql:
#       SELECT id, created_at, status FROM demo_db.orders
#       WHERE {% condition ${test_a.master_date} %} created_at {% endcondition %}
#       GROUP BY 1,2,3
#       ;;
#   }
#   dimension: id {}
#   dimension_group: created_at_b {
#     type: time
#     sql: ${TABLE}.created_at ;;
#   }
#   dimension: status {}
# }
