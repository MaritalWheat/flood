local http = require("socket.http")
local baseAddress = "http://halo.bungie.net/stats/playerstatshalo3.aspx?player=MaritalWheat&ctl00_mainContent_bnetpgl_recentgamesChangePage="
local check = false;

for addresser = 1, 5, 1 do
	local dataSegToMatch = "</td><td>";
	local page = http.request(baseAddress .. addresser)

	print ("Page: " .. addresser .. "-----------------")
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
					print (strToMatch)
				end
			end
		end
		
		if (check) then
			print (token);
			check = false;
		end
		
		if (check_seg == dataSegToMatch) then
			print (check_seg);
			check = true;
		end
		
	end
end