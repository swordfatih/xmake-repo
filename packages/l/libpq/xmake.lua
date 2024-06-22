package("libpq")
    -- Meta 
    set_homepage("https://www.postgresql.org/docs/16/libpq.html")
    set_description("Postgres C API library")
    set_license("PostgreSQL")

    add_urls("https://github.com/postgres/postgres/archive/refs/tags/REL_$(version).tar.gz", {alias = "github", version = function (version)
        return version:gsub("%.", "_")
    end})
    
    add_versions("16.3", "dcb3fac1ed875e75bd939aa9636264977e56f35b4429418450309bc646409aff")
    add_versions("14.1", "14809c9f669851ab89b344a50219e85b77f3e93d9df9e255b9781d8d60fcfbc9")

    -- Linking
    add_links("libpq")

    -- Load
    on_install(function (package)
        os.cd("src")
        import("package.tools.nmake").install(package, {"/f", "win32.mak"})
    end)