view: orders {
      sql_table_name: demo_db.orders ;;
    drill_fields: [id]

    dimension: id {
      primary_key: yes
      type: number
      sql: ${TABLE}.id ;;
    }

    parameter: date_granularity {
      type: string
      allowed_value: { value: "Day" }
      allowed_value: { value: "Month" }
      allowed_value: { value: "Quarter" }
      allowed_value: { value: "Year" }
    }


  dimension: date {
    label_from_parameter: date_granularity
    sql:
            CASE
             WHEN {% parameter date_granularity %} = 'Day' THEN ${created_date}
             WHEN {% parameter date_granularity %} = 'Month' THEN ${created_month}
             WHEN {% parameter date_granularity %} = 'Quarter' THEN ${created_quarter}
             WHEN {% parameter date_granularity %} = 'Year' THEN ${created_year}
             ELSE NULL
            END ;;
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
dimension: year_lexi_orders {
  type: date_year
sql:  ${TABLE}.created_at;;
}
    dimension_group: today {
      type: time
      timeframes: [
        raw,
        time,
        date,
        week,
        month,
        quarter,
        hour_of_day,
        year
      ]
      sql:  CURRENT_TIMESTAMP() ;;
    }

dimension_group: since_selected {
  type: duration
  intervals: [hour,day,week]
  sql_start: {% date_start created_date %} ;;
  sql_end: {% date_end created_date %}  ;;
}

dimension: per_hour {
  type: number
  sql:
  CASE WHEN ${days_since_selected}='1'
  THEN CASE WHEN DATE({% date_start created_date %})=${today_date}
  THEN ${today_hour_of_day}
  else '24' end
  else ${hours_since_selected}
  end;;
}

    dimension: status {
      type: string
      sql: ${TABLE}.status ;;
      link: {
        label: "test lex"
        url: "/dashboards-next/5645?Status={{ value }}&Date={{ _filters['orders.year_lexi_orders'] | url_encode }}"
      }
    }
  dimension: looker_image {
    type: string
    sql: ${status};;
    html: <img src="https://logo-core.clearbit.com/looker.com" /> ;;
  }
    dimension: user_id {
      type: number
      # hidden: yes
      sql: ${TABLE}.user_id ;;
    }

    measure: count {
      type: count
      drill_fields: [id, users.id, users.first_name, users.last_name, order_items.count]
    }
  }


#   sql_table_name: demo_db.orders ;;


#   dimension: id {
#     primary_key: yes
#     type: number
#     sql: ${TABLE}.id ;;
#   }

# dimension_group: duration {
# label: "24-hour days duration"
# type: duration
# sql_start: ${created_date};;
# sql_end: coalesce(${order_items.returned_date}, now()) ;;
# intervals: [hour]
# }

# dimension: duration_8 {
#   label: "business day hours"
#   sql:  concat(round((${hours_duration}/24)*8,1), " hours") ;;
#   # value_format: "string"
# }

# measure: count_month {
#   type: sum
#   sql: case when ${created_month} IS NOT NULL then 1 else 0 end ;;
# }

#   parameter: timeframe_picker {
#     label: "Date Granularity"
#     type: string
#     allowed_value: { value: "Date" }
#     allowed_value: { value: "Week" }
#     allowed_value: { value: "Month" }
#     default_value: "Month"
#   }

#   dimension: dynamic_timeframe {
#     type: date
#     sql:
#     CASE
#     WHEN {% parameter timeframe_picker %} = 'Date' THEN ${orders.created_date}
#     WHEN {% parameter timeframe_picker %} = 'Week' THEN ${orders.created_week}
#     WHEN{% parameter timeframe_picker %} = 'Month' THEN ${orders.created_month}
#     END ;;
#     html: {% if timeframe_picker._parameter_value == "'Month'" %}
#           {{ created_month_name._value }}
#           {% else %}
#           {{rendered_value}}
#           {% endif %}
#           ;;
#   }

#   dimension: dynamic_timeframe_test {
#     type: string
#     sql:
#     CASE
#     WHEN {% parameter timeframe_picker %} = 'Date' THEN ${orders.created_date}
#     WHEN {% parameter timeframe_picker %} = 'Week' THEN ${orders.created_week}
#     WHEN{% parameter timeframe_picker %} = 'Month' THEN ${orders.created_month_name}
#     END ;;
# }

# dimension: created_month {
#   type: date
#   group_label: "Created Date"
#   sql: concat((DATE_FORMAT(${TABLE}.created_at, '%Y-%m')), '-01');;
# }

#   dimension_group: created {
#     type: time
#     timeframes: [
#       raw,
#       time,
#       date,
#       week,
#       quarter,
#       fiscal_year,
#       day_of_month,
#       day_of_week,
#       time_of_day,
#       hour_of_day,
#       day_of_week_index,
#       year,
#       month_name
#     ]
#     sql: ${TABLE}.created_at ;;
#   }

# dimension: created_month_test {
#   type: date
#   sql: ${created_month} ;;
#   html: {{ rendered_value }} || {{ created_day_of_week._rendered_value }}  ;;
# }



# dimension: created_convert {
#   type: date
#   convert_tz: no
#   sql:CONVERT_TZ(${TABLE}.created_at ,'America/Los_Angeles','UTC');;
# }


# dimension: week_end {
#   type: date
#   sql: DATE_ADD(${created_week}, INTERVAL 6 DAY);;
# }

#   dimension: fiscal_year {
#     type: string
#     sql: CAST(${created_fiscal_year} as CHAR) ;;
#   }

#   dimension: time_of_day_number{
#     type: number
#     sql: cast(${created_time_of_day} as decimal(4,2)) ;;
#     value_format_name: decimal_2
#   }

#   filter: status_filter {
#     type: string
#     suggest_dimension: orders.status
#     default_value: "-cancelled"
#     sql: {% condition status_filter %} ${status} {% endcondition %} ;;
#   }

#   dimension: status_satisfies_filter {
#     type: yesno
#     hidden: yes
#     sql: {% condition status_filter %} ${status} {% endcondition %} ;;
#   }

#   measure: count_dynamic_status {
#     type: count
#     filters: {
#       field: status_satisfies_filter
#       value: "yes"
#     }
#   }

# #   # dimension: link_field {
# #   #   label: "Link"
# #   #   link: {
# #   #     label: "Link to dashboard"
# #   #     url: "/dashboards-next/4304?Status={{ _filters['orders.status'] }}&Category={{ _filters['products.category._value'] }}"
# #   #   }
# #   #   sql: 'dashboard';;
# #   # }

#   dimension: created_one_day {
#     type: date
#     sql:DATE_ADD(${created_date}, INTERVAL 1 day);;
#   }

#   dimension: status_with_links {
#     type: string
#     sql:CASE
#   WHEN ${TABLE}.status = 'cancelled' THEN 'cancelled +'
#   WHEN ${TABLE}.status = 'complete' THEN 'complete +'
#   WHEN ${TABLE}.status = 'pending' THEN 'pending +'
#   ELSE null
#   END   ;;
#     # html: {% if value == 'cancelled' %}
#     # <div class="vis-single-value"  style="margin:0; padding:0; border-radius:0; color: black; background-color: lightblue; text-align:center">{{ rendered_value }}</div>
#     # {% elsif value == 'complete' %}
#     # <div style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</div>
#     # {% else %}
#     # <div style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</div>
#     # {% endif %}
#     # ;;
#     link: {
#       label: "Drill Dashboard"
#       url: "/dashboards-next/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"
#     }
#     link: {
#       label: "Drill Explore"
#       url:"/explore/lexi_bug_testing/order_items?fields=orders.status_with_links,users.age&f[orders.status_with_links]={{ value }}&f[products.department]={{ products.department._value }}&f[orders.created_date]={{ _filters['orders.created_date'] }}"
#     }
#     link: {
#       label:"external dash"
#       url: "https://master.dev.looker.com/dashboards/4303"
#     }
#     link: {
#       label: "pivoted drill"
#       url: "/explore/lexi_bug_testing/order_items?fields=orders.status_with_links,orders.count,orders.created_month_name&pivots=orders.status_with_links&fill_fields=orders.created_month_name&f[orders.status_with_links]={{ value }}&sorts=orders.status_with_links,orders.count+desc+0&limit=500&query_timezone=America%2FLos_Angeles&vis=%7B%7D&filter_config=%7B%22orders.status_with_links%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22cancelled%22%7D%2C%7B%7D%5D%2C%22id%22%3A0%2C%22error%22%3Afalse%7D%5D%7D&origin=share-expanded"
#     }
#     # html:
#     # <a href="/dashboards/4304?Status={{ value }}&Category={{ products.category._value }}&Date={{ _filters['orders.created_date'] | url_encode }}"</a> ;;
#   }

#   dimension: status{
#     description: "this is my description"
#     type:string
#     sql:${TABLE}.status;;
#       html:
#       <a href="#drillmenu" target="_self">
#       {% if value == 'cancelled' %}
#       <p style="color: black; background-color: lightblue; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% elsif value == 'pending' %}
#       <p style="color: black; background-color: lightgreen; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% else %}
#       <p style="color: black; background-color: orange; font-size:100%; text-align:center">{{ rendered_value }}</p>
#     {% endif %}
#     </a>;;
# drill_fields: [users.name]
#   }

# parameter:status_param{
#   type: string
#   allowed_value: {
#     value: "complete"
#   }
#   allowed_value: {
#     value: "cancelled"
#   }
# }

# dimension: status_with_param {
#   type: yesno
#   sql:
#   CASE
#   WHEN {% parameter status_param %} = 'complete' THEN ${status}='complete' OR ${status}='pending'
#   WHEN {% parameter status_param %} = 'cancelled' THEN ${status}='cancelled'
# ELSE null
#   END ;;
# }

# dimension: status_combine {
#   type: string
#   sql: case when ${status}='complete' OR ${status}='pending' THEN 'complete' ELSE 'cancelled' END ;;
# }

#   dimension: status_combine_lookml {
#     type: string
#     case: {
#       when: {
#         sql: ${TABLE}.status = 'complete' ;;
#         label: "complete"
#       }
#       when: {
#         sql: ${TABLE}.status = 'pending' ;;
#         label: "complete"
#       }
#       when: {
#         sql: ${TABLE}.status = 'cancelled' ;;
#         label: "cancelled"
#       }
#     }
#   }

# dimension: cancelled {
#     type: yesno
#     sql: ${status}='cancelled';;
#   }

#   measure: count_cancelled {
#     type: count
#     filters: [cancelled: "yes"]
#   }


#   dimension: status_sort {
#   type: string
#       case: {
#         when: {
#           sql: ${status} = "complete" ;;
#           label: "complete"
#         }
#         when: {
#           sql: ${status} = "cancelled" ;;
#           label: "cancelled"
#         }
#         when: {
#           sql: ${status} = "pending" ;;
#           label: "pending"
#         }
#       }
#     }


#   dimension: rating_icon {
#     label: "rating icon🌟"
#     type: string
#     sql: ${status} ;;
#     html:
#       {% if status._value == "complete" %}     <p style="text-align: left"><img src="https://jds-explore.com/wp-content/uploads/2021/02/Star1-e1613746198162.png"></p>
#       {% elsif status._value == "pending" %}  <p style="text-align: left"><img src="https://jds-explore.com/wp-content/uploads/2021/02/Star2-e1613746181409.png"></p>
#       {% elsif status._value == "cancelled" %}  <p style="text-align: left"><img src="https://jds-explore.com/wp-content/uploads/2021/02/Star3-e1613746160773.png"></p>
#       {% endif %} ;;
#   }

# dimension: new {
#   type: string
#   sql:
#   <svg width="40" height="40" viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg">
# <path d="M34.7222 8.22255C32.2044 7.55056 29.7447 6.67738 27.3667 5.61144C25.0272 4.59656 22.7687 3.4042 20.6111 2.04477L20 1.66699L19.4 2.05588C17.2424 3.41531 14.984 4.60768 12.6445 5.62255C10.2626 6.68526 7.79907 7.55473 5.27779 8.22255L4.44446 8.43366V17.7003C4.44446 32.5781 19.4778 38.1448 19.6222 38.2003L20 38.3337L20.3778 38.2003C20.5333 38.2003 35.5556 32.5892 35.5556 17.7003V8.43366L34.7222 8.22255ZM33.3334 17.7003C33.3334 29.9225 22.2222 35.0448 20 35.9559C17.7778 35.0448 6.66668 29.9114 6.66668 17.7003V10.1559C9.01054 9.48206 11.3049 8.64673 13.5333 7.65588C15.7619 6.69254 17.9225 5.57886 20 4.32255C22.0776 5.57886 24.2381 6.69254 26.4667 7.65588C28.6951 8.64673 30.9895 9.48206 33.3334 10.1559V17.7003Z" fill="#469F3D"/>
# <path d="M12.089 18.744C11.8764 18.562 11.603 18.4669 11.3234 18.4777C11.0437 18.4885 10.7784 18.6044 10.5806 18.8023C10.3827 19.0002 10.2668 19.2654 10.256 19.5451C10.2452 19.8247 10.3403 20.0981 10.5223 20.3107L17.189 26.9773L29.3334 15.2996C29.5456 15.0933 29.6671 14.8112 29.6713 14.5153C29.6755 14.2194 29.5619 13.934 29.3556 13.7218C29.1494 13.5096 28.8672 13.3881 28.5713 13.3839C28.2755 13.3797 27.99 13.4933 27.7779 13.6996L17.2556 23.9107L12.089 18.744Z" fill="#469F3D"/>
# </svg> <font color="#469F3D" size = "4"> <b>You are protected.</b> </font><font color="#469F3D" size = "4">Enhanced Perimeter Security is actively monitoring your site.</font>;;
# }

# }

#   dimension: user_id {
#     type: number
#     # hidden: yes
#     sql: ${TABLE}.user_id ;;
#   }

# #   measure: count_with_links {
# #     type: count
# #     link: {
# #       url:"/explore/lexi_bug_testing/order_items?fields=orders.count&f[orders.status]={{ orders.status._value }}&limit=500&column_limit=50&vis=%7B%7D&filter_config=%7B%22orders.status%22%3A%5B%7B%22type%22%3A%22%3D%22%2C%22values%22%3A%5B%7B%22constant%22%3A%22%22%7D%2C%7B%7D%5D%2C%22id%22%3A2%7D%5D%7D&origin=share-expanded"
# #     }
# #     }
#     measure: count {
#       type: count
#       value_format_name: decimal_0
#           # drill_fields: [drill_test*]
#   }

#   measure: testing_percent {
#     type: number
#     value_format_name: decimal_2
#     sql: ${count}/${users.count} ;;
#   }
# }
