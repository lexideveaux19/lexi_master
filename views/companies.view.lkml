view: companies {
  sql_table_name:@{schema_name_constant}.companies  ;;

 parameter: schema_filter {
    type: unquoted
    ### default_value can only be a string
    ### filter suggestions uses the default value
#     default_value: "crunchbase"
  allowed_value: {
    label: "crunchbase"
    value: "crunchbase"

  }
  allowed_value: {

    label: "crunchbase4"
    value: "crunchbase4"
  }
  }

  dimension: blog_url {
    type: string
    sql: ${TABLE}.blog_url ;;
  }

  dimension: category_code {
    type: string
    sql: ${TABLE}.category_code ;;
  }

  dimension_group: created {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.created_at ;;
  }

  dimension: crunchbase_url {
    type: string
    sql: ${TABLE}.crunchbase_url ;;
  }

  dimension: description {
    type: string
    sql: ${TABLE}.description ;;
  }

  dimension: email_address {
    type: string
    sql: ${TABLE}.email_address ;;
  }

  dimension_group: founded {
    type: time
    timeframes: [
      raw,
      date,
      week,
      month,
      quarter,
      year
    ]
    convert_tz: no
    datatype: date
    sql: ${TABLE}.founded_at ;;
  }

  dimension: full_record {
    type: yesno
    sql: ${TABLE}.full_record ;;
  }

  dimension: homepage_url {
    type: string
    sql: ${TABLE}.homepage_url ;;
  }

  dimension: name {
    type: string
    sql: ${TABLE}.name ;;
  }

  dimension: number_of_employees {
    type: number
    sql: ${TABLE}.number_of_employees ;;
  }

  dimension: overview {
    type: string
    sql: ${TABLE}.overview ;;
  }

  dimension: permalink {
    type: string
    sql: ${TABLE}.permalink ;;
  }

  dimension: phone_number {
    type: string
    sql: ${TABLE}.phone_number ;;
  }

  dimension: twitter_username {
    type: string
    sql: ${TABLE}.twitter_username ;;
  }


  dimension_group: updated {
    type: time
    timeframes: [
      raw,
      time,
      date,
      week,
      month,
      quarter,
      year
    ]
    sql: ${TABLE}.updated_at ;;
  }

  measure: count {
    type: count
    drill_fields: [name, twitter_username]
  }
}
