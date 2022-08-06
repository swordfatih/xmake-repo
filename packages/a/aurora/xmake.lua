package("aurora")
    set_kind("library", {headeronly = true})
    set_homepage("http://www.bromeon.ch/libraries/aurora")
    set_description("Header-only library with unconventional C++ features, like deep-copy smart pointers, dynamic dispatch, type-erased ranges")

    add_urls("https://github.com/Bromeon/Aurora.git")

    on_install(function (package)
        os.cp("include/Aurora", package:installdir("include"))
    end)