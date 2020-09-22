# If necessary, uncomment the line below to include explore_source.
# include: "lexi_bug_testing.model.lkml"

view: ndt {
  derived_table: {
    explore_source: orders{
      column: user_id { field: orders.user_id }
      column: count { field: orders.count }
      column: status { field: orders.status}
      # filters: {
      #   field: orders.status_filter
      #   value: ""
      # }
      bind_filters: {
        to_field: orders.status
        from_field: orders.status_filter
      }

    }
  }
  dimension: user_id {
    type: number
  }
  dimension: count {
    type: number
  }
}
