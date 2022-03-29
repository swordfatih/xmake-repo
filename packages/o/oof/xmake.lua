package("oof")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/s9w/oof")
    set_description("C and C++ utilities for cross-platform console roguelike game creation")

    add_urls("https://github.com/s9w/oof.git")
    add_versions("c7b7c10", "c7b7c1011c2fc8c4f0dd2d7c40a626e9ce965e33")

    on_install(function (package)
        os.cp("oof.h", package:installdir("include"))
    end)

