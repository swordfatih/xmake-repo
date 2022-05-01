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
    add_configs("graphics",   {description = "Use the graphics module", default = true, type = "boolean"})
    add_configs("window",     {description = "Use the window module", default = true, type = "boolean"})
    add_configs("audio",      {description = "Use the audio module", default = true, type = "boolean"})
    add_configs("network",    {description = "Use the network module", default = true, type = "boolean"})

    -- Dependencies
    if is_host("linux") then
        add_deps("libx11", "libxrandr", "freetype", "eudev", "libogg", "libflac", "libvorbis", "openal-soft")
    elseif is_host("windows") then
        add_syslinks("opengl32", "gdi32", "user32", "advapi32", "ws2_32", "winmm")
    end

    -- Architecture
    local arch = "x64"
    if is_arch("x86", "i386") then
        arch = "x86"
    end

    -- Install
    on_install(function (package)
        local xmake_lua = format([[
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
                if $(graphics) then
                    add_links("freetype")
                end
                
                if $(audio) then 
                    add_links("openal32", "FLAC", "vorbisenc", "vorbisfile", "vorbis", "ogg")
                    add_linkdirs("extlibs/bin/" .. $(arch))
                end
            
                local plat = "mingw"
                if is_plat("windows") then
                    plat = "msvc-universal"
                end
            
                add_linkdirs("extlibs/libs-" .. plat .. "/" .. $(arch))
            
                -- Dependencies
                if is_host("linux") then
                    add_deps("libx11", "libxrandr", "freetype", "eudev", "libogg", "libflac", "libvorbis", "openal-soft")
                elseif is_host("windows") then
                    add_syslinks("opengl32", "gdi32", "user32", "advapi32", "ws2_32", "winmm")
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
            
                if $(network) then
                    add_files("src/SFML/Network/" .. os .. "/*.cpp")
                    add_files("src/SFML/Network/*.cpp")
                end
            
                if $(audio) then
                    add_files("src/SFML/Audio/*.cpp") 
                end
            
                if $(window) or $(graphics) then
                    add_files("src/SFML/Window/" .. os .. "/*.cpp")
                    add_files("src/SFML/Window/*.cpp")
                end

                if $(graphics) then
                    add_files("src/SFML/Graphics/*.cpp")
                end
        ]], arch)

        io.writefile("xmake.lua", xmake_lua);

        import("package.tools.xmake").install(package, package:configs())
        
        os.cp("include/SFML", package:installdir("include"))
    end)