package("libpq")
    -- Meta 
    set_homepage("https://www.postgresql.org/docs/16/libpq.html")
    set_description("Postgres C API library")
    set_license("PostgreSQL")

    add_urls("https://github.com/postgres/postgres.git")
    add_versions("main", "258cef12540fa1cb244881a0f019cefd698c809e")

    -- Linking
    add_links("libpq")

    -- Load
    on_install(function (package)
        os.cd("src")
        import("package.tools.nmake").install(package, {"/f", "win32.mak"})
    end)