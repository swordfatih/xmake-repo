package("cngui")
    -- Meta 
    set_homepage("https://github.com/swordfatih/CNGui")
    set_description("GUI Library using SFML and C++")

    add_urls("https://github.com/swordfatih/CNGui.git")
    add_deps("sfml-nocmake 2.6.0")
  
    -- Linking
    add_links("cngui")

    -- Install
    on_install(function (package)
        local xmake_lua = [[
            add_repositories("xrepo_fatih https://github.com/swordfatih/xmake-repo.git main")
            add_requires("sfml-nocmake 2.6.0") 

            target("cngui")
                -- Meta
                set_languages("c++17")
                set_kind("static")

                add_packages("sfml-nocmake") 

                add_includedirs("include")
                add_files("src/CNGui/**.cpp")
        ]]

        -- Build CNGui
        io.writefile("xmake.lua", xmake_lua)
        import("package.tools.xmake").install(package)

        -- Copy CNGui include directory
        os.cp("include/CNGui", package:installdir("include"))
    end)