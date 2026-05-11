stopifnot(is.character(testpkg::hello()))
stopifnot(grepl("Package: testpkg", testpkg::hello()))
