package("cngui")
    -- Meta 
    set_homepage("https://github.com/swordfatih/CNGui")
    set_description("GUI Library using SFML and C++")

    add_urls("https://github.com/swordfatih/CNGui.git")
  
    -- Load
    on_load(function (package)
        -- Linking
        package:add("links", "cngui")
        
        -- Linking
        package:add("links", "sfml")

        -- Dependencies
        if is_host("linux") then
            if package:config("graphics") then
                package:add("deps", "freetype")
            end

            if package:config("window") or package:config("graphics") then
                package:add("deps", "libxrandr")
            end 

            if package:config("audio") then
                package:add("deps", "libogg", "libflac", "libvorbis", "openal-soft")
            end

            if package:config("network") then
                package:add("deps", "eudev")
            end
        elseif is_host("windows") then
            if package:config("graphics") then
                package:add("links", "freetype")
            end

            if package:config("window") or package:config("graphics") then
                package:add("syslinks", "opengl32", "gdi32", "user32", "advapi32")
            end 

            if package:config("audio") then 
                package:add("links", "openal32", "FLAC", "vorbisenc", "vorbisfile", "vorbis", "ogg")
                package:add("linkdirs", "extlibs/bin/" .. arch)
            end

            if package:config("network") then
                package:add("syslinks", "ws2_32")
            end

            package:add("syslinks", "winmm")
        end
    end)

    -- Install
    on_install(function (package)
        local xmake_lua = [[
            add_repositories("xrepo_fatih https://github.com/swordfatih/xmake-repo.git main")
            add_requires("sfml-nocmake 2.6.0", { configs = { audio = false, network = false } }) 

            target("cngui")
                -- Meta
                set_languages("c++17")
                set_kind("static")

                add_packages("sfml-nocmake") 

                add_includedirs("include")
                add_files("src/CNGui/**.cpp")
        ]]

        -- Build CNGui
        io.writefile("xmake.lua", xmake_lua);
        import("package.tools.xmake").install(package)

        -- Copy CNGui include directory
        os.cp("include/CNGui", package:installdir("include"))
    end)