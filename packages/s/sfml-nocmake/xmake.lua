local arch = "x64"
if is_arch("x86", "i386") then
    arch = "x86"
end

package("sfml-nocmake")
    -- Meta 
    set_homepage("https://www.sfml-dev.org")
    set_description("Simple and Fast Multimedia Library")

    add_urls("https://github.com/SFML/SFML.git")
    
    -- Versions
    add_versions("master", "a8e901e754472539d9ce1257ae1758e7e96a31b8")
    add_versions("2.6.0", "11b73743c42cf7ecd7c596ba83fdbf1150ffa96c")

    -- Defines
    add_defines("SFML_STATIC")

    -- Linking
    add_links("sfml")

    -- Configs
    add_configs("graphics", {description = "Use the graphics module", default = true, type = "boolean"})
    add_configs("window",   {description = "Use the window module", default = true, type = "boolean"})
    add_configs("audio",    {description = "Use the audio module", default = true, type = "boolean"})
    add_configs("network",  {description = "Use the network module", default = true, type = "boolean"})
    add_configs("msvc",     {description = "Use the MSVC external libs", default = false, type = "boolean"})

    -- Load
    on_load(function (package)
        -- Dependencies
        if is_host("linux") then
            if package:config("graphics") then
                package:add("syslinks", "freetype")
            end

            if package:config("window") or package:config("graphics") then
                package:add("syslinks", "libxrandr")
            end 

            if package:config("audio") then
                package:add("syslinks", "libogg", "libflac", "libvorbis", "openal-soft")
            end

            if package:config("network") then
                package:add("syslinks", "eudev")
            end
        elseif is_host("windows") then
            if package:config("graphics") then
                package:add("syslinks", "freetype")
            end

            if package:config("window") or package:config("graphics") then
                package:add("syslinks", "opengl32", "gdi32", "user32", "advapi32")
            end 

            if package:config("audio") then 
                package:add("syslinks", "openal32", "FLAC", "vorbisenc", "vorbisfile", "vorbis", "ogg")
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
            option("graphics", {default = true, showmenu = true})
            option("window", {default = true, showmenu = true})
            option("audio", {default = true, showmenu = true})
            option("network", {default = true, showmenu = true})
            option("msvc", {default = false, showmenu = true})

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
                if has_config("msvc") then
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
                local host = "Win32"
                if is_host("linux") then
                    host = "Unix"
                end
            
                -- Source code
                add_files("src/SFML/System/" .. host .. "/*.cpp")
                add_files("src/SFML/System/*.cpp")
            
                if has_config("network") then
                    add_files("src/SFML/Network/" .. host .. "/*.cpp")
                    add_files("src/SFML/Network/*.cpp")
                end
            
                if has_config("audio") then
                    add_files("src/SFML/Audio/*.cpp") 
                end
            
                if has_config("window") or has_config("graphics") then
                    add_files("src/SFML/Window/" .. host .. "/*.cpp")
                    add_files("src/SFML/Window/*.cpp")
                end

                if has_config("graphics") then
                    add_files("src/SFML/Graphics/*.cpp")
                end
        ]]

        -- Build SFML
        io.writefile("xmake.lua", xmake_lua);
        import("package.tools.xmake").install(package, { arch=arch, graphics=package:config("graphics"), window=package:config("window"), network=package:config("network"), audio=package:config("audio"), msvc=package:config("msvc")})

        -- Copy SFML include directory
        os.cp("include/SFML", package:installdir("include"))

        -- Copy external libraries
        local plat = "mingw"
        if package:config("msvc") then
            plat = "msvc-universal"
        end

        os.cp("extlibs/libs-" .. plat .. "/" .. arch .. "/*", package:installdir("lib"))
        os.cp("extlibs/bin/" .. arch .. "/*", package:installdir("lib"))
    end)
