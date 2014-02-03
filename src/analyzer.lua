function get_path()
	assert (arg[1] ~= nil);
	local read_path = arg[1];
	local readable = io.open(read_path, "r");
	
	local data_table = {};
	
	if (readable ~= nil) then
		for line in readable:lines() do
			if (line == nil) then break end;
			--print(line);
			table.insert(data_table, line);
		end
		readable:close();
	end
	return data_table;
end

function string:split(inSplitPattern, outResults)

   if not outResults then
      outResults = { }
   end
   local theStart = 1
   local theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   while theSplitStart do
      table.insert( outResults, string.sub( self, theStart, theSplitStart-1 ) )
      theStart = theSplitEnd + 1
      theSplitStart, theSplitEnd = string.find( self, inSplitPattern, theStart )
   end
   table.insert( outResults, string.sub( self, theStart ) )
   return outResults
end

data = get_path();

local data_index = 1;
local line = data[data_index];

local player_table = {};

local curr_player;

while(line ~= nil) do
	
	--format: [time date] [map] [gametype] [place] [name] [highest rank] [rank1] [rank2] [rank3] [rank4] [rank5] [rank6]
	
	split_line = line:split(" | ");

	--case for first player in file
	if (curr_player == nil) then curr_player = split_line[5] end;

	if (split_line[5] ~= curr_player) then

		--check if player name is "unreliable"
		local user_validation = string.sub(split_line[5], 0, 10);

		if (user_validation ~= "unreliable") then
			--create Player object
			local Player = {name = curr_player};
			--insert Player object into table
			table.insert(player_table, Player);
			print(Player.name);
			--update current player
			curr_player = split_line[5];
		end
	end

	data_index = data_index + 1;
	line = data[data_index];
end

print("Number of entries: " .. #player_table);



