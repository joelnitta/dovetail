test_that("choosing returns name of docker image", {
  expect_equal(
    grepl("joelnitta/po4a", auto_choose_docker()),
    TRUE
  )
})
