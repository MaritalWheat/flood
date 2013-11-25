local sockethelper = dofile("/Users/emanuelrosu/Documents/the-flood/src/sockethelper.lua");
local rankpatterns = dofile("/Users/emanuelrosu/Documents/the-flood/src/rankpatterns.lua");
local baseAddress = "http://halo.bungie.net/stats/halo3/rankhistory.aspx?player=";

function GetHighestRank(player_name)
	local dataSegToMatch = "ctl00_mainContent_lblSkill";
	local address = baseAddress .. player_name;
	local x, y = GetPatternBounds(address, dataSegToMatch);
	
	local rough = GetSubString(address, y + 3, y + 4);
	local refined = "";
	if (string.sub(rough, 2, 2) == "<") then
		refined = string.sub(rough, 1, 1);
	else
		refined = rough;
	end
	return refined;
end

function GetDateRank(address, to_match) 
	local x, y = GetPatternBounds(address, to_match);
	
	if (y == nil) then return "Rank Not Achieved" end;
	
	local rough = GetSubString(address, y + 128, y + 160);
	
	local refined = "";
	local iterate = true;
	local itr = 1;
	while (iterate) do
		local append = string.sub(rough, itr, itr);
		if (append ~= "<") then
			refined = refined .. append;
			itr = itr + 1;
		else
			iterate = false;
			break;
		end
	end
	return refined;
end

function GetDateSergeant(player_name)
	local dataSegToMatch = GetSergeantPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

function GetDateLieutenant(player_name)
	local dataSegToMatch = GetLieutenantPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

function GetDateCaptain(player_name)
	local dataSegToMatch = GetCaptainPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

function GetDateMajor(player_name)
	local dataSegToMatch = GetMajorPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

function GetDateCommander(player_name)
	local dataSegToMatch = GetCommanderPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

function GetDateColonel(player_name)
	local dataSegToMatch = GetColonelPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

function GetDateBrigadier(player_name)
	local dataSegToMatch = GetBrigadierPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

function GetDateGeneral(player_name)
	local dataSegToMatch = GetGeneralPattern();
	local address = baseAddress .. player_name;
	return GetDateRank(address, dataSegToMatch);
end

print(GetHighestRank("MaritalWheat"));
print(GetDateLieutenant("MaritalWheat"));
print(GetDateCaptain("MaritalWheat"));
print(GetDateMajor("MaritalWheat"));
print(GetDateCommander("MaritalWheat"));
print(GetDateColonel("MaritalWheat"));
print(GetDateBrigadier("MaritalWheat"));
print(GetDateGeneral("MaritalWheat"));