package("sfml-nocmake")
    -- Meta 
    set_homepage("https://www.sfml-dev.org")
    set_description("Simple and Fast Multimedia Library")

    add_urls("https://github.com/SFML/SFML.git")
    add_versions("master", "3ae85854e4674debe3b30ae2f6cf9d9926738789")

    add_includedirs("include", "src")

    on_install(function (package)
        io.writefile("xmake.lua", [[
            -- Arch
            local arch = "x64"
            if is_arch("x86", "i386") then
                arch = "x86"
            end

            target("sfml")
                -- Meta
                set_languages("c++17")
                set_kind("static")
                
                -- Defines
                add_defines("SFML_STATIC")

                if is_os("windows") then
                    add_defines("UNICODE")
                end
                
                -- Link libraries
                add_links("freetype", "openal32", "FLAC", "vorbisenc", "vorbisfile", "vorbis", "ogg")
                add_linkdirs("extlibs/bin/" .. arch)

                local plat = "mingw"
                if is_plat("windows") then
                    plat = "msvc-universal"
                end

                add_linkdirs("extlibs/libs-" .. plat .. "/" .. arch)

                -- Dependencies
                if is_plat("linux") then
                    add_deps("libx11", "libxrandr", "freetype", "eudev", "libogg", "libflac", "libvorbis", "openal-soft")
                elseif is_os("windows") then
                    add_syslinks("opengl32", "gdi32", "user32", "advapi32", "ws2_32", "winmm")
                end

                -- Include libraries headers
                add_includedirs("extlibs/headers", "extlibs/headers/AL", "extlibs/headers/freetype2", "extlibs/headers/glad/include", "extlibs/headers/mingw", "extlibs/headers/minimp3", "extlibs/headers/ogg", "extlibs/headers/stb_image", "extlibs/headers/vorbis", "extlibs/headers/vulkan")
                    
                -- Source code
                add_includedirs("include", "src")

                -- Implementation files
                local os = "Win32"
                if is_os("linux") then
                    os = "Unix"
                end

                add_files("src/SFML/Graphics/*.cpp")
                add_files("src/SFML/Audio/*.cpp")

                add_files("src/SFML/Window/" .. os .. "/*.cpp")
                add_files("src/SFML/Window/*.cpp")

                add_files("src/SFML/Network/" .. os .. "/*.cpp")
                add_files("src/SFML/Network/*.cpp")
                
                add_files("src/SFML/System/" .. os .. "/*.cpp")
                add_files("src/SFML/System/*.cpp")
                
                -- Rules
                add_rules("mode.debug", "mode.release")
        ]])

        import("package.tools.xmake").install(package, configs)

        os.cp("include/SFML", package:installdir("include"))
        os.cp("src/SFML", package:installdir("src"))
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test(int args, char** argv) {
                sf::Clock c;
                c.restart();
            }
        ]]}, {includes = "SFML/System.hpp"}))
    end)