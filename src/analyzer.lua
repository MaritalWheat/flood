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

function month_to_int(in_string)
	if (in_string == "January") then return 1 end;
	if (in_string == "February") then return 2 end;
	if (in_string == "March") then return 3 end;
	if (in_string == "April") then return 4 end;
	if (in_string == "May") then return 5 end;
	if (in_string == "June") then return 6 end;
	if (in_string == "July") then return 7 end;
	if (in_string == "August") then return 8 end;
	if (in_string == "September") then return 9 end;
	if (in_string == "October") then return 10 end;
	if (in_string == "November") then return 11 end;
	if (in_string == "December") then return 12 end;
end

function parse_date(in_string)
	--input format: [day] [month + date] [year]
	local out = {month = "-", date = "-", year = "-"};
	local input = in_string:split(", ");

	if (input[2] == nil) then return out end;
	if (input[3] == nil) then return out end;

	--split month and date from single entry
	local month_date = input[2]:split(" ");

	if (month_date[1] == nil) then return out end;
	if (month_date[2] == nil) then return out end;

	local month_string = month_date[1];
	local month = month_to_int(month_string);
	local date = month_date[2];
	local year = input[3];

	out.month = month;
	out.date = date;
	out.year = year;

	print(out.month);
	print(out.date);
	print(out.year);
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
			parse_date(split_line[7]);
			--update current player
			curr_player = split_line[5];
		end
	end

	data_index = data_index + 1;
	line = data[data_index];
end

print("Number of entries: " .. #player_table);



