workspace "Hazel"
    architecture "x64"

    configuration{
        "Debug",
        "Release",
        "Dist"
    }

outputdir = "%{cfg.buildcfg}-%{cfg.system}-%{cfg.architecture}"

project "Hazel"
    location "Hazel"
    kind "SharedLib"
    language "C++"

    targetDir ("bin/" .. outputdir .. "/%{prj.name}")
    objDir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files{
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
    }

    include{
        "%{prj.name}/vendor/spdlog/include"
    }

    filter "sysstem:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "10.0.20348.0"

        defines {
            "HZ_PLATFORM_WINDOWS",
            "HZ_Build_DLL",
            "_WINDLL"
        }

        postbuildcommands {
            ("{COPY} %{cfg.buildtarget.relpath} ../bin/" .. outputdir .. "/Sandbox") --复制hazel.dll 到sandbox目录中
        }

    filter "configurations:Debug"
        defines "HZ_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        optimize "On"

        
project "Sandbox"
    location "Sandbox"
    kind "ConsoleApp"
    language "C++"

    targetDir ("bin/" .. outputdir .. "/%{prj.name}")
    objDir ("bin-int/" .. outputdir .. "/%{prj.name}")

    files{
        "%{prj.name}/src/**.h",
        "%{prj.name}/src/**.cpp",
    }

    include{
        "%{prj.name}/vendor/spdlog/include"
        "Hazel/src"
    }

    links{
        "Hazel"
    }

    filter "sysstem:windows"
        cppdialect "C++17"
        staticruntime "On"
        systemversion "10.0.20348.0"

        defines {
            "HZ_PLATFORM_WINDOWS"
        }

    filter "configurations:Debug"
        defines "HZ_DEBUG"
        symbols "On"

    filter "configurations:Release"
        defines "HZ_RELEASE"
        optimize "On"

    filter "configurations:Dist"
        defines "HZ_DIST"
        optimize "On"