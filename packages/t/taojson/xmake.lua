package("taojson")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/taocpp/json")
    set_description("taoJSON is a C++ header-only JSON library.")

    add_urls("https://github.com/taocpp/json.git")
    add_versions("main", "330129305f15fbfba5e0716db25e245f0b4d8b0f")

    on_install(function (package)
        os.cp("include/tao", package:installdir("include"))
    end)

