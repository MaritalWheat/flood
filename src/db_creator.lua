local cmd_path = "ls ~/Documents/the-flood/player_pool/";
local file_path = "/Users/emanuelrosu/Documents/the-flood/player_pool/"
local writeable = io.open("/Users/emanuelrosu/Documents/the-flood//player_db.txt", "w");

local count = 0;

f = assert (io.popen (cmd_path))
for line in f:lines() do 
	curr_path =  file_path .. line
	local readable = io.open(curr_path, "r+");
	--print(readable);
	if (readable ~= nil) then
		for line in readable:lines() do
			if line == nil then break end
			local signal = "gamertag is "
			local signal_length = signal:len()
			local line_length = line:len()
			
			if (string.match(line, signal)) then
				for end_index = 1, line_length, 1 do
					local sub = line:sub(0, end_index)
					if (string.match(sub, signal)) then
						local to_write = line:sub(end_index + 1)
						--print(to_write)
						writeable:write(to_write);
						writeable:write("\n");
						count = count + 1;
						break
					end
				end
			end
		end
		readable:close();
	end
end

writeable:write("count: " .. count);
if (writable ~= nil) then
	writeable:close();
end