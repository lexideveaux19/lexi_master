connection: "thelook"

# include all the views
include: "/views/**/*.view"
include: "/dashboards/*.dashboard.lookml"
datagroup: lexi_bug_testing_default_datagroup {
  # sql_trigger: SELECT MAX(id) FROM etl_log;;
  max_cache_age: "1 hour"
}

persist_with: lexi_bug_testing_default_datagroup

# explore: ndt {
  # join: orders {
  #   type: left_outer
  # sql_on: ${orders.user_id}=${ndt.user_id} ;;
  # relationship: many_to_one
  # }
explore: ndt_test {}
explore: sql_runner_query {}
explore: currency {}
explore: flights {}
explore: test {}
explore: companies {
  sql_always_where: ${companies.founded_date} >= '2007-01-01'  ;;
}

explore: order_items_liquid_2 {
  view_name: order_items
  join: orders {
    relationship: many_to_one
    sql_on:
    {% if _user_attributes['lex_dynamic_sql']=="Yes" %}
      ${orders.id} = ${order_items.order_id}
      {% else %}
      ${orders.created_raw} = ${order_items.returned_raw}
      {% endif %}
       ;;
  }
}

explore: events {
  # hidden: yes
  join: users {
    type: left_outer
    sql_on: ${events.user_id} = ${users.id} ;;
    relationship: many_to_one
  }
}

explore: derived_table {}

explore: inventory_items {
  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}
# explore: order_items_2{
#   from: order_items
#   join: orders {
#     # view_label: ""
#     type: left_outer
#     sql_on: ${order_items_2.order_id} = ${orders.id} ;;
#     # fields: [orders.id]
#     relationship: many_to_one
#   }
#   join: inventory_items {
#     type: left_outer
#     view_label: ""
#     sql_on: ${order_items_2.inventory_item_id} = ${inventory_items.id} ;;
#     fields: [inventory_items.id]
#     relationship: many_to_one
#   }
# }
explore: order_items {
  # always_filter: {
  #   filters: [orders.status: "-cancelled"]
  # }
  join: orders {
    type: left_outer
    sql_on: ${order_items.order_id} = ${orders.id} ;;
    relationship: many_to_one
  }

  join: inventory_items {
    # view_label: "Orders"
    type: left_outer
    sql_on: ${order_items.inventory_item_id} = ${inventory_items.id} ;;
    relationship: many_to_one
  }

  join: users {
    type: left_outer
    sql_on: ${orders.user_id} = ${users.id} ;;
    relationship: many_to_one
  }

  join: products {
    type: left_outer
    sql_on: ${inventory_items.product_id} = ${products.id} ;;
    relationship: many_to_one
  }
}



  explore: users_sqldt{}
