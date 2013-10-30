flood
=====

Solution for pulling, parsing, and (eventually) analyzing Halo multiplayer data.

=====

Pipe >

Select search strings from dictionary in pseudo-random fashion -> create JS terms for search and pipe into macro feeder (Lua)

>>

Array in JS feeder file now holds items to search for -> begin iMacro with JS.

>>

iMacro performs searches and saves out result pages, iterating over search terms in JS file.

>>

Parse out actual gamertags from pulled search results (Lua), put coalesce results in single text file.

>>

Pull tags from gamertag file to form URLs for grabbing player data.

>> 

Grab player data and associate it with gamertag in some format (?)
