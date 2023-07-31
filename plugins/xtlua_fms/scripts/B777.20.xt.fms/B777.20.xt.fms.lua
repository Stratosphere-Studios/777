--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*     Converted from Sparky744 to Stratosphere 777 by remenkemi (crazytimtimtim)
*****************************************************************************************
]]

function deferred_command(name,desc,realFunc)
	return replace_command(name,realFunc)
end

--replace deferred_dataref
function deferred_dataref(name,nilType,callFunction)
	if callFunction~=nil then
		print("WARN:" .. name .. " is trying to wrap a function to a dataref -> use xlua")
    end
    return find_dataref(name)
end

totalizerInitkgs = 0.0
totalizerSumkgs = 0.0
local totalizerInited = false
local kgs_to_lbs = 2.204623

B777DR_eicas_fmc_messages = deferred_dataref("B777DR/eicas/fmc_messages", "array[2]")
simDR_engines_running = find_dataref("sim/flightmodel/engine/ENGN_running")
simDR_fuel_flow_kg_sec = find_dataref("sim/cockpit2/engine/indicators/fuel_flow_kg_sec")

B777DR_fuel_lbs_kgs_total   = find_dataref("Strato/777/displays/fuel_lbs_kgs_total")
B777DR_cdu_efis_ctl         = find_dataref("Strato/777/cdu_efis_ctl")
B777DR_cdu_eicas_ctl        = find_dataref("Strato/777/cdu_eicas_ctl")
vor_adf = {0, 0}
simDR_vor_adf = {find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_pilot"), find_dataref("sim/cockpit2/EFIS/EFIS_2_selection_pilot"), find_dataref("sim/cockpit2/EFIS/EFIS_1_selection_copilot"), find_dataref("sim/cockpit2/EFIS/EFIS_2_selection_copilot")}
B777DR_efis_vor_adf                    = find_dataref("Strato/777/efis/vor_adf")
B777DR_baro_mode                       = find_dataref("Strato/777/baro_mode")
B777DR_minimums_mda                    = find_dataref("Strato/777/minimums_mda")
B777DR_minimums_dh                     = find_dataref("Strato/777/minimums_dh")
simDR_nd_mode                          = {find_dataref("sim/cockpit2/EFIS/map_mode"), find_dataref("sim/cockpit2/EFIS/map_mode_copilot")}
simDR_nd_range                         = {find_dataref("sim/cockpit2/EFIS/map_range_nm"), find_dataref("sim/cockpit2/EFIS/map_range_nm_copilot")}
B777DR_minimums_mode                   = find_dataref("Strato/777/minimums_mode")
simDR_altimiter_setting                = {find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot"), find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")}
B777DR_readme_code                     = find_dataref("Strato/777/readme_code")
B777DR_minimums_visible                = find_dataref("Strato/777/minimums_visible")

simDRTime=find_dataref("sim/time/total_running_time_sec")
simDR_onGround=find_dataref("sim/flightmodel/failures/onground_any")

B777DR_acfType                      = find_dataref("Strato/B777/acfType")
simDR_acf_m_jettison  	            = find_dataref("sim/aircraft/weight/acf_m_jettison")
simDR_m_jettison  		            = find_dataref("sim/flightmodel/weight/m_jettison")
simDR_nav1Freq                      = find_dataref("sim/cockpit/radios/nav1_freq_hz")
simDR_nav2Freq                      = find_dataref("sim/cockpit/radios/nav2_freq_hz")
B777DR_iru_status                   = find_dataref("Strato/B777/flt_mgmt/iru/status")
B777DR_iru_mode_sel_pos             = find_dataref("Strato/B777/flt_mgmt/iru/mode_sel_dial_pos")

B777DR_airspeed_Vref                = find_dataref("Strato/B777/airspeed/Vref")
B777DR_airspeed_VrefFlap            = find_dataref("Strato/B777/airspeed/VrefFlap")
B777DR_altimter_ft_adjusted         = find_dataref("Strato/B777/altimeter/ft_adjusted")
B777DR_engine_used_fuel             = find_dataref("Strato/B777/fuel/totaliser")
simDR_autopilot_airspeed_is_mac     = find_dataref("sim/cockpit2/autopilot/airspeed_is_mach")
simDR_autopilot_airspeed_kts_mach   = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts_mach")
simDR_autopilot_airspeed_kts   	    = find_dataref("sim/cockpit2/autopilot/airspeed_dial_kts")
B777DR_elec_ext_pwr1_available      = find_dataref("Strato/B777/electrical/ext_pwr1_avail")
B777DR_eicas_rcl                    = find_dataref("Strato/777/eicas/rcl")
B777DR_eicas_mode                   = find_dataref("Strato/777/displays/eicas_mode")
simDR_map_hsi                       = {find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI"), find_dataref("sim/cockpit2/EFIS/map_mode_is_HSI_copilot")}

simDR_efis_terr                        = find_dataref("sim/cockpit2/EFIS/EFIS_terrain_on")
simDR_efis_tfc                         = find_dataref("sim/cockpit2/EFIS/EFIS_tcas_on")
simDR_efis_arpt                        = find_dataref("sim/cockpit2/EFIS/EFIS_airport_on")
simDR_efis_fix                         = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on")
simDR_efis_wxr_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_weather_on_copilot")
simDR_efis_terr_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_terrain_on_copilot")
simDR_efis_tfc_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_tcas_on_copilot")
simDR_efis_arpt_fo                     = find_dataref("sim/cockpit2/EFIS/EFIS_airport_on_copilot")
simDR_efis_fix_fo                      = find_dataref("sim/cockpit2/EFIS/EFIS_fix_on_copilot")
B777DR_nd_sta                          = find_dataref("Strato/777/EFIS/sta")
B777DR_pfd_mtrs                        = find_dataref("Strato/777/displays/mtrs")

simDR_total_fuel_kgs                   = find_dataref("sim/flightmodel/weight/m_fuel_total")
simDR_gross_wt_kgs                     = find_dataref("sim/flightmodel/weight/m_total")
simDR_payload_wt_kgs                   = find_dataref("sim/flightmodel/weight/m_fixed")

function replace_char(pos, str, r)
    return str:sub(1, pos-1) .. r .. str:sub(pos+1)
end

function hasChild(parent,childKey)
	if parent == nil then return false end
	local keyFuncs = rawget(parent,'values')
	if keyFuncs == nil then return false end
	local keyFunc = rawget(keyFuncs,childKey)
	if keyFunc == nil then return false end
	return true
end

function split(s, delimiter)
    local result = {};
    for match in (s..delimiter):gmatch("(.-)"..delimiter) do
        table.insert(result, match);
    end
    return result;
end

function round(x)
	return x >= 0 and math.floor(x + 0.5) or math.ceil(x - 0.5)
end

function cleanFMSLine(line)
    local retval = line:gsub("☐","*")
    retval = retval:gsub("°","`")
    return retval
end

function getHeadingDifference(desireddirection,current_heading)
	error = current_heading - desireddirection
	if (error >  180) then error = error- 360 end
	if (error < -180) then error = error+ 360 end
	return error
end

function getHeadingDifferenceM(desireddirection,current_heading)
	error = current_heading - desireddirection
	if (error >  180) then error = error - 360 end
	if (error < -180) then error = error + 360 end
	if error < 0 then error = error * -1 end
	return error
end

function getDistance(lat1,lon1,lat2,lon2)
	alat = math.rad(lat1)
	alon = math.rad(lon1)
	blat = math.rad(lat2)
	blon = math.rad(lon2)
	av = math.sin(alat)*math.sin(blat) + math.cos(alat)*math.cos(blat)*math.cos(blon-alon)
	if av > 1 then av = 1 end
	retVal = math.acos(av) * 3440
	--print(lat1.." "..lon1.." "..lat2.." "..lon2)
	--print("Distance = "..retVal) 
	return retVal
end

function toDMS(value,isLat)
	local degrees = math.abs(value)
	local minutes = (value-math.floor(value))*60
	local seconds = minutes - math.floor(minutes)
	local prefix="E"
	if isLat then
		prefix = value > 0 and "N" or "S"
	else
		prefix = value > 0 and "E" or "W"
	end
	local retVal = isLat and string.format(prefix.."%02d`%02d.%1d", degrees, minutes, seconds * 10) or string.format(prefix.."%03d`%02d.%1d", degrees, minutes, seconds * 10)
	return retVal
end

dofile("json/json.lua")
hh=find_dataref("sim/cockpit2/clock_timer/zulu_time_hours")
mm=find_dataref("sim/cockpit2/clock_timer/zulu_time_minutes")
ss=find_dataref("sim/cockpit2/clock_timer/zulu_time_seconds")

navAidsJSON                         = find_dataref("xtlua/navaids")
fmsJSON                             = find_dataref("xtlua/fms")
--[[simDR_bus_volts                     = find_dataref("sim/cockpit2/electrical/bus_volts")
simDR_startup_running               = find_dataref("sim/operation/prefs/startup_running")

simDR_radio_nav_freq_Mhz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_Mhz")
simDR_radio_nav_freq_khz            = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_khz")
simDR_radio_nav_freq_hz             = find_dataref("sim/cockpit2/radios/actuators/nav_frequency_hz")

simDR_radio_nav_course_deg          = find_dataref("sim/cockpit2/radios/actuators/nav_course_deg_mag_pilot")
simDR_radio_nav_obs_deg             = find_dataref("sim/cockpit2/radios/actuators/nav_obs_deg_mag_pilot")
simDR_radio_nav1_obs_deg            = find_dataref("sim/cockpit/radios/nav1_obs_degt")
simDR_radio_nav2_obs_deg            = find_dataref("sim/cockpit/radios/nav2_obs_degt")
simDR_radio_nav_horizontal          = find_dataref("sim/cockpit2/radios/indicators/nav_display_horizontal")
simDR_radio_nav_hasDME              = find_dataref("sim/cockpit2/radios/indicators/nav_has_dme")
simDR_radio_nav_radial		       = find_dataref("sim/cockpit2/radios/indicators/nav_bearing_deg_mag")
simDR_radio_nav01_ID                = find_dataref("sim/cockpit2/radios/indicators/nav1_nav_id")
simDR_radio_nav02_ID                = find_dataref("sim/cockpit2/radios/indicators/nav2_nav_id")
simDR_radio_nav03_ID                = find_dataref("sim/cockpit2/radios/indicators/nav3_nav_id")
simDR_radio_nav04_ID                = find_dataref("sim/cockpit2/radios/indicators/nav4_nav_id")

simDR_radio_adf1_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf1_frequency_hz")
simDR_radio_adf2_freq_hz            = find_dataref("sim/cockpit2/radios/actuators/adf2_frequency_hz")

B777DR_fms1_display_mode            = find_dataref("Strato/B777/fms1/display_mode")

B777DR_efis_min_ref_alt_capt_sel_dial_pos       = find_dataref("Strato/B777/efis/min_ref_alt/capt/sel_dial_pos")
B777DR_efis_ref_alt_capt_set_dial_pos           = find_dataref("Strato/B777/efis/ref_alt/capt/set_dial_pos")
B777DR_efis_dh_reset_capt_switch_pos            = find_dataref("Strato/B777/efis/dh_reset/capt/switch_pos")
B777DR_efis_baro_ref_capt_sel_dial_pos          = find_dataref("Strato/B777/efis/baro_ref/capt/sel_dial_pos")
B777DR_efis_baro_std_capt_switch_pos            = find_dataref("Strato/B777/efis/baro_std/capt/switch_pos")
B777DR_efis_baro_capt_set_dial_pos              = find_dataref("Strato/B777/efis/baro/capt/set_dial_pos")
B777DR_efis_baro_capt_preselect                 = find_dataref("Strato/B777/efis/baro/capt/preselect")
B777DR_efis_baro_alt_ref_capt                   = find_dataref("Strato/B777/efis/baro_ref/capt")

B777DR_efis_min_ref_alt_fo_sel_dial_pos         = find_dataref("Strato/B777/efis/min_ref_alt/fo/sel_dial_pos")
B777DR_efis_ref_alt_fo_set_dial_pos             = find_dataref("Strato/B777/efis/ref_alt/fo/set_dial_pos")
B777DR_efis_dh_reset_fo_switch_pos              = find_dataref("Strato/B777/efis/dh_reset/fo/switch_pos")
B777DR_efis_baro_ref_fo_sel_dial_pos            = find_dataref("Strato/B777/efis/baro_ref/fo/sel_dial_pos")
B777DR_efis_baro_std_fo_switch_pos              = find_dataref("Strato/B777/efis/baro_std/fo/switch_pos")
B777DR_efis_baro_fo_set_dial_pos                = find_dataref("Strato/B777/efis/baro/fo/set_dial_pos")
B777DR_efis_baro_fo_preselect                   = find_dataref("Strato/B777/efis/baro/fo/preselect")
B777DR_efis_baro_alt_ref_fo                     = find_dataref("Strato/B777/efis/baro_ref/fo")

simDR_radio_alt_DH_capt             = find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_pilot")
simDR_radio_alt_DH_fo               = find_dataref("sim/cockpit2/gauges/actuators/radio_altimeter_bug_ft_copilot")

simDR_altimeter_baro_inHg           = find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_pilot")
simDR_altimeter_baro_inHg_fo        = find_dataref("sim/cockpit2/gauges/actuators/barometer_setting_in_hg_copilot")
simDR_altitude_pilot                = find_dataref("sim/cockpit2/gauges/indicators/altitude_ft_pilot")
]]
--Marauder28
--Used in ND DISPLAY
simDR_latitude				= find_dataref("sim/flightmodel/position/latitude")
simDR_longitude				= find_dataref("sim/flightmodel/position/longitude")
--[[simDR_navID					= find_dataref("sim/cockpit2/radios/indicators/gps_nav_id")
simDR_range_dial_capt		= find_dataref("Strato/B777/nd/range/capt/sel_dial_pos") -- no*
simDR_range_dial_fo			= find_dataref("Strato/B777/nd/range/fo/sel_dial_pos") -- no*
simDR_nd_mode_dial_capt		= find_dataref("Strato/B777/nd/mode/capt/sel_dial_pos")
simDR_nd_mode_dial_fo       = find_dataref("Strato/B777/nd/mode/fo/sel_dial_pos")
simDR_nd_center_dial_capt   = find_dataref("Strato/B777/nd/map_center/capt")
simDR_nd_center_dial_fo	    = find_dataref("Strato/B777/nd/map_center/fo")
simDR_EFIS_map_mode         = find_dataref("sim/cockpit2/EFIS/map_mode")
simDR_EFIS_map_range        = find_dataref("sim/cockpit2/EFIS/map_range")]]

--[[simDR_groundspeed			= find_dataref("sim/flightmodel2/position/groundspeed")
simDR_ias_pilot				= find_dataref("Strato/777/displays/ias_capt")
simDR_wind_degrees			= find_dataref("sim/cockpit2/gauges/indicators/wind_heading_deg_mag")
simDR_wind_speed			= find_dataref("sim/cockpit2/gauges/indicators/wind_speed_kts")
simDR_mach_pilot			= find_dataref("sim/cockpit2/gauges/indicators/mach_pilot")
simDR_mach_copilot			= find_dataref("sim/cockpit2/gauges/indicators/mach_copilot")
simDR_total_air_temp		= find_dataref("sim/cockpit2/temperature/outside_air_LE_temp_degc")
simDR_air_temp              = find_dataref("sim/cockpit2/temperature/outside_air_temp_degc")
simDR_empty_weight			= find_dataref("sim/aircraft/weight/acf_m_empty")]]
--Marauder28

--*************************************************************************************--
--** 				        CREATE READ-WRITE CUSTOM DATAREFS                        **--
--*************************************************************************************--
B777DR_cdu_notification     = deferred_dataref("Strato/777/fmc/notification", "array[3]")
--Marauder28
-- Holds all SimConfig options
B777DR_simconfig_data       = find_dataref("Strato/777/simconfig")
B777DR_newsimconfig_data    = find_dataref("Strato/777/newsimconfig")

--Sound Options (crazytimtimtim + Matt726)
B777DR_SNDoptions           = find_dataref("Strato/777/fmod/options")
B777DR_SNDoptions_volume    = find_dataref("Strato/777/fmod/options/volume") --TODO
B777DR_SNDoptions_gpws      = find_dataref("Strato/777/fmod/options/gpws")

B777DR_cdu_act          = deferred_dataref("Strato/777/cdu_fmc_act", "array[3]")
B777DR_readme_unlocked  = deferred_dataref("Strato/777/readme_unlocked", "number")

--Simulator Config Options
simConfigData = {}

function getSimConfig(p1, p2)
    if simConfigData[p1] then
		if simConfigData[p1][p2] then
			return simConfigData[p1][p2]
		end
    end
    print("ERROR: Attempt to get invalid simconfig value in FMS")
	return "fail"
end

function setSimConfig(p1, p2, value)
	if simConfigData[p1] then
		if simConfigData[p1][p2] then
			simConfigData[p1][p2] = value
			B777DR_simconfig_data = json.encode(simConfigData["values"])
			B777DR_newsimconfig_data = 1
			return "success"
		end
	end
	print("ERROR: Attempt to set invalid simconfig value in FMS.")
	return "fail"
end

fmsPages={}
--fmsPagesmall={}
fmsFunctionsDefs={}
fmsModules={} --set later

function defaultFMSData()
	return {
	acarsInitString="{}",
	fltno=string.rep("-", 8),
	fltdate="********",
	fltdep="****",
	fltdst="****",
	flttimehh="**",
	flttimemm="**",
	rpttimehh="**",
	rpttimemm="**",
	acarsAddress="*******",
	atc="****",
	grwt="***.*", -- always in kgs
	crzalt = "*****",
	clbspd="250",
	transpd="272",
	spdtransalt="10000",
	transalt="18000",
	clbrestspd="250",
	maxkts="420",
	clbrestalt="5000 ",
	stepalt="FL360",
	crzspd="810",
	desspdmach="805",
	desspd="270",
	destranspd="240",
	desspdtransalt="10000",
	desrestspd="180",
	desrestalt="5000 ",
	fpa="*.*",
	vb="*.*",
	vs="****",
	fuel = {"CALC  ", 000.0, 000.0, 000.0}, -- [1]: mode, [2]: calc, [3]: totalizer, [4]: manual
	zfw="***.*", -- always in kgs
	reserves="***.*",
	costindex="****",
	crzcg="20.0%",
	thrustsel=string.rep(" ", 2), --"26",  --Initally "blank" per FCOM FMC Preflight 2B - Thrust Limit Page
	thrustn1="**.*",
	toflap="**",
	v1="***",
	vr="***",
	v2="***",
	runway=string.rep("-", 5),
	coroute=string.rep("-", 10),
	grosswt="***.*",
	vref1="***",
	vref2="***",
	irsLat=string.rep(" ", 9),
	irsLon=string.rep(" ", 9),
	aptLat=string.rep(" ", 9),
	aptLon=string.rep(" ", 9),
	initIRSLat="****`**.*",
	initIRSLon="****`**.*",
	flapspeed="**/***",
	airportpos=string.rep("-", 4),
	airportgate=string.rep(" ", 5),
	preselectLeft=string.rep("-", 6),
	preselectRight=string.rep("-", 6),
	codata = string.rep("-", 6),
	lastpos = string.rep(" ", 18),
	sethdg = string.rep(" ", 4),
	stepsize = "ICAO",
	irsAlignTime = string.rep("0", 3),
	fmcUnlocked = false,
	readmeCodeInput = "*****",
	pos = string.rep(" ", 18),
	dragFF_armed = "   ",
	fmcFuel = {mode = "CALC", value = 0.0}
}
end

fmsModules["data"]=defaultFMSData()

fmsModules["setData"]=function(self,id,value)
    --always retain the same length
    if value == "" then
		local initData=defaultFMSData()
		if initData[id]~=nil then
			print("default for " .. id .. " is " .. initData[id])
			value=initData[id]
		else
			print("default for " .. id .. " is nil")
			self["data"][id] = nil
			return
		end
    end
    len=string.len(self["data"][id])
    if len < string.len(value) then 
		value=string.sub(value,1,len)
    end
    --newVal=string.sub(value,1,len)
    self["data"][id]=string.format("%s%"..(len-string.len(value)).."s",value,"")
end

function setFMSData(id,value)
    print("setting " .. id )
	print(" to "..value)
	print(" curently "..fmsModules["data"][id])
	fmsModules:setData(id,value)
end

function getFMSData(id)
	--print("getting getFMSData:"..id)
	if hasChild(fmsModules["data"],id) then
		--print("  curently "..fmsModules["data"][id])
		return fmsModules["data"][id]
	end
	print("  ERROR: FMS data not found")
	return "fail"
end

fmsModules["lastcmd"]=" "
fmsModules["cmds"]={}
fmsModules["cmdstrings"]={}

function registerFMCCommand(commandID,dataString) -- here to avoid breaking existing pages; inop
	--[[fmsModules["cmds"][commandID]=find_command(commandID)
	fmsModules["cmdstrings"][commandID]=dataString]]
	return
end

function switchCustomMode()
	fmsModules["fmsL"]["prevPage"] = fmsModules["fmsL"]["currentPage"]
	fmsModules["fmsC"]["prevPage"] = fmsModules["fmsC"]["currentPage"]
	fmsModules["fmsR"]["prevPage"] = fmsModules["fmsR"]["currentPage"]
	fmsModules["fmsL"]["inCustomFMC"]=fmsModules["fmsL"]["targetCustomFMC"]
	fmsModules["fmsC"]["inCustomFMC"]=fmsModules["fmsC"]["targetCustomFMC"]
	fmsModules["fmsR"]["inCustomFMC"]=fmsModules["fmsR"]["targetCustomFMC"]
	fmsModules["fmsL"]["currentPage"]=fmsModules["fmsL"]["targetPage"]
	fmsModules["fmsC"]["currentPage"]=fmsModules["fmsC"]["targetPage"]
	fmsModules["fmsR"]["currentPage"]=fmsModules["fmsR"]["targetPage"]
	fmsModules["fmsL"]["pgNo"]=fmsModules["fmsL"]["targetpgNo"]
	fmsModules["fmsC"]["pgNo"]=fmsModules["fmsC"]["targetpgNo"]
	fmsModules["fmsR"]["pgNo"]=fmsModules["fmsR"]["targetpgNo"]
	print("cdu blanking")
end

function createPage(page)
	retVal={}
	retVal.name=page
	retVal.template={
		"    " .. page,
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        "
	}

	retVal.templateSmall={
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ",
		"                        ", 
		"                        "
	}

	retVal.getPage=function(self,pgNo) return self.template end
	retVal.getSmallPage=function(self,pgNo) return self.templateSmall end
	print("createPage")
	retVal.getNumPages=function(self) return 1 end
	fmsFunctionsDefs[page]={}
	print("createDone")
	return retVal
end

dofile("B777.notifications.lua")
dofile("B777.createfms.lua")
--dofile("irs/irs_system.lua")
dofile("B777.fms.pages.lua")
--dofile("irs/rnav_system.lua")

fmsC = {}
setmetatable(fmsC, {__index = fms})
fmsC.id="fmsC"
setDREFs(fmsC,"cdu1","fms1","sim/FMS/","fms3")

fmsL = {}
setmetatable(fmsL, {__index = fms})
fmsL.id="fmsL"
setDREFs(fmsL,"cdu1","fms3","sim/FMS/","fms1")

fmsR = {}
setmetatable(fmsR, {__index = fms})
fmsR.id="fmsR"
setDREFs(fmsR,"cdu1","fms2","sim/FMS/","fms2")

--Marauder28

local fileLocation = "Output/preferences/Strato_777_lastpos.dat"

function loadLastPos()
	print("lastpos file = "..fileLocation)
	local file = io.open(fileLocation, "r")
	if file then
		fmsModules["data"].lastpos = file:read()
		file:close()
		print("loaded lastpos: "..fmsModules["data"].lastpos)
	else
		print("lastpos file is nil, loaded "..fmsModules["data"].pos)
		fmsModules["data"].lastpos = fmsModules["data"].pos
	end
end

function unloadLastPos()
	print("lastpos file = "..fileLocation)
	local file = io.open(fileLocation, "w")
	file:write(fmsModules["data"].pos)
	file:close()
	print("Unloaded lastpos: "..fmsModules["data"].pos)
end

--function livery_load() end

--Marauder28

function flight_start()

	--Ensure that CG location gets updated periodically so that the CG slider repositions automatically as fuel is burned during flight
	--run_at_interval(inflight_update_CG, 60) commented out for ss777]]
end

function doNotifications()
	local isError = {false, false}
	-- CDU notification lights
	B777DR_cdu_notification[0] = fmsModules["fmsL"]["notify"] ~= "" and 1 or 0
	B777DR_cdu_notification[1] = fmsModules["fmsC"]["notify"] ~= "" and 1 or 0
	B777DR_cdu_notification[2] = fmsModules["fmsR"]["notify"] ~= "" and 1 or 0

	-- Notifications from other modules

	-- EICAS messages
	for i = 0, 2 do
		local fmsID = i == 0 and "fmsL" or i == 1 and "fmsC" or "fmsR"
		for j = 0, #fmsModules[fmsID].dispMSG do
			if fmsModules[fmsID].dispMSG[i].type == 1 then
				B777DR_eicas_fmc_messages[0] = 1
				isError[1] = true
			elseif fmsModules[fmsID].dispMSG[i].type == 2 then
				B777DR_eicas_fmc_messages[1] = 1
				isError[2] = true
			end
		end
	end
	if not isError[1] then B777DR_eicas_fmc_messages[0] = 0 end
	if not isError[2] then B777DR_eicas_fmc_messages[1] = 0 end
end

function calcFuel1()
	totalizerSumkgs = totalizerSumkgs + simDR_fuel_flow_kg_sec[0] + simDR_fuel_flow_kg_sec[1]
	run_after_time(calcFuel2, 1)
end
function calcFuel2()
	totalizerSumkgs = totalizerSumkgs + simDR_fuel_flow_kg_sec[0] + simDR_fuel_flow_kg_sec[1]
	run_after_time(calcFuel1, 1)
end

function calcFuel()
    if fmsModules["data"].fmcFuel.mode == "CALC" then
        if simDR_fuel_flow_kg_sec[0] > 5 or simDR_fuel_flow_kg_sec[1] > 5 then -- if abnormal fuel flow switch to sensed mode
            fmsModules["data"].fmcFuel.mode = "SENSED"
            return
        end
        if simDR_engines_running[0] == 0 and simDR_engines_running[1] == 0 then -- when engines off show totalizer fuel
            fmsModules["data"].fmcFuel.value = simDR_total_fuel_kgs
            return
        elseif not totalizerInited then -- if engine(s) started initialize totalizer once
            totalizerInitkgs = simDR_total_fuel_kgs
			totalizerSumkgs = 0.0
            totalizerInited = true
        end
        fmsModules["data"].fmcFuel.value = totalizerInitkgs - totalizerSumkgs -- calc
    elseif fmsModules["data"].fmcFuel.mode == "SENSED" then
        fmsModules["data"].fmcFuel.value = simDR_total_fuel_kgs
    elseif fmsModules["data"].fmcFuel.mode == "MANUAL" then
        -- setdata func sets stuff
		fmsModules["data"].fmcFuel.value = totalizerInitkgs - totalizerSumkgs
    end
end

function after_physics()
	calcFuel()

	local temp1, temp2 = B777DR_newsimconfig_data, B777DR_simconfig_data -- keep data fresh
	if B777DR_newsimconfig_data == 1 and B777DR_simconfig_data:len() > 2 then
		print("fms: "..B777DR_simconfig_data)
		simConfigData = json.decode(B777DR_simconfig_data)
	end

	fmsModules["data"].pos = toDMS(simDR_latitude, true).." "..toDMS(simDR_longitude, false)
	
	--refresh time
	local cM = hh
	cM = mm
	cM = ss
    --doNotifications()

	--[[if simDR_bus_volts[0]>24 then ss777 comment
		irsSystem.update()
		B777_setNAVRAD()
    end]]

--[[    if acarsSystem.provider.online() then
		-- B777DR_CAS_memo_status[40]=0
		acars = 1 --for radio
		acarsSystem.provider.receive()
		local hasNew = 0
		for i = table.getn(acarsSystem.messages.values), 1, -1 do
			if not acarsSystem.messages[i]["read"] then
				hasNew = 1
			end
		end
		B777DR_CAS_memo_status[0] = hasNew
    else
		if B777DR_rtp_C_off == 0 then ss777 comment
			B777DR_CAS_memo_status[40] = 1 --for CAS
		else
			B777DR_CAS_memo_status[40] = 0
		end
		acars = 0 --for radio
    end
]]

	--print(fmsModules["fmsL"]["prevPage"], fmsModules["fmsC"]["prevPage"], fmsModules["fmsR"]["prevPage"])
	B777DR_readme_unlocked = getSimConfig("FMC", "unlocked")

	if B777DR_cdu_efis_ctl[0] == 1 then
		simDR_vor_adf[1] = vor_adf[1]
		simDR_vor_adf[2] = vor_adf[1]
	else
		simDR_vor_adf[1] = B777DR_efis_vor_adf[0]
		simDR_vor_adf[2] = B777DR_efis_vor_adf[1]
	end

	if B777DR_cdu_efis_ctl[1] == 1 then
		simDR_vor_adf[3] = vor_adf[2]
		simDR_vor_adf[4] = vor_adf[2]
	else
		simDR_vor_adf[4] = B777DR_efis_vor_adf[2]
		simDR_vor_adf[4] = B777DR_efis_vor_adf[3]
	end
	if not is_timer_scheduled(unloadLastPos) then
		run_after_time(unloadLastPos, 30)
	end
	--fmsL:B777_fms_display()
    --fmsC:B777_fms_display()
    --fmsR:B777_fms_display()
end

function updateNavaids()
	local temp = navAidsJSON
end

function aircraft_load()
	run_after_time(loadLastPos, 2)
	find_command("Strato/B777/fms1/ls_key/R6"):once()
	find_command("Strato/B777/fms2/ls_key/R6"):once()
	find_command("Strato/B777/fms3/ls_key/R6"):once()
	local navaidsTemp = navAidsJSON -- load navaids
	run_after_time(updateNavaids, 1)
	calcFuel1()
end

--function aircraft_unload() end