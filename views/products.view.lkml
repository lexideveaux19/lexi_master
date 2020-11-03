view: products {
  sql_table_name: demo_db.products ;;
  drill_fields: [id]

  dimension: id {
    primary_key: yes
    type: number
    sql: ${TABLE}.id ;;
  }

  dimension: brand {
    type: string
    sql: ${TABLE}.brand ;;
  }
measure: brand_distinct {
  type: count_distinct
  sql: ${brand} ;;
}
  dimension: category {
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

  dimension: tier_price {
    type: string
    sql: CASE WHEN ${retail_price} > 0 AND  ${retail_price} < 0.5 THEN "less than 0.5"
     WHEN ${retail_price} >= 0.5 AND  ${retail_price} < 1 THEN "less than 1"
    WHEN ${retail_price} >= 1 AND  ${retail_price} < 1.5 THEN "less than 1.5"
    WHEN ${retail_price} >= 1.5 AND  ${retail_price} < 2 THEN "less than 2"
    WHEN ${retail_price} >= 2 AND  ${retail_price} < 2.5 THEN "less than 2.5"
    WHEN ${retail_price} >= 2.5 AND  ${retail_price} < 3 THEN "less than 3"
    WHEN ${retail_price} >= 3 AND  ${retail_price} < 3.5 THEN "less than 3.5"
    WHEN ${retail_price} >= 3.5 AND  ${retail_price} < 4 THEN "less than 4"
    WHEN ${retail_price} >= 4 AND  ${retail_price} < 4.5 THEN "less than 4.5" ELSE "other" END;;
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
