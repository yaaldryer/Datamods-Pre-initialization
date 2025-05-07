# Datamods-Pre-initialization
A minimal reprex for preemptively initializing a datamods table in an R Shiny app with multiple tabs

# Background
When using a datamods table in R Shiny, the table's UI needs to be initialized before the data in the table is usuable. This poses a problem when you have a Shiny app that has a datamods table in a tab that isn't initially selected, or that isn't always going to be visited by the user. This example servers to provide a solution to this problem. I've also provided a more general, modularized approach that can be used with UI elements other than only a datamods table.
