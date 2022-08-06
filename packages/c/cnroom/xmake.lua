package("cnroom")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/swordfatih/CNRoom")
    set_description("Header-only file based key-value database library using C++")

    add_urls("https://github.com/swordfatih/CNRoom.git")

    on_install(function (package)
        os.cp("include/CNRoom", package:installdir("include"))
    end)