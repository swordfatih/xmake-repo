package("stduuid")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/mariusbancila/stduuid")
    set_description("A C++17 cross-platform implementation for UUIDs")

    add_urls("https://github.com/mariusbancila/stduuid.git")

    on_install(function (package)
        os.cp("include/*.h", package:installdir("include"))
    end)