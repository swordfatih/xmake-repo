package("taopq")
    -- Meta 
    set_homepage("https://github.com/taocpp/taopq")
    set_description("C++ client library for PostgreSQL")
    add_urls("https://github.com/taocpp/taopq.git")

    -- Versions
    add_versions("main", "03f35d3b21d096a94050a8fd910ea2d8fc0a56e2")
    add_versions("1.0.0", "21df9f398c5fa3f64aab76cbf316d33ce5eb2c92")

    -- Dependencies
    add_deps("cmake", "libpq")

    -- Load
    on_install(function (package)
        local configs = {}
        import("package.tools.cmake").install(package, configs)
    end)