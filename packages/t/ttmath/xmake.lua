package("ttmath")
    set_kind("library", {headeronly = true})
    set_homepage("https://gitea.ttmath.org/tomasz.sowa/ttmath")
    set_description("Library which allows one to perform arithmetic operations")

    add_urls("https://gitea.ttmath.org/tomasz.sowa/ttmath/archive/0.9.3.tar.gz")
    add_versions("0.9.3", "a2f947a81dd65d9cec9dc55ecf577d79826257a0984895c2b82d847d64e97717")

    on_install(function (package)
        os.cp("ttmath", package:installdir("include"))
    end)

