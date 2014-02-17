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
	local game_day = tonumber(game_date.date);
	local game_month = tonumber(game_date.month);
	local game_year = tonumber(game_date.year);

	local rank_day = tonumber(rank_date.date);
	local rank_month = tonumber(rank_date.month);
	local rank_year = tonumber(rank_date.year);

	--were either of the dates passed in invalid?
	if (game_day == nil or rank_day == nil) then
		return false;
	end

	if (game_year < rank_year) then return true end;
	if (game_year > rank_year) then return false end;
	
	if (game_month < rank_month) then return true end;
	if (game_month > rank_month) then return false end;

	if (game_day < rank_day) then return true end;
	if (game_day > rank_day) then return false end;

	--if exact same date, give game to lower rank
	return true;
end

function check_data_validity(highest_rank, lt, ct, com, col, bg, gen)
	local rank_num = tonumber(highest_rank);
	if (rank_num <= 10 and lt > 0) then return true end;
	if (rank_num <= 20 and lt > 0 and ct > 0) then return true end;
	if (rank_num <= 30 and lt > 0 and ct > 0 and com > 0) then return true end;
	if (rank_num <= 40 and lt > 0 and ct > 0 and com > 0 and col > 0) then return true end;
	if (rank_num <= 45 and lt > 0 and ct > 0 and com > 0 and col > 0 and bg > 0) then return true end;
	if (rank_num <= 50 and lt > 0 and ct > 0 and com > 0 and col > 0 and bg > 0 and gen > 0) then return true end;
	return false;
end

function get_ranked_status(game_mode)
	if (string.match(game_mode, "Big Team Battle") or string.match(game_mode, "Lone Wolves") or string.match(game_mode, "MLG")
		or string.match(game_mode, "Squad Battle") or string.match(game_mode, "Team Control") or string.match(game_mode, "Team Doubles")
		or string.match(game_mode, "Team Objective") or string.match(game_mode, "Team Slayer") or string.match(game_mode, "Team Throwback")) then return true end;
	return false;
end

function write_out(player_table)
	local writeable = io.open("/Users/emanuelrosu/Documents/the-flood/src/test.txt", "w");
	local index = 1;
	local player = player_table[index];
	while (player ~= nil) do
		writeable:write(player.name);
		--writeable:write("," .. player.r_lt / player.games_lt)-- .. "," .. player.s_lt / player.games_lt);
		--writeable:write("," .. player.r_ct / player.games_ct)-- .. "," .. player.s_ct / player.games_ct);
		--writeable:write("," .. player.r_com / player.games_com)-- .. "," .. player.s_com / player.games_com);
		--writeable:write("," .. player.r_col / player.games_col)-- .. "," .. player.s_col / player.games_col);
		--writeable:write("," .. player.r_bg / player.games_bg)-- .. "," .. player.s_bg / player.games_bg);
		--writeable:write("," .. player.r_gen / player.games_gen)-- .. "," .. player.s_gen / player.games_gen);
		
		writeable:write(", " .. player.max_rank);
		writeable:write(", " .. player.num_games);
		writeable:write(", " .. (player.num_games - player.games_lt - player.games_ct - player.games_com - player.games_col - player.games_bg - player.games_gen) / player.num_games);
		writeable:write(", " .. (player.num_ranked - player.r_lt - player.r_ct - player.r_com - player.r_col - player.r_bg - player.r_gen) / player.num_ranked);

		--writeable:write(", " .. player.games_lt / player.num_games);
		--writeable:write(", " .. player.games_ct / player.num_games);
		--writeable:write(", " .. player.games_com / player.num_games);
		--writeable:write(", " .. player.games_col / player.num_games);
		--writeable:write(", " .. player.games_bg / player.num_games);
		--writeable:write(", " .. player.games_gen / player.num_games);
		print(player.name .. " " .. player.num_games .. " " .. player.games_lt);
		index = index + 1;
		player = player_table[index];
		writeable:write("\n");
	end
end

data = get_path();

local data_index = 1;
local line = data[data_index];

local player_table = {};

local curr_player;
local highest_rank;

local date_lieutenant;
local date_captain;
local date_commander;
local date_colonel;
local date_brigadier;
local date_general;

local games_lieutenant = 0;
local games_captain = 0;
local games_commander = 0;
local games_colonel = 0;
local games_brigadier = 0;
local games_general = 0;
local games_ranked = 0;
local games_social = 0;
local total_games_played = 0;

local r_games_lieut = 0;
local s_games_lieut = 0;
local r_games_capt = 0;
local s_games_capt = 0;
local r_games_command = 0;
local s_games_command = 0;
local r_games_col = 0;
local s_games_col = 0;
local r_games_brig = 0;
local s_games_brig = 0;
local r_games_gen = 0;
local s_games_gen = 0;

--is there data that covers all the ranks earned
local validity = false;

--local date1 = {month = "2", date = "10", year = "2012"};
--local date2 = {month = "2", date = "1", year = "2012"};

--print(date_compare(date1, date2));

while(line ~= nil) do
	
	--format: [time date] [map] [gametype] [place] [name] [highest rank] [rank1] [rank2] [rank3] [rank4] [rank5] [rank6]
	
	split_line = line:split(" | ");

	local game_date = parse_game_date(split_line[1]);
	--print(game_date.month .. "/" .. game_date.date .. "/" .. game_date.year);

	--case for first player in file
	if (curr_player == nil) then 
		curr_player = split_line[5];
		highest_rank = split_line[6];
		date_lieutenant = parse_rank_date(split_line[7]);
		date_captain = parse_rank_date(split_line[8]);
		date_commander = parse_rank_date(split_line[9]);
		date_colonel = parse_rank_date(split_line[10]);
		date_brigadier = parse_rank_date(split_line[11]);
		date_general = parse_rank_date(split_line[12]);
	end

	local is_ranked = get_ranked_status(split_line[3]);

	if (is_ranked) then
		games_ranked = games_ranked + 1;
	--	print(split_line[3] .. " | Ranked");
	else 
		games_social = games_social + 1;
	--	print(split_line[3] .. " | Unranked");
	end

	total_games_played = total_games_played + 1;

	if (date_compare(game_date, date_lieutenant)) then 
		games_lieutenant = games_lieutenant + 1; 
		if (is_ranked) then
			r_games_lieut = r_games_lieut + 1;
		else 
			s_games_lieut = s_games_lieut + 1;
		end
	elseif (date_compare(game_date, date_captain)) then 
		games_captain = games_captain + 1;
		if (is_ranked) then
			r_games_capt = r_games_capt + 1;
		else 
			s_games_capt = s_games_capt + 1;
		end
	elseif (date_compare(game_date, date_commander)) then 
		games_commander = games_commander + 1;
		if (is_ranked) then
			r_games_command = r_games_command + 1;
		else 
			s_games_command = s_games_command + 1;
		end
	elseif (date_compare(game_date, date_colonel)) then 
		games_colonel = games_colonel + 1;
		if (is_ranked) then
			r_games_col = r_games_col + 1;
		else 
			s_games_col = s_games_col + 1;
		end
	elseif (date_compare(game_date, date_brigadier)) then 
		games_brigadier = games_brigadier + 1;
		if (is_ranked) then
			r_games_brig = r_games_brig + 1;
		else 
			s_games_brig = s_games_brig + 1;
		end
	elseif (date_compare(game_date, date_general)) then 
		games_general = games_general + 1; 
		if (is_ranked) then
			r_games_gen = r_games_gen + 1;
		else 
			s_games_gen = s_games_gen + 1;
		end
	end;

	--work done if player switched
	if (split_line[5] ~= curr_player) then

		--check if player name is "unreliable"
		local user_validation = string.sub(split_line[5], 0, 10);

		if (user_validation ~= "unreliable") then
			--create Player object
			validity = check_data_validity(highest_rank, games_lieutenant, games_captain, games_commander,
				games_colonel, games_brigadier, games_general);

			debugValid = "invalid";
			if (validity) then debugValid = "valid" end
			print (debugValid .. " (" .. highest_rank .. ")")

			local Player = {name = curr_player, max_rank = highest_rank, date_lt = date_lieutenant, date_ct = date_captain,
				date_com = date_commander, date_col = date_colonel, date_bg = date_brigadier,
				date_gen = date_general, games_lt = games_lieutenant, games_ct = games_captain,
				games_com = games_commander, games_col = games_colonel, games_bg = games_brigadier,
				games_gen = games_general, valid = validity, num_ranked = games_ranked, num_social = games_social, num_games = total_games_played,
				r_lt = r_games_lieut,
				s_lt = s_games_lieut;
				r_ct = r_games_capt,
				s_ct = s_games_capt,
				r_com = r_games_command,
				s_com = s_games_command,
				r_col = r_games_col,
				s_col = s_games_col,
				r_bg = r_games_brig,
				s_bg = s_games_brig,
				r_gen = r_games_gen,
				s_gen = s_games_gen
				};


			--insert Player object into table [currently only if a player is valid!]
			if (Player.valid) then
			
				table.insert(player_table, Player);
			
				--print(Player.name .. " " .. Player.date_lt.month .. "/" .. Player.date_lt.date .. "/" .. Player.date_lt.year);
			
				--print(Player.name .. " " .. Player.games_lt .. " " .. Player.games_ct .. " " .. Player.games_com
				--	.. " " .. Player.games_col .. " " .. Player.games_bg .. " " .. Player.games_gen);

				--print(Player.name .. " #Ranked: " .. Player.num_ranked .. " #Social: " .. Player.num_social .. " #Games: " .. Player.num_games);

				--print(Player.name .. " " .. Player.r_lt .. " " .. Player.r_ct .. " " .. Player.r_com .. " " .. Player.r_col .. " " .. Player.r_bg ..
				--	" " .. Player.r_gen)
			end

			--update current player
			curr_player = split_line[5];
			highest_rank = split_line[6];
			date_lieutenant = parse_rank_date(split_line[7]);
			date_captain = parse_rank_date(split_line[8]);
			date_commander = parse_rank_date(split_line[9]);
			date_colonel = parse_rank_date(split_line[10]);
			date_brigadier = parse_rank_date(split_line[11]);
			date_general = parse_rank_date(split_line[12]);

			games_lieutenant = 0;
			games_captain = 0;
			games_commander = 0;
			games_colonel = 0;
			games_brigadier = 0;
			games_general = 0;
			games_ranked = 0;
			games_social = 0;
			total_games_played = 0;

			r_games_lieut = 0;
			s_games_lieut = 0;
			r_games_capt = 0;
			s_games_capt = 0;
			r_games_command = 0;
			s_games_command = 0;
			r_games_col = 0;
			s_games_col = 0;
			r_games_brig = 0;
			s_games_brig = 0;
			r_games_gen = 0;
			s_games_gen = 0;

			validity = false;
		end
	end

	data_index = data_index + 1;
	line = data[data_index];
end

print("Number of entries: " .. #player_table);
write_out(player_table);



