--[[
*****************************************************************************************
*        COPYRIGHT � 2020 Mark Parker/mSparks CC-BY-NC4
*         Converted for 777 by remenkemi (crazytimtimtim)
*****************************************************************************************
]]
--Marauder28
--V Speeds

-- NOTE: FMC WILL STORE ALL WEIGHTS AS KGS REGARDLESS OF USER SETTING. WILL CONVERT TO/FROM KGS WHEN DATA ENTERED/RETREIVED

B777DR_airspeed_V1			= deferred_dataref("Strato/B777/airspeed/V1", "number")
B777DR_airspeed_Vr			= deferred_dataref("Strato/B777/airspeed/Vr", "number")
B777DR_airspeed_V2			= deferred_dataref("Strato/B777/airspeed/V2", "number")
B777DR_airspeed_flapsRef	= deferred_dataref("Strato/B777/airspeed/flapsRef", "number")

--Refuel DR
B777DR_refuel							= deferred_dataref("Strato/B777/fuel/refuel", "number")
--Marauder28

--B777DR_cdu_act [0] left, [1] center, [2] right. 0 none actived, 1 fmc, 2 sat, 3 cab int

fmsFunctions={}
--dofile("stuff/acars/acars.lua")

--dofile("activepages/B777.fms.pages.legs.lua")
--dofile("activepages/B777.fms.pages.maint.lua")
--dofile("activepages/B777.fms.pages.maintbite.lua")
--dofile("activepages/B777.fms.pages.maintcrossload.lua")
--dofile("activepages/B777.fms.pages.maintperffactor.lua")
--dofile("activepages/B777.fms.pages.fmccomm.lua")
--dofile("activepages/B777.fms.pages.cmc.lua")
--dofile("activepages/B777.fms.pages.acms.lua")
--dofile("activepages/atc/B777.fms.pages.atcindex.lua")
--dofile("activepages/atc/B777.fms.pages.atclogonstatus.lua")
--dofile("activepages/atc/B777.fms.pages.atcreport.lua")
--dofile("activepages/atc/B777.fms.pages.request.lua")
--dofile("activepages/atc/B777.fms.pages.whencanwe.lua")
--dofile("activepages/B777.fms.pages.navrad.lua")
dofile("activepages/B777.fms.pages.rte1.lua")
dofile("activepages/B777.fms.pages.identpage.lua")
dofile("activepages/B777.fms.pages.initref.lua")
dofile("activepages/B777.fms.pages.index.lua")
dofile("activepages/B777.fms.pages.eicasctl.lua")
dofile("activepages/B777.fms.pages.readme.lua")
dofile("activepages/B777.fms.pages.posinit.lua")
dofile("activepages/B777.fms.pages.takeoff.lua")
dofile("activepages/B777.fms.pages.approach.lua")
dofile("activepages/B777.fms.pages.perfinit.lua")
dofile("activepages/B777.fms.pages.efisctl.lua")
dofile("activepages/B777.fms.pages.thrustlim.lua")
dofile("activepages/B777.fms.pages.refnavdata.lua")

--[[
dofile("activepages/B777.fms.pages.maintirsmonitor.lua")
dofile("activepages/B777.fms.pages.progress.lua")
dofile("activepages/B777.fms.pages.vnav.lua")
dofile("activepages/B777.fms.pages.vnav.lrc.lua")
dofile("activepages/atc/B777.fms.pages.posreport.lua")]]

--[[ DO NOT UNCOMMENT
dofile("B777.fms.pages.actclb.lua")
dofile("B777.fms.pages.actcrz.lua")
dofile("B777.fms.pages.actdes.lua")
dofile("B777.fms.pages.actirslegs.lua")
dofile("B777.fms.pages.actrte1data.lua")
dofile("B777.fms.pages.actrte1hold.lua")
dofile("B777.fms.pages.actrte1legs.lua")
dofile("B777.fms.pages.altnnavradio.lua")
dofile("B777.fms.pages.approach.lua")
dofile("B777.fms.pages.arrivals.lua")


dofile("B777.fms.pages.atcrejectdueto.lua")

dofile("B777.fms.pages.atcreport2.lua")
dofile("B777.fms.pages.atcuplink.lua")
dofile("B777.fms.pages.atcverifyresponse.lua")
dofile("B777.fms.pages.deparrindex.lua")
dofile("B777.fms.pages.departures.lua")
dofile("B777.fms.pages.fixinfo.lua")

dofile("B777.fms.pages.identpage.lua")
dofile("B777.fms.pages.irsprogress.lua")
dofile("B777.fms.pages.navradpage.lua")
dofile("B777.fms.pages.progress.lua")
dofile("B777.fms.pages.refnavdata1.lua")
dofile("B777.fms.pages.satcom.lua")
dofile("B777.fms.pages.waypointwinds.lua")
]]

local navAids
simDR_variation=find_dataref("sim/flightmodel/position/magnetic_variation")
B777DR_ils_dots           	= deferred_dataref("Strato/B777/autopilot/ils_dots", "number")
function findILS(value)

  local modes=B777DR_radioModes
  if navAidsJSON==nil or string.len(navAidsJSON)<5 then return false end
  if value=="DELETE" then 
    B777DR_radioModes=replace_char(1,modes," ")
	ilsData=""
	B777DR_ils_dots=0
    return true
  end
  B777DR_radioModes=replace_char(1,modes,"M")
  navAids=json.decode(navAidsJSON)
  local direction=nil
  local valueSO=split(value,"/")
  --print(value)
  if table.getn(valueSO) > 1 then
    value=valueSO[1]
     --print(value)
    direction=tonumber(valueSO[2])
    --print(value.." and " .. direction)
  else
    --print(value)
  end
  --print(" in " .. navAidsJSON)
  local val=tonumber(value)
  if val~=nil then val=val*100 end
  local found=false
  local bestDist=360
  for n=table.getn(navAids),1,-1 do
      if navAids[n][2] == 8 then
	  --print("navaid "..n.."->".. navAids[n][1].." ".. navAids[n][2].." ".. navAids[n][3].." ".. navAids[n][4].." ".. navAids[n][5].." ".. navAids[n][6].." ".. navAids[n][7].." ".. navAids[n][8])
	  
	 if (value==navAids[n][8] or (val~=nil and val==navAids[n][3])) and (direction==nil or getHeadingDifferenceM(direction,navAids[n][4])<bestDist) then
	    found=true
		ilsData=json.encode(navAids[n])
		local course=(navAids[n][4]+simDR_variation)
	    print("68 - Tuning ILSs ".. ilsData)
	    if direction ~=nil then
		  bestDist=getHeadingDifferenceM(direction,navAids[n][4])
		  --course=direction
		end
		if course<0 then
			course=course+360
		elseif course>360 then
			course=course-360
  		end
	    simDR_nav1Freq=navAids[n][3]
	    simDR_nav2Freq=navAids[n][3] 	
	    simDR_radio_nav_obs_deg[0]=course
		simDR_radio_nav_obs_deg[1]=course
	    print("68 - Tuned ILS "..course)
	    print("68 - useThis "..bestDist)
	  end
      end
   end
   --[[if found==true then
		B777DR_ils_dots=1
   else
		B777DR_ils_dots=0
   end]]--
   return found
end

----- FMS FUNCTIONS ---------------

function fmsFunctions.setpage_no(fmsO,valueA) -- set page with target page number
	print("setpage_no="..valueA)
    local valueO=split(valueA,"_")
    print(valueO[1].." "..valueO[2])
	--fmsO["pgNo"]=tonumber(valueO[2])
	fmsO["targetpgNo"]=tonumber(valueO[2])
	value=valueO[1]

	if value=="FMC" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="FMC"
		simCMD_FMS_key[fmsO.id]["fpln"]:once()
		simCMD_FMS_key[fmsO.id]["L6"]:once()
		simCMD_FMS_key[fmsO.id]["L2"]:once()
	elseif value=="PROGRESS" then
		fmsModules[fmsO.id].targetCustomFMC=false
		simCMD_FMS_key[fmsO.id]["prog"]:once()
		fmsModules[fmsO.id].targetPage="PROGRESS"
		fmsModules[fmsO.id].targetpgNo=1
	elseif value=="VHFCONTROL" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="VHFCONTROL"
		simCMD_FMS_key[fmsO.id]["navrad"]:once()
	elseif value=="IDENT" then
		fmsO["targetCustomFMC"]=true
		fmsO["targetPage"]="IDENT"
		simCMD_FMS_key[fmsO.id]["index"]:once()
		simCMD_FMS_key[fmsO.id]["L1"]:once()
	elseif value=="DATABASE" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="DATABASE"
		simCMD_FMS_key[fmsO.id]["index"]:once()
		simCMD_FMS_key[fmsO.id]["R2"]:once()
	elseif value=="RTE1" then
		simCMD_FMS_key[fmsO.id]["fpln"]:once()
		fmsO["targetCustomFMC"]=true
		fmsO["targetPage"]="RTE1"
	elseif value=="RTE2" then
		fmsO["targetCustomFMC"]=false
		fmsO["targetPage"]="RTE2"
		simCMD_FMS_key[fmsO.id]["dir_intc"]:once()
	elseif value=="LEGS" then
		fmsModules[fmsO.id].targetCustomFMC=true
		fmsModules[fmsO.id].targetPage="LEGS"
		simCMD_FMS_key[fmsO.id]["legs"]:once()
		fmsModules[fmsO.id].targetpgNo=1
	else
		fmsO["targetCustomFMC"]=true
		fmsO["targetPage"]=value
	end

	print("setpage " .. value)
	run_after_time(switchCustomMode, 0.5)
end

function fmsFunctions.setpage(fmsO,value) -- set page
	value=value.."_1"
	fmsFunctions["setpage_no"](fmsO,value)
	--sim/FMS/navrad
	--sim/FMS2/navrad
end

function fmsFunctions.custom2fmc(fmsO,value)
	print("custom2fmc" .. value)
	simCMD_FMS_key[fmsO["id"]]["del"]:once()
	simCMD_FMS_key[fmsO["id"]]["clear"]:once()
	if value~="next" and value~="prev" and string.len(fmsO["scratchpad"])>0 then
		for c in string.gmatch(fmsO["scratchpad"],".") do
			local v = c
			if v == "/" then v = "slash" end
			simCMD_FMS_key[fmsO["id"]][v]:once()
		end
	elseif value=="next" then
		fmsO["targetpgNo"]=fmsO["pgNo"]+1
		run_after_time(switchCustomMode, 0.5)
	elseif value=="prev" then 
		fmsO["targetpgNo"]=fmsO["pgNo"]-1	run_after_time(switchCustomMode, 0.5)
	end
	simCMD_FMS_key[fmsO["id"]][value]:once()
	fmsO["scratchpad"]=""
end

function fmsFunctions.key2fmc(fmsO,value)
	print("key2fmc" .. value)
	if string.len(fmsO["scratchpad"])>0 then
		simCMD_FMS_key[fmsO["id"]]["del"]:once()
		simCMD_FMS_key[fmsO["id"]]["clear"]:once()
		if value~="next" and value~="prev" then
			for c in string.gmatch(fmsO["scratchpad"],".") do
			local v=c
			if v=="/" then v="slash" end
				simCMD_FMS_key[fmsO["id"]][v]:once()
			end
		end
	end
	simCMD_FMS_key[fmsO["id"]][value]:once()
	fmsO["scratchpad"]=""
	fmsO["notify"]=""
end

local updateFrom="fmsL"
local lastCrz=0
--[[function checkCRZ()
	if lastCrz==B777BR_cruiseAlt then return end
	if is_timer_scheduled(updateCRZ)==true then return end
	simCMD_FMS_key[fmsL.id]["fpln"]:once()--make sure we arent on the vnav page
    simCMD_FMS_key[fmsL.id]["clb"]:once()--go to the vnav page
    simCMD_FMS_key[fmsL.id]["next"]:once() --go to the vnav page 2

    fmsFunctions["custom2fmc"](fmsL,"R1")
    updateFrom=fmsL.id
    local toGet=B777DR_srcfms[updateFrom][3] --make sure we update it
    run_after_time(updateCRZ,0.5)

end

function updateCRZ()
	local setVal=string.sub(B777DR_srcfms[updateFrom][3],20,24)
	print("from line".. updateFrom.." "..B777DR_srcfms[updateFrom][3])
	print("to:"..setVal)
	local alt=validAlt(setVal)
	if alt~=nil then 
		B777BR_cruiseAlt=alt
		lastCrz=alt
	end
  fmsModules:setData("crzalt",setVal)
end
]]

function fmsFunctions.getdata(fmsO,value) -- getdata
	local data = ""
	if value == "gpspos" then
		data = fmsModules["data"].pos
	elseif value == "airportpos" then
		data = fmsModules["data"].aptLat..fmsModules["data"].aptLon
	else
		data = tostring(fmsModules["data"][value])
	end
	fmsO["scratchpad"] = data
end

function validateSpeed(value)
	local val=tonumber(value)
	if val==nil then return false end
	if val<130 or val>300 then return false end
	return true
end
function validAlt(value)
	local val=tonumber(value)
	if string.len(value)>2 and string.sub(value,1,2)=="FL" then val=tonumber(string.sub(value,3)) end
	if val==nil then return nil end
	if val<1000 then val=val*100 end
	if val<2000 or val>40000 then return nil end
	return ""..val
end
function validFL(value)
	local val=tonumber(value)
	if string.len(value)>2 and string.sub(value,1,2)=="FL" then val=tonumber(string.sub(value,3)) end
	if val==nil then return nil end
	if val<1000 then val=val*100 end
	if val<10000 or val>40000 then return nil end
	return "FL".. (val/100)
end
function validateMachSpeed(value)
	local val=tonumber(value)
	if val==nil then return nil end
	if val<1 then val=val*1000 end
	if val<100 then val=val*10 end
	if val<400 or val>870 then return nil end
	return ""..val
end
function validate_sethdg(value)
	--print(value)
	if tonumber(value) >= 0 and tonumber(value) <= 360 then
		return true
	else
		return false
	end
end

function slashEntry(input, field)
	local fieldPreSlash = field:sub(1, field:find("/") - 1)
    local fieldPostSlash= field:sub(field:find("/") + 1, -1)
	local inputSlashPos = input:find("/")

    if inputSlashPos then
        if inputSlashPos == 1 then
            return fieldPreSlash..input
        elseif inputSlashPos == input:len() then
            return input..fieldPostSlash
        else
            return input
        end
    else
        return input.."/"..fieldPostSlash
    end
end

function validateDragFF(entry)
    local input = slashEntry(entry, getSimConfig("FMC", "drag_ff"))
	print("input: "..input)
    local inputSplit = split(input, "/")
    local results = {"", ""}
    for i = 1, 2 do
		if inputSplit[i]:match('%.') and not inputSplit[i]:match('%d%.') then
            if inputSplit[i]:find('%.') == 2 then
                inputSplit[i] = inputSplit[i]:sub(1, 1).."0"..inputSplit[i]:sub(2, 3)
            else
                inputSplit[i] = "0"..inputSplit[i]
            end
		end
        local numInput = tonumber(inputSplit[i])
		--print("numInput: "..numInput)
		if numInput then
            if numInput <= 9.9 and numInput >= -5.0 then
                results[i] = string.format("%.1f", numInput)
                results[i] = numInput >= 0.0 and "+"..results[i] or results[i]
				--print("results "..i..": "..results[i])
            else
                return {false}
            end
        else
            return {false}
        end
    end
    return {true, results[1].."/"..results[2]}
end

function fmsFunctions.setdata(fmsO,value)
	local del=false
	if fmsO["scratchpad"]=="DELETE" then fmsO["scratchpad"]="" del=true end
	----- STRATOSPHERE 777 ----------

	if value == "BARO" then

		local id = fmsO.id == "fmsL" and 0 or 1;

		if fmsO["scratchpad"] == "S" or fmsO["scratchpad"] == "STD" then
---@diagnostic disable-next-line: assign-type-mismatch
			simDR_altimiter_setting[id+1] = 29.92
			fmsO["scratchpad"] = ""
			return
		end

		local baro = tonumber(fmsO["scratchpad"])

		if baro == nil then
			fmsO["notify"] = "INVALID ENTRY"
		else
			if baro % 1 == 0 then
				if baro >= 950 and baro <= 1050 then
					B777DR_baro_mode[id] = 1
---@diagnostic disable-next-line: assign-type-mismatch
					simDR_altimiter_setting[id+1] = baro / 33.863892
					fmsO["scratchpad"] = ""
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			else
				if baro <= 31 and baro >= 29 then
					B777DR_baro_mode[id] = 0
---@diagnostic disable-next-line: assign-type-mismatch
					simDR_altimiter_setting[id+1] = baro
					fmsO["scratchpad"] = ""
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			end
		end
		return
	end

	if value == "mins" then
		local id = fmsO.id == "fmsL" and 0 or 1;
		local mins = tonumber(fmsO["scratchpad"])
		if mins ~= nil then
			if B777DR_minimums_mode[id] == 0 then
				if mins >= 0 and mins <= 1000 then
					B777DR_minimums_dh[id] = mins
					fmsO["scratchpad"] = ""
					B777DR_minimums_visible[id] = 1
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			else
				if mins >= -1000 and mins <= 15000 then
					B777DR_minimums_mda[id] = mins
					fmsO["scratchpad"] = ""
					B777DR_minimums_visible[id] = 1
				else
					fmsO["notify"] = "INVALID ENTRY"
				end
			end
		else
			fmsO["notify"] = "INVALID ENTRY"
		end
		return
	end

	if value == "readmeCode" then
		if getSimConfig("FMC", "unlocked") == 0 then
			setFMSData("readmeCodeInput", fmsO["scratchpad"])
			if string.len(fmsO["scratchpad"]) == 5 then
				if fmsO["scratchpad"] == B777DR_readme_code or fmsO["scratchpad"] == "BIRDS" then
					fmsO["notify"] = "UNLOCKED"
					fmsO["scratchpad"] = ""
					setSimConfig("FMC", "unlocked", 1)
				else
					fmsO["notify"] = "INCORRECT CODE"
				end
			else
				fmsO["notify"] = "INVALID ENTRY"
			end
		else
			fmsO["notify"] = "ALREADY UNLOCKED"
		end
		return
	end

----- SPARKY 744 ----------

	if value=="depdst" and string.len(fmsO["scratchpad"])>3  then
		dep=string.sub(fmsO["scratchpad"],1,4)
		dst=string.sub(fmsO["scratchpad"],-4)
		--fmsModules["data"]["fltdep"]=dep
		--fmsModules["data"]["fltdst"]=dst
		setFMSData("fltdep",dep)
		setFMSData("fltdst",dst)
	elseif value=="clbspd" then
		if validateSpeed(fmsO["scratchpad"]) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("clbspd",fmsO["scratchpad"])
		end
	elseif value=="clbtrans" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("transpd",spd)
			if validAlt(alt) ~=nil then
				setFMSData("spdtransalt",validAlt(alt))
			end
		end
	elseif value=="transalt" then
		if validAlt(fmsO["scratchpad"]) ~=nil then
			setFMSData("transalt",validAlt(fmsO["scratchpad"]))
		else
			fmsO["notify"]="INVALID ENTRY"
		end
	elseif value=="clbrest" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("clbrestspd",spd)
			if validAlt(alt) ~=nil then
				setFMSData("clbrestalt",validAlt(alt))
			end
		end
	elseif value=="crzspd" then
		if validateMachSpeed(fmsO["scratchpad"]) ==nil then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("crzspd",validateMachSpeed(fmsO["scratchpad"]))
		end
	elseif value=="stepalt" then
		if validFL(fmsO["scratchpad"]) ~=nil then 
			setFMSData("stepalt",validFL(fmsO["scratchpad"]))
		else
			fmsO["notify"]="INVALID ENTRY"
		end
	elseif value=="desspds" then
		div = string.find(fmsO["scratchpad"], "%/")
		spd = getFMSData("desspd")
		-- print(spd)
		if div==nil then
			div=string.len(fmsO["scratchpad"])+1
		else
			spd=string.sub(fmsO["scratchpad"],div+1)
		end
		-- print(spd)
		machspd=string.sub(fmsO["scratchpad"],1,div-1)
		if validateMachSpeed(machspd) ==nil or validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("desspd",spd)
			setFMSData("desspdmach",validateMachSpeed(machspd))
		end
	elseif value=="destrans" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("destranspd",spd)
			if validAlt(alt) ~=nil then 
				setFMSData("desspdtransalt",validAlt(alt))
			end
		end
	elseif value=="desrest" then
		spd=string.sub(fmsO["scratchpad"],1,3)
		alt=string.sub(fmsO["scratchpad"],5)
		if validateSpeed(spd) ==false then 
			fmsO["notify"]="INVALID ENTRY"
		else
			setFMSData("desrestspd",spd)
			if validAlt(alt) ~=nil then 
				setFMSData("desrestalt",validAlt(alt))
			end
		end
	elseif value=="airportpos" then --and string.len(fmsO["scratchpad"])>3 then
		if string.len(fmsO["scratchpad"]) == 0 and string.match(fmsModules["data"].airportpos, '%a%a%a%a') then
			fmsO["scratchpad"] = fmsModules["data"].airportpos
			return
		end

		if string.len(navAidsJSON) > 2 then
			if string.match(fmsO["scratchpad"], '%a%a%a%a') and string.len(fmsO["scratchpad"]) == 4 then
				local navAids=json.decode(navAidsJSON)
				print(table.getn(navAids).." navaids")
				print(navAidsJSON)
				local found = false
				for n=table.getn(navAids),1,-1 do
					--if navAids[n][2] == 1 and navAids[n][8]==fmsO["scratchpad"] then
					if navAids[n][2] == 1 and navAids[n][8]==fmsO["scratchpad"] then
						print("navaid "..n.."->".. navAids[n][1].." ".. navAids[n][2].." ".. navAids[n][3].." ".. navAids[n][4].." ".. navAids[n][5].." ".. navAids[n][6].." ".. navAids[n][7].." ".. navAids[n][8])
						local lat=toDMS(navAids[n][5],true)
						local lon=toDMS(navAids[n][6],false)
						setFMSData("aptLat",lat)
						setFMSData("aptLon",lon)
						print("airport pos: "..lat..", "..lon)
						found = true
					end
				end
				if found then
					setFMSData("airportpos",fmsO["scratchpad"])
					setFMSData("airportgate","-----")
					fmsO["scratchpad"] = ""
				else
					fmsO["notify"]="NOT IN DATABASE"
				end
			elseif del == true then
				setFMSData("airportpos",defaultFMSData().airportpos)
				setFMSData("airportpos",defaultFMSData().airportgate)
				setFMSData("irsLat",defaultFMSData().irsLat)
				setFMSData("irsLon",defaultFMSData().irsLon)
			else
				fmsO["notify"]="INVALID ENTRY"
			end
		else
			print("ERROR: navAidsJSON is invalid: "..navAidsJSON)
		end
		return
	elseif value=="flttime" then 
		hhV=string.sub(fmsO["scratchpad"],1,2)
		mmV=string.sub(fmsO["scratchpad"],-2)
		setFMSData("flttimehh",hhV)
		setFMSData("flttimemm",mmV)
	elseif value=="rpttime" then
		hhV=string.sub(fmsO["scratchpad"],1,2)
		mmV=string.sub(fmsO["scratchpad"],-2)
		setFMSData("rpttimehh",hhV)
		setFMSData("rpttimemm",mmV)
	elseif value=="fltdate" then 
		setFMSData("fltdate",os.date("%Y%m%d"))
	elseif value == "crzalt" then -- does stuff with vnav pages, resets at end of flight
		local input = fmsO["scratchpad"]
		local numInput
		if input:match("FL") then
			input = input:gsub("FL", "")
			numInput = tonumber(input)
			if numInput then
				if numInput < 180 then -- trans alt
					fmsO["notify"] = "INVALID ENTRY"
					return
				end
			end
		end
		numInput = tonumber(input)
		if numInput then
			local inputFt = input:len() <= 3 and numInput * 100 or math.ceil(numInput / 10) * 10 -- round up to nearest 10th
			if simDR_onGround == 1 then
				if inputFt > simDR_altitude_pilot and inputFt < 43000 and inputFt >= 1000 then
					print("valid")
					fmsModules["data"]["crzalt"] = tostring(inputFt)
					fmsO["scratchpad"] = ""
					return
				end
			else
				--if inputFt < 43000 then
				--	if crzalt ~= "*****" then
				if inputFt < tonumber(fmsModules["data"].crzalt) and inputFt >= 1000 then
					print("valid")
					fmsModules["data"].crzalt = tostring(inputFt)
					fmsO["scratchpad"] = ""
					return
				end
				--	end
				--end
			end
		end
		fmsO["notify"] = "INVALID ENTRY"
		return
	elseif value=="irspos" then
		if string.len(fmsO["scratchpad"])>10 then
			print("set irs pos")
			lat=string.sub(fmsO["scratchpad"],1,9)
			lon=string.sub(fmsO["scratchpad"],-9)
			--fmsModules["data"]["fltdep"]=dep
			--fmsModules["data"]["fltdst"]=dst
			print(getFMSData("irsLat").." "..lat)
			print(getFMSData("irsLon").." "..lon)
			setFMSData("irsLat",lat)
			setFMSData("irsLon",lon)
			irsSystem["irsLat"]=lat
			irsSystem["irsLon"]=lon
			irsSystem["setPos"]=true
			fmsModules["data"]["initIRSLat"]=lat
			fmsModules["data"]["initIRSLon"]=lon
		else
			fmsO["notify"]="INVALID ENTRY"
		end
--      if fmsModules["fmsL"].notify=="ENTER IRS POSITION" then fmsModules["fmsL"].notify="" end
--      if fmsModules["fmsC"].notify=="ENTER IRS POSITION" then fmsModules["fmsC"].notify="" end
--      if fmsModules["fmsR"].notify=="ENTER IRS POSITION" then fmsModules["fmsR"].notify="" end

   elseif value=="origin" then
	if string.len(fmsO["scratchpad"])>0 then
     fmsFunctions["custom2fmc"](fmsO,"L1")
     fmsModules:setData("crzalt","*****") -- clear cruise alt /crzalt when entering a new source airport (this is broken and currently disabled)
	else
		fmsO["notify"]="INVALID ENTRY"
	end
	elseif value=="airportgate" then
		if string.len(fmsO["scratchpad"]) <= 5 then
			--[[local lat=toDMS(simDR_latitude,true)
			local lon=toDMS(simDR_longitude,false)
			setFMSData("irsLat",lat)
			setFMSData("irsLon",lon)]]
			fmsModules["data"].airportgate = fmsO["scratchpad"]
		else
			fmsO["notify"]="INVALID ENTRY"
		end
		return
	elseif value == "sethdg" then
		if validate_sethdg(fmsO["scratchpad"]) == false then
			fmsO["notify"]="INVALID ENTRY"
		else
			if fmsModules["data"] ~= "---`" then -- what?
				if (fmsO["scratchpad"] == "0" or fmsO["scratchpad"] == "00" or fmsO["scratchpad"] == "000") then
					fmsO["scratchpad"] = "360`"
				end
				setFMSData(value, fmsO["scratchpad"].."`")
				--timer_start = simDRTime
			end
		end
		return
	elseif value == "vref1" then
		fmsO["scratchpad"]=string.format("25/%3d", B777DR_airspeed_Vf25)
		return
	elseif value == "vref2" then
		fmsO["scratchpad"]=string.format("30/%3d", B777DR_airspeed_Vf30)
		return
	elseif value == "flapspeed" then
		if fmsO["scratchpad"]=="" then
			B777DR_airspeed_VrefFlap=0
			setFMSData(value,"")
			return
		end
		local vref=tonumber(string.sub(fmsO["scratchpad"],4))
		if vref==nil or vref<110 or vref>180 then
			fmsO["notify"]="INVALID ENTRY"
			return
		end
		B777DR_airspeed_Vref=vref
		print(string.sub(fmsO["scratchpad"],1,2))
		if string.sub(fmsO["scratchpad"],1,2) == "25" then
			B777DR_airspeed_VrefFlap=1
		else
			B777DR_airspeed_VrefFlap=2
		end	
		setFMSData(value,fmsO["scratchpad"])
		return
	elseif value == "drag_ff" then
		if fmsO["scratchpad"] == "ARM" then
			if getFMSData("dragFF_armed") == "ARM" then
				setFMSData("dragFF_armed", "   ")
			else
				setFMSData("dragFF_armed", "ARM")
			end
			fmsO["scratchpad"] = ""
			return
		else
			if getFMSData("dragFF_armed") == "ARM" then
				local result = validateDragFF(fmsO["scratchpad"])
				print("1: "..tostring(result[1]))
				if result[1] then
					print("result: "..result[2])
					setSimConfig("FMC", "drag_ff", result[2])
					fmsO["scratchpad"] = ""
					return
				end
			end
		end
		fmsO["notify"]="INVALID ENTRY"
		return
	elseif value == "costindex" then -- invalid within 10 miles of td
		local numInput = tonumber(fmsO["scratchpad"])
		if numInput then
			if numInput <= 9999 and numInput >= 0 then
				fmsModules["data"].costindex = fmsO["scratchpad"]
				fmsO["scratchpad"] = ""
				return
			end
		end
		fmsO["notify"] = "INVALID ENTRY" -- should also be invalid within 10nm of t/d
		return
	elseif value == "minfueltemp" then
		local numInput = tonumber(fmsO["scratchpad"])
		if numInput then
			if numInput <= -1 and numInput >= -99 then
				fmsO["scratchpad"] = ""
				setSimConfig("FMC", "min_fuel_temp", numInput)
				return
			end
		end
		fmsO["notify"] = "INVALID ENTRY"
		return
	elseif value == "perfinitfuel" then
        local input = fmsO["scratchpad"]
        if tonumber(input) then
            local mode = getSimConfig("PLANE", "weight_display_units")
            local numInput = mode == "LBS" and tonumber(input) / kgs_to_lbs or tonumber(input)
            if numInput > 0 and numInput <= 148.6 and (fmsModules["data"].fmcFuel.mode == "CALC" or fmsModules["data"].fmcFuel.mode == "MANUAL") then
                fmsModules["data"].fmcFuel.mode = "MANUAL"
				totalizerInitkgs = numInput * 1000
				totalizerSumkgs = 0.0
				fmsModules["data"].fmcFuel.value = numInput * 1000
                fmsO["scratchpad"] = ""
                return
            end
        end
        fmsO["notify"] = "INVALID ENTRY"
        return
	elseif value == "grwt" then

		local numInput
		local mode = getSimConfig("PLANE", "weight_display_units")

		if fmsO["scratchpad"] ~= "" and tonumber(fmsO["scratchpad"]) then
			numInput = tonumber(string.format("%3.1f", fmsO["scratchpad"]))
			if mode == "LBS" then
				numInput = numInput / kgs_to_lbs
			end
			if numInput > 352.4 or numInput - (simDR_total_fuel_kgs / 1000) < 166.4 then
				fmsO["notify"] = "INVALID ENTRY"
				return
			end
		elseif fmsO["scratchpad"] == "" then -- blank entry, autofill
			fmsModules["data"].grwt = string.format("%3.1f", simDR_gross_wt_kgs / 1000)
			fmsModules["data"].zfw = string.format("%3.1f", (simDR_gross_wt_kgs - simDR_total_fuel_kgs) / 1000)
			return
		else
			fmsO["notify"] = "INVALID ENTRY"
			return
		end

		fmsO["scratchpad"] = ""
		fmsModules["data"].grwt = string.format("%3.1f", numInput)
		fmsModules["data"].zfw = string.format("%3.1f", numInput - (simDR_total_fuel_kgs / 1000))
		--fmsO["notify"] = "TAKEOFF SPEEDS DELETED" --TODO: vspds
		return
	elseif value == "zfw" then
		local numInput
		local mode = getSimConfig("PLANE", "weight_display_units")

		if fmsO["scratchpad"] ~= "" and tonumber(fmsO["scratchpad"]) then
			numInput = tonumber(string.format("%3.1f", fmsO["scratchpad"]))
			if mode == "LBS" then
				numInput = numInput / kgs_to_lbs
			end
			if (simDR_total_fuel_kgs / 1000) + numInput > 352.4 or numInput < 166.4 then
				fmsO["notify"] = "INVALID ENTRY"
				return
			end
		elseif fmsO["scratchpad"] == "" then -- blank entry, autofill
			fmsModules["data"].grwt = string.format("%3.1f", simDR_gross_wt_kgs / 1000)
			sfmsModules["data"].zfw = string.format("%3.1f", (simDR_gross_wt_kgs - simDR_total_fuel_kgs) / 1000)
			return
		else
			fmsO["notify"] = "INVALID ENTRY"
			return
		end

		fmsO["scratchpad"] = ""
		fmsModules["data"].grwt = string.format("%3.1f", (simDR_total_fuel_kgs / 1000) + numInput)
		fmsModules["data"].zfw = string.format("%3.1f", numInput)
		--fmsO["notify"] = "TAKEOFF SPEEDS DELETED"
		return
	elseif value == "reserves" then
		local numInput = tonumber(fmsO["scratchpad"])
		if numInput then
			if getSimConfig("PLANE", "weight_display_units") == "LBS" then
				numInput = numInput / kgs_to_lbs
			end
			if numInput > 0 and numInput < simDR_total_fuel_kgs then
				fmsModules["data"].reserves = string.format("%3.1f", numInput)
				fmsO["scratchpad"] = ""
			return
			end
		end
		fmsO["notify"] = "INVALID ENTRY"
		return
	elseif value == "crzcg" then
		local numInput = tonumber(fmsO["scratchpad"])
		if numInput then
			if numInput >= 7.5 and numInput <= 44 then
				fmsModules["data"].crzcg = string.format("%2.1f%%", numInput)
				fmsO["scratchpad"] = ""
				return
			end
		end
		fmsO["notify"] = "INVALID ENTRY"
		return
	elseif value == "stepsize" then
		local numInput = tonumber(fmsO["scratchpad"])
		if fmsO["scratchpad"] == "ICAO" or fmsO["scratchpad"] == "RVSM" then
			fmsModules["data"].stepsize = fmsO["scratchpad"]
			fmsO["scratchpad"] = ""
			return
		end
		if not numInput then
			fmsO["notify"] = "INVALID ENTRY"
			return
		end
		if numInput < 0 or numInput > 9000 or numInput % 1000 ~= 0 then  --ensure increments of 1000
			fmsO["notify"] = "INVALID ENTRY"
			return
		end
		fmsModules["data"].stepsize = fmsO["scratchpad"]
		fmsO["scratchpad"] = ""
		return
  elseif value == "cg_mac" then
	if string.match(fmsO["scratchpad"], "%a") or string.match(fmsO["scratchpad"], "%s") or fmsModules["data"].cg_mac == "--" then
		fmsO["notify"] = "INVALID ENTRY"
		return
	elseif string.len(fmsO["scratchpad"]) > 0 then 
		calc_stab_trim(fmsModules["data"].grwt, fmsO["scratchpad"])
		setFMSData(value, fmsO["scratchpad"])
	else
		calc_stab_trim(fmsModules["data"].grwt, fmsModules["data"].cg_mac)
	end
	cg_lineLg = string.format("%2.0f%%", tonumber(fmsModules["data"].cg_mac))
   elseif value=="atc" then
		setFMSData(value,fmsO["scratchpad"])
		
		fmsFunctions["acarsLogonATC"](fmsO,"Logon " .. fmsO["scratchpad"])
	elseif value=="fltdepatc" then
		setFMSData("atc",fmsModules.data["fltdep"])
		
		fmsFunctions["acarsLogonATC"](fmsO,"Logon " .. fmsModules.data["fltdep"])
	elseif value=="fltdstatc" then
		setFMSData("atc",fmsModules.data["fltdst"])
		
		fmsFunctions["acarsLogonATC"](fmsO,"Logon " .. fmsModules.data["fltdst"])	
	elseif value=="metarreq" then	
		fmsFunctions["acarsATCRequest"](fmsO,"REQUEST METAR")	
	elseif value=="tafreq" then	
		fmsFunctions["acarsATCRequest"](fmsO,"REQUEST TAF")	
	end
end

function fmsFunctions.setDref(fmsO,value)
	local val=tonumber(fmsO["scratchpad"])
	print(fmsO.id)

	-----STRATOSPHERE 777----------

	if value == "dspCtrl" then
		if fmsO.id == "fmsL" then
			if B777DR_cdu_eicas_ctl[1] == 0 and B777DR_cdu_eicas_ctl[2] == 0 then
				B777DR_cdu_eicas_ctl[0] = 1 - B777DR_cdu_eicas_ctl[0]
			else
				fmsModules["fmsL"].notify="KEY/FUNCTION INOP"
			end
		elseif fmsO.id == "fmsC" then
			if B777DR_cdu_eicas_ctl[0] == 0 and B777DR_cdu_eicas_ctl[2] == 0 then
				B777DR_cdu_eicas_ctl[1] = 1 - B777DR_cdu_eicas_ctl[1]
			else
				fmsModules["fmsC"].notify="KEY/FUNCTION INOP"
			end
		else
			if B777DR_cdu_eicas_ctl[0] == 0 and B777DR_cdu_eicas_ctl[1] == 0 then
				B777DR_cdu_eicas_ctl[2] = 1 - B777DR_cdu_eicas_ctl[2]
			else
				fmsModules["fmsR"].notify="KEY/FUNCTION INOP"
			end
		end
		return
	end

	if value == "efisCtrl" then
		if fmsO.id == "fmsL" then
			B777DR_cdu_efis_ctl[0] = 1 - B777DR_cdu_efis_ctl[0]
		elseif fmsO.id == "fmsR" then
			B777DR_cdu_efis_ctl[1] = 1 - B777DR_cdu_efis_ctl[1]
		else
			fmsModules["fmsC"].notify="KEY/FUNCTION INOP"
		end
		return
	end


	----- SPARKY 744 ----------

  if value=="VNAVS1" and B777DR_ap_vnav_system ~=1.0 then B777DR_ap_vnav_system=1 return elseif value=="VNAVS1" then B777DR_ap_vnav_system=0 return end 
  if value=="VNAVS2" and B777DR_ap_vnav_system ~=2.0 then B777DR_ap_vnav_system=2 return elseif value=="VNAVS2" then B777DR_ap_vnav_system=0 return end 
  if value=="VNAVSPAUSE" then 
	if B777DR_ap_vnav_pause>0 then 
		B777DR_ap_vnav_pause=0
	else
		B777DR_ap_vnav_pause=1 
	end 
	return 
	end 
  if value=="CHOCKS" then
	B777DR__gear_chocked = 1 - B777DR__gear_chocked
	--Stop refueling operation if CHOCKS are removed
	if B777DR__gear_chocked == 0 then
		B777DR_refuel=0.0
	end
	return
  end
  if value=="PAUSEVAL" then
	local numVal=tonumber(fmsO["scratchpad"])
	fmsO["scratchpad"]="" 
	if numVal==nil then fmsO["notify"]="INVALID ENTRY" return end
	if numVal>999 then numVal=999 end
	if numVal<=1 then numVal=1 end
	B777DR_ap_vnav_pause=numVal
	return 
  end


 	
  if value=="TO" then toderate=0 clbderate=0 return  end
  if value=="TO1" then toderate=1 clbderate=1 return  end
  if value=="TO2" then toderate=2 clbderate=2 return  end
  if value=="CLB" then clbderate=0 return  end
  if value=="CLB1" then clbderate=1 return  end
  if value=="CLB2" then clbderate=2  return end
  if value=="ILS" then 
    if findILS(fmsO["scratchpad"])==false then fmsO["notify"]="INVALID ENTRY" end
    fmsO["scratchpad"]="" 
    return 
  end
  local modes=B777DR_radioModes
  if value=="VORL" and val==nil then B777DR_radioModes=replace_char(2,modes,"A") fmsO["scratchpad"]="" return end
  if value=="VORR" and val==nil then B777DR_radioModes=replace_char(3,modes,"A") fmsO["scratchpad"]="" return end
   if val==nil or (value=="CRSL" and modes:sub(2, 2)=="A") or (value=="CRSR" and modes:sub(3, 3)=="A") then
     fmsO["notify"]="INVALID ENTRY"
     return 
   end
 --print(val)
  if value=="VORL" then B777DR_radioModes=replace_char(2,modes,"M") simDR_radio_nav_freq_hz[2]=val*100  end
  if value=="VORR" then B777DR_radioModes=replace_char(3,modes,"M") simDR_radio_nav_freq_hz[3]=val*100  end
  if value=="CRSL" then simDR_radio_nav_obs_deg[2]=val end
  if value=="CRSR" then simDR_radio_nav_obs_deg[3]=val end
  if value=="ADFL" then simDR_radio_adf1_freq_hz=val end
  if value=="ADFR" then simDR_radio_adf2_freq_hz=val end
  if value=="V1" then
	if val<100 or val>200 then
		fmsO["notify"]="INVALID ENTRY"
     	return 
	end
	B777DR_airspeed_V1=val 
  end
  if value=="VR" then
	if val<100 or val>200 then
		fmsOsetsound["notify"]="INVALID ENTRY"
     	return 
	end
	
	B777DR_airspeed_Vr=val 
  end
  if value=="V2" then
	if val<100 or val>200 then
		fmsO["notify"]="INVALID ENTRY"
     	return 
	end
	B777DR_airspeed_V2=val 
  end
  if value=="flapsRef" then 
	if val~=10 and val~=20 then
		fmsO["notify"]="INVALID ENTRY"
     	return 
	end
	B777DR_airspeed_flapsRef=val 
  end

  fmsO["scratchpad"]=""
end

function fmsFunctions.showmessage(fmsO,value)
  acarsSystem.currentMessage=value
  --fmsO["inCustomFMC"]=true
  fmsO["targetPage"]="VIEWACARSMSG"
  run_after_time(switchCustomMode, 0.5)
end

function fmsFunctions.doCMD(fmsO,value)
  --[[if fmsModules["cmds"][value] ~= nil then
	fmsModules["cmds"][value]:once()
	fmsModules["lastcmd"]=fmsModules["cmdstrings"][value]
  end]]
	find_command(value):once()
	print("do fmc command "..value)
end

function setEicasPage(id)
	print(id)
	if B777DR_eicas_mode == id then
		B777DR_eicas_mode = 0
	else
		B777DR_eicas_mode = id
	end
end

function fmsFunctions.setDisp(fmsO, value)

	if value == "eicasEng" then
		setEicasPage(4)
		return
	end
	if value == "eicasStat" then
		setEicasPage(9)
		return
	end
	if value == "eicasChkl" then
		setEicasPage(10)
		return
	end
	if value == "eicasDoor" then
		setEicasPage(2)
		return
	end
	if value == "eicasGear" then
		setEicasPage(7)
		return
	end
	if value == "eicasElec" then
		setEicasPage(3)
		return
	end
	if value == "eicasHyd" then
		setEicasPage(8)
		return
	end
	if value == "eicasFuel" then
		setEicasPage(6)
		return
	end
	if value == "eicasAir" then
		setEicasPage(1)
		return
	end
	if value == "eicasFctl" then
		setEicasPage(5)
		return
	end
	if value == "eicasEng" then
		setEicasPage(4)
		return
	end

	if value=="adfvor" then
		if fmsO.id=="fmsL" then
			if vor_adf[1] == 0 then
				vor_adf[1] = 2
			elseif vor_adf[1] == 2 then
				vor_adf[1] = 1
			else
				vor_adf[1] = 0
			end
		else
			if vor_adf[2] == 0 then
				vor_adf[2] = 2
			elseif vor_adf[2] == 2 then
				vor_adf[2] = 1
			else
				vor_adf[2] = 0
			end
		end
		return
	end

	if fmsO.id == "fmsL" then
		if value == "wxr" then
			find_command("sim/instruments/EFIS_wxr"):once()
		elseif value == "fix" then
			find_command("sim/instruments/EFIS_fix"):once()
		elseif value == "apt" then
			find_command("sim/instruments/EFIS_apt"):once()
		elseif value == "terr" then
			find_command("sim/instruments/EFIS_terr"):once()
		elseif value == "tcas" then
			find_command("sim/instruments/EFIS_tcas"):once()
		elseif value == "minsRst" then
			find_command("Strato/777/minimums_rst_capt_fmc"):once()
		elseif value == "sta" then
			B777DR_nd_sta[0] = 1 - B777DR_nd_sta[0]
		elseif value == "zoomOut" then
			find_command("sim/instruments/map_zoom_out"):once()
		elseif value == "zoomIn" then
			find_command("sim/instruments/map_zoom_in"):once()
		elseif value == "mtrs" then
			B777DR_pfd_mtrs[0] = 1 - B777DR_pfd_mtrs[0]
		elseif value == "mapMode_0" then
			simDR_nd_mode[1] = 0
		elseif value == "mapMode_1" then
			simDR_nd_mode[1] = 1
		elseif value == "mapMode_2" then
			simDR_nd_mode[1] = 3
		elseif value == "mapMode_3" then
			simDR_nd_mode[1] = 4
		elseif value == "mapMode_4" then
			simDR_map_hsi[1] = 1 - simDR_map_hsi[1]
		elseif value == "radBaro" then
			B777DR_minimums_mode[0] = 1 - B777DR_minimums_mode[0]
		end
		return
	else
		if value == "wxr" then
			find_command("sim/instruments/EFIS_copilot_wxr"):once()
		elseif value == "fix" then
			find_command("sim/instruments/EFIS_copilot_fix"):once()
		elseif value == "apt" then
			find_command("sim/instruments/EFIS_copilot_apt"):once()
		elseif value == "terr" then
			find_command("sim/instruments/EFIS_copilot_terr"):once()
		elseif value == "tcas" then
			find_command("sim/instruments/EFIS_copilot_tcas"):once()
		elseif value == "minsRst" then
			find_command("Strato/777/minimums_rst_fo_fmc"):once()
		elseif value == "sta" then
			B777DR_nd_sta[1] = 1 - B777DR_nd_sta[1]
		elseif value == "zoomOut" then
			find_command("sim/instruments/map_copilot_zoom_out"):once()
		elseif value == "zoomIn" then
			find_command("sim/instruments/map_copilot_zoom_in"):once()
		elseif value == "mtrs" then
			B777DR_pfd_mtrs[1] = 1 - B777DR_pfd_mtrs[1]
		elseif value == "mapMode_0" then
			simDR_nd_mode[2] = 0
		elseif value == "mapMode_1" then
			simDR_nd_mode[2] = 1
		elseif value == "mapMode_2" then
			simDR_nd_mode[2] = 3
		elseif value == "mapMode_3" then
			simDR_nd_mode[2] = 4
		elseif value == "mapMode_4" then
			simDR_map_hsi[2] = 1 - simDR_map_hsi[2]
		elseif value == "radBaro" then
			B777DR_minimums_mode[1] = 1 - B777DR_minimums_mode[1]
		end
		return
	end
end

function fmsFunctions.setpage2(fmsO, value)
	if value == "FMC" then
		if fmsO.id ~= "fmsC" then
			local excludedPages = "EFISCTL152, EFISOPTIONS152, EICASMODES, EICASSYN, README, INDEX"
			local idNum = fmsO.id == "fmsL" and 0 or 1
			if excludedPages:match(fmsModules[fmsO.id]["prevPage"]) then
				B777DR_cdu_act[idNum] = 1
				fmsFunctions["setpage"](fmsO,"IDENT")
			else
				fmsFunctions["setpage"](fmsO,fmsModules[fmsO.id]["prevPage"])
			end
			return
		end
		fmsModules["fmsC"].notify="KEY/FUNCTION INOP"
		return
	end

	if value == "EICASMODES" then
		if fmsO.id == "fmsL" then
			if B777DR_cdu_eicas_ctl[0] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		elseif fmdO.id == "fmsC" then
			if B777DR_cdu_eicas_ctl[1] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		else
			if B777DR_cdu_eicas_ctl[2] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		end
		return
	end

	if value == "EFISOPTIONS152" then
		if fmsO.id == "fmsL" then
			if B777DR_cdu_efis_ctl[0] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		elseif fmsO.id == "fmsR" then
			if B777DR_cdu_efis_ctl[1] == 1 then
				fmsFunctions["setpage"](fmsO,value)
			else
				fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
			end
		else
			fmsModules[fmsO.id].notify="KEY/FUNCTION INOP"
		end
		return
	end

	if value == "MENU" then
		if getSimConfig("FMC", "unlocked") == 1 then
			fmsFunctions["setpage"](fmsO,"INDEX")
		else
			fmsModules[fmsO.id].notify="CDU LOCKED"
		end
	end
end

function lim(val, upper, lower)
	if val > upper then
		return upper
	elseif val < lower then
		return lower
	end
	return val
end

function tableLen(T) --Returns length of a table
	local idx = 0
	for i in pairs(T) do idx = idx + 1 end
	return idx
end

function bool2num(value)
	return value and 1 or 0
end

function round(number) --rounds everything behind the decimal
	return math.floor(number + 0.5)
end

function indexOf(array, value) --returns index of a value in an array.
    for k, v in ipairs(array) do
        if v == value then
            return k
        end
    end
    return nil
end

function animate(target, variable, speed)
	if math.abs(target - variable) < 0.1 then return target end
	variable = variable + ((target - variable) * (speed * SIM_PERIOD))
	return variable
end

function ternary(condition, ifTrue, ifFalse)
	if condition then return ifTrue else return ifFalse end
end

--[[B777DR_print_input = find_dataref("Strato/777/print_input");
B777CMD_print = find_command("Strato/777/fmc_print");

function print(input)
	B777DR_print_input = input
	B777CMD_print:once()
end

B777DR_metar_input = find_dataref("Strato/777/metar_input")
B777DR_metar_output = find_dataref("Strato/777/metar_output")
B777CMD_getMetar = find_command("Strato/777/get_metar")

function fetchMetar(icao)
	B777DR_metar_input = icao
	getMetar:once()
	return B777DR_metar_output
	waint until output changes
end]]