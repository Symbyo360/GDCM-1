project "gdcm"
	-- uuid "C3BA937E-8404-4A94-A2AC-7D35855A6F69"
	language "C++"
	kind "Makefile"
	targetdir (bin_path .. "/%{cfg.platform}/%{cfg.buildcfg}/")
	location (build_path .. "/gdcm/")

	local gdcm_location = path.join(build_path, "gdcm")
	gdcm_path = path.join(bin_path, "gdcm")

	if os.isdir(gdcm_location) == false then
		os.mkdir(gdcm_location)
	end

	if os.istarget("windows") then
		cleancommands { "rmdir /Q /S \"" .. gdcm_path .. "\"" }

		if os.getversion().majorversion == 10.0 then
			systemversion(win10_sdk_version())
		end

		-- i'll assume on windows you are working with vs2017 win64
		filter "configurations:debug"
			buildcommands
			{
				"cd \"" .. gdcm_location .. "\"",
				cmake_path .. " \"" .. gdcm_lib_path .. "\" -G \"Visual Studio 15 Win64\" -DCMAKE_INSTALL_PREFIX=\"" .. path.join(gdcm_path, "debug") .. "\" -DCMAKE_DEBUG_POSTFIX=\"\" -DGDCM_BUILD_SHARED_LIBS=ON",
				cmake_path .. " " .. " --build \"" .. gdcm_location .. "\" --target install --config Debug"
			}

		filter "configurations:release"
			buildcommands
			{
				"cd \"" .. gdcm_location .. "\"",
				cmake_path .. " \"" .. gdcm_lib_path .. "\" -G \"Visual Studio 15 Win64\" -DCMAKE_INSTALL_PREFIX=\"" .. path.join(gdcm_path, "debug") .. "\" -DGDCM_BUILD_SHARED_LIBS=ON",
				cmake_path .. " " .. " --build \"" .. gdcm_location .. "\" --target install --config Release"
			}

	elseif os.istarget("linux") then
		cleancommands { "rm -R \"" .. gdcm_path .. "\"" }

		filter "configurations:debug"
			buildcommands
			{
				"cd \"" .. gdcm_location .. "\"",
				cmake_path .. " \"" .. gdcm_lib_path .. "\" -G \"Unix Makefiles\" -DCMAKE_INSTALL_PREFIX=\"" .. path.join(gdcm_path, "debug") .. "\" -DCMAKE_DEBUG_POSTFIX=\"\" -DGDCM_BUILD_SHARED_LIBS=ON",
				cmake_path .. " " .. " --build \"" .. gdcm_location .. "\" --target install --config Debug -- -j 8"
			}

		filter "configurations:release"
			buildcommands
			{
				"cd \"" .. gdcm_location .. "\"",
				cmake_path .. " \"" .. gdcm_lib_path .. "\" -G \"Unix Makefiles\" -DCMAKE_INSTALL_PREFIX=\"" .. path.join(gdcm_path, "debug") .. "\" -DGDCM_BUILD_SHARED_LIBS=ON",
				cmake_path .. " " .. " --build \"" .. gdcm_location .. "\" --target install --config Release -- -j 8"
			}
	end