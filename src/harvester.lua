local http = require("socket.http")
local db_reader = dofile("/Users/emanuelrosu/Documents/the-flood/src/db_reader.lua");
local ranker = dofile("/Users/emanuelrosu/Documents/the-flood/src/ranker.lua");

local player_table = {};

player_table = db_read();

local address_prefix = "http://halo.bungie.net/stats/playerstatshalo3.aspx?player=";
local address_suffix = "&ctl00_mainContent_bnetpgl_recentgamesChangePage=";
local player_name = "MaritalWheat";
local check = false;
local write = io.write;

io.output(io.open("Test.txt", "w"))

local itr = 1;
player_name = player_table[itr];

while (itr < 1000) do
	
	local valid_data = 1;
	local page_index = 0;
	--for addresser = 1, 5, 1 do
	while (valid_data == 1) do
		page_index = page_index + 1;
		local dataSegToMatch = "</td><td>";
		local endOfSeg = "<a";
		local page;
		while (page == nil) do
			page = http.request(address_prefix .. player_name .. address_suffix .. page_index)
		end
		valid_data = 0; --assume page does not contain valid data
		--write ("Page: " .. page_index .. "-----------------")
		for token in string.gmatch(page, "%g+") do
			local check_seg = string.sub(token, 0, string.len(dataSegToMatch));
			local first_char = string.sub(token, 0, 1)
			if (first_char == 'h') then  --know we have a game header
				local tokLength = string.len(token)
				local strToMatch = "gameid="
				local strToMatchLen = string.len(strToMatch)
				local tokenItr = 0;
				for itr = tokenItr, tokLength - strToMatchLen, 1 do
					--print(string.sub(token, itr, itr+strToMatchLen - 1))
					if (string.sub(token, itr, itr+strToMatchLen - 1) == strToMatch) then 
						--write(strToMatch)
						valid_data = 1; --we have found game data
					end
				end
			end
			
			if (check) then
				if (token == endOfSeg) then
					write(player_name);
					write(" | ");
					write(GetHighestRank(player_name));
					write(" | ");
					write(GetDateLieutenant(player_name));
					write(" | ");
					write(GetDateCaptain(player_name));
					write(" | ");
					write(GetDateCommander(player_name));
					write(" | ");
					write(GetDateColonel(player_name));
					write(" | ");
					write(GetDateBrigadier(player_name));
					write(" | ");
					write(GetDateGeneral(player_name));
					write("\n");
					check = false
				elseif (token ~= dataSegToMatch) then
					write(token);
					write(" ");
				else 
					write(" | ");
				end
			end
			
			if (check_seg == dataSegToMatch) then
				--print (check_seg);
				check = true;
			end
			
		end
	end
	
	itr = itr + 1;
	player_name = player_table[itr];
end	

io.close()