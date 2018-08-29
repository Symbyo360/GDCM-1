project "gdcmCommon"
	language "C++"
	kind "SharedLib"
	targetdir (bin_path .. "/%{cfg.platform}/%{cfg.buildcfg}/")
	location  (build_path .. "/gdcmCommon/")

	files
	{
		"Source/Common/*.h",
		"Source/Common/*.hpp",
		"Source/Common/*.cxx"
	}

	includedirs
	{
		"Source/Common/",
		"Source/DataStructureAndEncodingDefinition"
	}

	--language configuration
	exceptionhandling "OFF"
	rtti "ON"
	warnings "Extra"
	cppdialect "c++17"


	--linux configuration
	filter "system:linux"
		defines { "OS_LINUX" }
		linkoptions {"-pthread"}

	filter { "system:linux", "configurations:debug" }
		linkoptions {"-rdynamic"}


	--windows configuration
	filter "system:windows"
		-- links { "ws2_32" }
		defines { "OS_WINDOWS" }
		if os.getversion().majorversion == 10.0 then
			systemversion(win10_sdk_version())
		end
		
	filter { "system:windows", "configurations:debug" }
		links {"dbghelp"}


	--os agnostic configuration
	filter "configurations:debug"
		targetsuffix "d"
		defines {"DEBUG"}
		symbols "On"

	filter "configurations:release"
		defines {"NDEBUG"}
		optimize "On"

	filter "platforms:x86"
		architecture "x32"

	filter "platforms:x64"
		architecture "x64"