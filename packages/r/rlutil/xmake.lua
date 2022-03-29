package("rlutil")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/tapio/rlutil")
    set_description("C and C++ utilities for cross-platform console roguelike game creation")

    add_urls("https://github.com/tapio/rlutil.git")
    add_versions("821fdca", "821fdca0191b314ee07b0fad2abe4ea973e45575")

    on_install(function (package)
        os.cp("rlutil.h", package:installdir("include"))
    end)

