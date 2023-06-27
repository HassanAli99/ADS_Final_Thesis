trainMLR <- function(input_table) {
  lm(
    formula = obs ~ .,
    data = input_table
  )
}