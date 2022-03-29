package("termcolor")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/ikalnytskyi/termcolor  ")
    set_description("Termcolor is a header-only C++ library for printing colored messages to the terminal.")

    add_urls("https://github.com/ikalnytskyi/termcolor.git")
    add_versions("b3cb0f3", "b3cb0f365f8435588df7a6b12a82b2ac5fc1fe95")

    on_install(function (package)
        os.cp("include", package:installdir("include"))
    end)

