package("thor")
    -- Meta 
    set_homepage("https://bromeon.ch/libraries/thor/")
    set_description("SFML Extension with various game programming features, like particles, animations, vector operations")

    add_urls("https://github.com/swordfatih/Thor.git")
    add_deps("sfml 2.6.1")

    add_versions("fork", "458d213151f2b305820e98c6b3e96be67d4ae953")
    add_versions("2.1", "3e320cb52606f0b44fd9d2bb272b3cb6d01d7f20")
    add_versions("2.0", "84f4821e49036dc71421e3f628386d2136d96756")

    -- Linking
    add_links("thor")

    -- Install
    on_install(function (package)
        local xmake_lua = [[
            add_requires("sfml 2.6.1") 
            add_requires("aurora master") 

            target("thor")
                set_kind("static")
                add_packages("sfml", "aurora") 

                add_includedirs("include")
                add_files("src/**.cpp")
        ]]

        -- Build Thor
        io.writefile("xmake.lua", xmake_lua);
        import("package.tools.xmake").install(package)

        -- Copy Thor include directory
        os.cp("include/Thor", package:installdir("include"))
        os.cp("extlibs/aurora/include/Aurora", package:installdir("include"))
    end)