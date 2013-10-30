local http = require("socket.http")
local baseAddress = "http://halo.bungie.net/stats/playerstatshalo3.aspx?player=MaritalWheat&ctl00_mainContent_bnetpgl_recentgamesChangePage="
local check = false;
local write = io.write

io.output(io.open("Test.txt", "w"))

for addresser = 1, 5, 1 do
	local dataSegToMatch = "</td><td>";
	local endOfSeg = "<a";
	local page = http.request(baseAddress .. addresser)

	write ("Page: " .. addresser .. "-----------------")
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
					write(strToMatch)
				end
			end
		end
		
		if (check) then
			if (token == endOfSeg) then
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

io.close()