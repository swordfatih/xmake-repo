package("cntity")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/swordfatih/CNtity")
    set_description("Helper library using C++ for an Entity Component System implementation")

    add_urls("https://github.com/swordfatih/CNtity.git")
    
    on_install(function (package)
        os.cp("include/CNtity", package:installdir("include"))
    end)