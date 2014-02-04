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

function parse_rank_date(in_string)
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

	--print(out.month);
	--print(out.date);
	--print(out.year);
	return out;
end

function parse_game_date(input)
	local out = {month = "-", date = "-", year = "-"};

	local split_results = input:split(" ");
	if (split_results[1] == nil) then return out end;

	local date_table = split_results[1]:split("/")
	if (date_table[1] == nil) then return out end;
	if (date_table[2] == nil) then return out end;
	if (date_table[3] == nil) then return out end;

	out.month = date_table[1];
	out.date = date_table[2];
	out.year = date_table[3];
	return out;
end 

--expects properly formatted parameters!
--returns true if game date before rank date, false otherwise
function date_compare(game_date, rank_date)
	if (game_date.year < rank_date.year) then return true end;
	if (game_date.year > rank_date.year) then return false end;
	
	if (game_date.month < rank_date.month) then return true end;
	if (game_date.month > rank_date.month) then return false end;

	if (game_date.date < rank_date.date) then return true end;
	if (game_date.date > rank_date.date) then return false end;

	--if exact same date, give game to lower rank
	return true;
end

data = get_path();

local data_index = 1;
local line = data[data_index];

local player_table = {};

local curr_player;
local date_lieutenant;
local date_captain;
local date_commander;
local date_colonel;
local date_brigadier;
local date_general;

local date1 = {month = "2", date = "10", year = "2012"};
local date2 = {month = "2", date = "1", year = "2012"};

print(date_compare(date1, date2));

while(line ~= nil) do
	
	--format: [time date] [map] [gametype] [place] [name] [highest rank] [rank1] [rank2] [rank3] [rank4] [rank5] [rank6]
	
	split_line = line:split(" | ");

	local game_date = parse_game_date(split_line[1]);
	--print(game_date.month .. "/" .. game_date.date .. "/" .. game_date.year);

	--case for first player in file
	if (curr_player == nil) then 
		curr_player = split_line[5];
		date_lieutenant = parse_rank_date(split_line[7]);
		date_captain = parse_rank_date(split_line[8]);
		date_commander = parse_rank_date(split_line[9]);
		date_colonel = parse_rank_date(split_line[10]);
		date_brigadier = parse_rank_date(split_line[11]);
		date_general = parse_rank_date(split_line[12]);
	end

	if (split_line[5] ~= curr_player) then

		--check if player name is "unreliable"
		local user_validation = string.sub(split_line[5], 0, 10);

		if (user_validation ~= "unreliable") then
			--create Player object
			local Player = {name = curr_player, date_lt = date_lieutenant, date_ct = date_captain,
				date_com = date_commander, date_col = date_colonel, date_bg = date_brigadier,
				date_gen = date_general};

			--insert Player object into table
			table.insert(player_table, Player);
			
			--print(Player.name .. " " .. Player.date_lt.month .. "/" .. Player.date_lt.date .. "/" .. Player.date_lt.year);
			
			--update current player
			curr_player = split_line[5];
			date_lieutenant = parse_rank_date(split_line[7]);
			date_captain = parse_rank_date(split_line[8]);
			date_commander = parse_rank_date(split_line[9]);
			date_colonel = parse_rank_date(split_line[10]);
			date_brigadier = parse_rank_date(split_line[11]);
			date_general = parse_rank_date(split_line[12]);
		end
	end

	data_index = data_index + 1;
	line = data[data_index];
end

print("Number of entries: " .. #player_table);



