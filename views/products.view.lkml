view: products {
  sql_table_name: demo_db.products ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    group_label: "Test"
    group_item_label: "Bran"
    label: "Test Bran"
    type: string
    sql: ${TABLE}.brand ;;
  }

  dimension: category {
    group_label: "Test"
    group_item_label: "Cat"
    type: string
    sql: ${TABLE}.category ;;
    drill_fields: [rank]
  }

  dimension: department {
    type: string
    sql: ${TABLE}.department ;;
  }

  filter: department_filter {
    type: string
    suggest_dimension: products.department
    sql: {% condition department_filter %} ${department} {% endcondition %} ;;
  }

  dimension: item_name {
    type: string
    sql: ${TABLE}.item_name ;;
  }

  dimension: rank {
    type: number
    sql: ${TABLE}.rank ;;
  }

  dimension: retail_price {
    type: number
    sql: ${TABLE}.retail_price ;;
  }

  dimension: sku {
    type: string
    sql: ${TABLE}.sku ;;
  }

  measure: count {
    type: count
    drill_fields: [id, item_name, inventory_items.count]
  }
}
