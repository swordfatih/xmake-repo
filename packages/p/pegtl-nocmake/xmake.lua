package("pegtl-nocmake")
    set_kind("library", {headeronly = true})
    set_homepage("https://github.com/taocpp/PEGTL")
    set_description("Parsing Expression Grammar Template Library")
    set_license("BSL-1.0")

    add_urls("https://github.com/taocpp/PEGTL.git")
    add_versions("3.2.7", "cf639f7f4ee125f68e1ccfba8d99ebc0de57b9fe")

    on_install(function (package)
        os.cp("include/tao", package:installdir("include"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            #include <tao/pegtl.hpp>
            namespace pegtl = TAO_PEGTL_NAMESPACE;
            void test(int argc, char *argv[]) {
                pegtl::argv_input in(argv, 1);
            }
        ]]}, {configs = {languages = "c++17"}}))
    end)