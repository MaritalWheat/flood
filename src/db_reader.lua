function db_read ()
	local read_path = "/Users/emanuelrosu/Documents/the-flood/txt/player_db.txt";
	local readable = io.open(read_path, "r");
	
	local player_table = {};
	
	if (readable ~= nil) then
		for line in readable:lines() do
			if (line == nil) then break end;
			--print(line);
			table.insert(player_table, line);
		end
		readable:close();
	end
	return player_table;
end