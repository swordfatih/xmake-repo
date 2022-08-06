package("cntity")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/swordfatih/CNtity")
    set_description("Helper library using C++ for an Entity Component System implementation")

    add_urls("https://github.com/swordfatih/CNtity.git")
    add_versions("master", "dc52e9680b68b12e003c36842b12c6aadde99eac")

    on_install(function (package)
        os.cp("cntity", package:installdir("include"))
    end)