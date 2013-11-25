local http = require("socket.http");
local cachedPage;
local cachedAddress;

function CachePage(address) 
	cachedPage = http.request(address);
	cachedAddress = address;
end

function GetPatternBounds(address, pattern)
	if (address ~= cachedAddress) then
		CachePage(address);
	end
	
	local page = cachedPage;
	
	local x, y = string.find(page, pattern);
	return x, y;
end

function GetSubString(address, start_index, end_index) 
	if (address ~= cachedAddress) then
		CachePage(address);
	end
	
	local page = cachedPage;
	
	return string.sub(page, start_index, end_index);
end