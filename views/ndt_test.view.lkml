# If necessary, uncomment the line below to include explore_source.
# include: "lexi_bug_testing.model.lkml"

view: ndt_test {
  derived_table: {
    explore_source: order_items {
      column: age { field: users.age }
      column: count { field: users.count }
      column: gender { field: users.gender }
      sorts: [users.gender: desc]
    }
  }
  dimension: age {
    type: number
  }
  dimension: count {
    type: number
  }
  dimension: gender {}
}
