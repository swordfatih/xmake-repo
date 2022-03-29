package("oof")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/s9w/oof")
    set_description("Convenient, high-performance RGB color and position control for console output")

    add_urls("https://github.com/s9w/oof/archive/refs/tags/second.tar.gz")
    add_versions("second", "a8bf39e9e648ca34a85cd15d2b989d713b657bebc0674bde0c3594863c6da34b")

    on_install(function (package)
        os.cp("oof.h", package:installdir("include"))
    end)

