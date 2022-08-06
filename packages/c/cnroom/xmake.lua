package("cnroom")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/swordfatih/CNRoom")
    set_description("Header-only file based key-value database library using C++")

    add_urls("https://github.com/swordfatih/CNRoom.git")
    add_versions("ebf42a", "ebf42a52eba3ca7719eef0f8480dac498f3ffc96")

    on_install(function (package)
        os.cp("cnroom", package:installdir("include"))
    end)