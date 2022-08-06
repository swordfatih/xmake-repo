package("stduuid")
    set_kind("library", {headeronly = true})
    set_languages("c++20")
    
    set_homepage("https://github.com/mariusbancila/stduuid")
    set_description("A C++17 cross-platform implementation for UUIDs")

    add_urls("https://github.com/mariusbancila/stduuid.git")
    add_versions("master", "3afe7193facd5d674de709fccc44d5055e144d7a")

    on_install(function (package)
        os.cp("include/*.h", package:installdir("include"))
    end)