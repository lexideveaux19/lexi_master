view: test {# If necessary, uncomment the line below to include explore_source.
# include: "lexi_bug_testing.model.lkml"

    derived_table: {
      explore_source: order_items {
        column: inventory_item_id {}
        column: order_id {}
      }
    }
    dimension: inventory_item_id {
      label: "this is my link"
      description: "https://google.com/"
      type: number

    }
    dimension: order_id {
      label: "this is my second link"
      type: number
    }
  }
