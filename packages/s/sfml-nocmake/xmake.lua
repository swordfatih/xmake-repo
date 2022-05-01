package("sfml-nocmake")
    -- Meta 
    set_homepage("https://www.sfml-dev.org")
    set_description("Simple and Fast Multimedia Library")

    add_urls("https://github.com/SFML/SFML.git")
    
    -- Versions
    add_versions("master", "3ae833cb8f439177208ad9bd8dbcb6b7a4bd3f3e384d5854e4674debe3b30ae2f6cf9d9926738789")
    add_versions("2.6.0", "33cb8f439177208ad9bd8dbcb6b7a4bd3f3e384d")

    -- Defines
    add_defines("SFML_STATIC")

    -- Configs
    option("graphics", true)
    option("window", true)
    option("audio", true)
    option("network", true)

    -- Dependencies
    if is_host("linux") then
        if has_config("graphics") then
            add_deps("freetype")
        end

        if has_config("window") or has_config("graphics") then
            add_deps("libx11", "libxrandr")
        end 

        if has_config("audio") then
            add_deps("libogg", "libflac", "libvorbis", "openal-soft")
        end

        if has_config("network") then
            add_syslinks("eudev")
        end
    elseif is_host("windows") then
        if has_config("window") or has_config("graphics") then
            add_syslinks("opengl32", "gdi32", "user32", "advapi32")
        end 

        if has_config("network") then
            add_syslinks("ws2_32")
        end

        add_syslinks("winmm")
    end

    -- Install
    on_install(function (package)
        local xmake_lua = [[
            option("graphics", {default = true, showmenu = true})
            option("window", {default = true, showmenu = true})
            option("audio", {default = true, showmenu = true})
            option("network", {default = true, showmenu = true})

            -- Architecture
            local arch = "x64"
            if is_arch("x86", "i386") then
                arch = "x86"
            end

            target("sfml")
                -- Meta
                set_languages("c++17")
                set_kind("static")
            
                -- Rules
                add_rules("mode.debug", "mode.release")
                
                -- Defines
                add_defines("SFML_STATIC")
            
                if is_host("windows") then
                    add_defines("UNICODE")
                end
                
                -- Link libraries
                if has_config("graphics") then
                    add_links("freetype")
                end
                
                if has_config("audio") then 
                    add_links("openal32", "FLAC", "vorbisenc", "vorbisfile", "vorbis", "ogg")
                    add_linkdirs("extlibs/bin/" .. arch)
                end
            
                local plat = "mingw"
                if is_plat("windows") then
                    plat = "msvc-universal"
                end
            
                add_linkdirs("extlibs/libs-" .. plat .. "/" .. arch)
            
                -- Dependencies
                if is_host("linux") then
                    if has_config("graphics") then
                        add_deps("freetype")
                    end

                    if has_config("window") or has_config("graphics") then
                        add_deps("libx11", "libxrandr")
                    end 

                    if has_config("audio") then
                        add_deps("libogg", "libflac", "libvorbis", "openal-soft")
                    end

                    if has_config("network") then
                        add_syslinks("eudev")
                    end
                elseif is_host("windows") then
                    if has_config("window") or has_config("graphics") then
                        add_syslinks("opengl32", "gdi32", "user32", "advapi32")
                    end 

                    if has_config("network") then
                        add_syslinks("ws2_32")
                    end

                    add_syslinks("winmm")
                end
            
                -- Include libraries headers
                add_includedirs("extlibs/headers", "extlibs/headers/AL", "extlibs/headers/freetype2", "extlibs/headers/glad/include", "extlibs/headers/mingw", "extlibs/headers/minimp3", "extlibs/headers/ogg", "extlibs/headers/stb_image", "extlibs/headers/vorbis", "extlibs/headers/vulkan")
                    
                -- Source code
                add_includedirs("include", "src")
            
                -- Implementation files
                local os = "Win32"
                if is_host("linux") then
                    os = "Unix"
                end
            
                -- Source code
                add_files("src/SFML/System/" .. os .. "/*.cpp")
                add_files("src/SFML/System/*.cpp")
            
                if has_config("network") then
                    add_files("src/SFML/Network/" .. os .. "/*.cpp")
                    add_files("src/SFML/Network/*.cpp")
                end
            
                if has_config("audio") then
                    add_files("src/SFML/Audio/*.cpp") 
                end
            
                if has_config("window") or has_config("graphics") then
                    add_files("src/SFML/Window/" .. os .. "/*.cpp")
                    add_files("src/SFML/Window/*.cpp")
                end

                if has_config("graphics") then
                    add_files("src/SFML/Graphics/*.cpp")
                end
        ]]

        io.writefile("xmake.lua", xmake_lua);
        import("package.tools.xmake").install(package, { arch=arch, graphics=has_config("graphics"), window=has_config("window"), network=has_config("network"), audio=has_config("audio")})

        os.cp("include/SFML", package:installdir("include"))
    end)