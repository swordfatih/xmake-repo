package("sfml-nocmake")
    /* Meta */
    set_homepage("https://www.sfml-dev.org")
    set_description("Simple and Fast Multimedia Library")

    set_urls("https://www.sfml-dev.org/files/SFML-$(version)-sources.zip")
    add_urls("https://github.com/SFML/SFML/releases/download/$(version)/SFML-$(version)-sources.zip")
    add_versions("2.5.1", "bf1e0643acb92369b24572b703473af60bac82caf5af61e77c063b779471bb7f")

    /* Modules config */
    add_configs("graphics",   {description = "Use the graphics module", default = true, type = "boolean"})
    add_configs("window",     {description = "Use the window module", default = true, type = "boolean"})
    add_configs("audio",      {description = "Use the audio module", default = true, type = "boolean"})
    add_configs("network",    {description = "Use the network module", default = true, type = "boolean"})

    /* Dependencies for each modules */
    on_load(function (package)
        /* Package configs */
        /* package:debug() for debug/release */
        /* package:config("shared") for shared/static */
        
        if not package:config("shared") then
            package:add("defines", "SFML_STATIC")
        end

        if package:config("window") or package:config("graphics") then
            if package:is_plat("windows", "mingw") then
                package:add("syslinks", "opengl32", "gdi32", "user32", "advapi32")
            end

            if package:is_plat("linux") then
                package:add("deps", "libx11", "libxrandr", "freetype", "eudev")
                package:add("deps", "opengl", "glx", {optional = true})
            end
        end

        if package:config("audio") then
            if package:is_plat("linux") then
                package:add("deps", "libogg", "libflac", "libvorbis", "openal-soft")
            end
        end

        if package:config("network") then
            if package:is_plat("windows", "mingw") then
                package:add("syslinks", "ws2_32")
            end
        end

        if package:is_plat("windows", "mingw") then
            package:add("syslinks", "winmm")
        end
    end)

    /* Install for windows */
    on_install("windows", function (package)
        os.cp("include/SFML", package:installdir("include/SFML"))
        os.cp("src/SFML", package:installdir("src/SFML"))

        local arch = "x64"

        if is_arch("x86", "i386") then
            arch = "x86"
        end

        os.cp("extlibs/bin/" .. arch, package:installdir("bin"))

        if not package:is_plat("mingw")
            os.cp("extlibs/libs-msvc-universal/" .. arch, package:installdir("lib"))
        else
            os.cp("extlibs/libs-mingw/" .. arch, package:installdir("lib"))
        end
    end)

    on_test(function (package)
        assert(package:check_cxxsnippets({test = [[
            void test(int args, char** argv) {
                sf::Clock c;
                c.restart();
            }
        ]]}, {includes = "SFML/System.hpp"}))
    end)