local http = require("socket.http")
local baseAddress = "http://halo.bungie.net/stats/playerstatshalo3.aspx?player=MaritalWheat&ctl00_mainContent_bnetpgl_recentgamesChangePage="
for addresser = 1, 5, 1 do
	
	local page = http.request(baseAddress .. addresser)
	print ("Page: " .. addresser .. "-----------------")
	for token in string.gmatch(page, "%g+") do
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
	end
end