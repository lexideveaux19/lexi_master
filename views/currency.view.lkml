view: currency {
  derived_table:{
 sql: SELECT 98765432.23 as val, 'USD' as currency
UNION ALL
SELECT 456789.56 as val, 'EUR' as currency
UNION ALL
SELECT 86753.09 as val, 'SFr.' as currency;;}


dimension: currency{
sql: ${TABLE}.currency;;}

measure: currency_symbol{
type: string
sql:
CASE
WHEN ${currency} = 'USD' THEN '$'
WHEN ${currency} = 'EUR' THEN '£'
ELSE CONCAT(${currency}, ' ')
END;;}


measure: formatted_amount{
type: sum
html:  {{ currency_symbol._value }}{{ rendered_value }};;
sql: ${TABLE}.val;;
}

# measure: usd_amount{
# type: sum
#   sql:

#   CASE

#   WHEN ${currency} = 'USD' THEN 1.0 * ${formatted_amount}

#   WHEN ${currency} = 'EUR' THEN 1.09 * ${formatted_amount}

#   WHEN ${currency} = 'JPY' THEN 0.008 * ${formatted_amount}

#   WHEN ${currency} = 'CHF' THEN 1.02 * ${formatted_amount}

#   ELSE NULL

#   END;;}

  }
