local writable = io.open("/Users/emanuelrosu/iMacros/Macros/fruitmacro.js", "r+");
local readable = io.open("/Users/emanuelrosu/iMacros/Macros/fruitmacro.js", "r+");
local dictionary = io.open("/usr/share/dict/words");
local offset = 0;
local linenumber = 0;
local final_offset = 0;
local rest_of_file = "";
local record = false;
local search_terms = {}
local MAX_SEARCH_TERMS = 10000;
local SEED_VALUE = 25;

function Create_Searchables(num_terms, seek_value) 
	local count = 1
	for i = 1, num_terms, 1 do
		local SEARCH_TERM = search_terms[count]
		if (SEARCH_TERM ~= nil) then
			if SEARCH_TERM:len() >= 4 then SEARCH_TERM = SEARCH_TERM:sub(0, 4) end
			count = count + 1
			local to_write = "search_terms.push(\"" .. SEARCH_TERM .. "\")\n"
			writable:seek("set", seek_value);
			writable:write(to_write);
			seek_value = seek_value + to_write:len()
		else
			break
		end
	end
	--writable:seek("set", seek_value);
	--writable:write(rest_of_file);
end

local count = 1;
local line_number = 0;

for line in dictionary:lines() do
	if line == nil then break end
	if (line_number % SEED_VALUE) == 1 then
		search_terms[count] = line
		count = count + 1;
		if count == MAX_SEARCH_TERMS then break end
	end
	line_number = line_number + 1
end	

local do_add_term = false;

for line in readable:lines() do
	--local line = io.read("*l")
	
	if line == nil then break end
	
	if (line == "//[BUILD-TAG]") then
		offset = offset + line:len()
		do_add_term = true;
	end
	
	if (do_add_term) then
		offset = offset + line:len()
		offset = offset + 1
		final_offset = offset
		do_add_term = false;
		record = true;	
	elseif record then 
		rest_of_file = rest_of_file .. line
	end
	
	if line == "" then offset = offset + 1 end
	offset = offset + line:len()
end

Create_Searchables(MAX_SEARCH_TERMS, final_offset);

writable:close();
readable:close();
dictionary:close();
