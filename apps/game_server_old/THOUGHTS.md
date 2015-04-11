We only need to empty the OS buffer every 600ms when we sync the game. 
but using active once would be hard to like be in sync with the rest of the world. so that is not really an option is it... hmph


Every 600ms the world ticks

the world sends an event to all the regions
a region sends a tick event to all its playerso

when a player gets notified it sets its socket to active: once
it will now be able to process data. Processing data is just chugging untill
we can't parse anymore.  Handling each packet as it comes in. if handling breaks
the packet chain we return {Done} and we discard the rest of the data. It's important
that you dont discard all. just discard anything that can be parsed. As we might've received trailing TCP packets. They stay in the buffer.

Players that have no packets are marked "closed". they will be removed.

Once we've processed we need to somehow signal the region that we're done... 

Once the region knows all its players have been updated it will proceed with the
sync step.  It will prepare player update information by snapshotting the region.
send a message to each client thread. The client thread will pack the message and send it to the TCP port.


[1:25:07 AM] Cups/Arian: Okay so what I got now
[1:25:24 AM] Cups/Arian: A tick happens:
The World  sends an event to all the region threads
[1:25:37 AM] Cups/Arian: a region thread sends an event to all its player
[1:26:02 AM] Shawn Davies: ye
[1:26:31 AM] Cups/Arian: but we dont wait for those events to arrive because then lets say
[1:26:40 AM] Cups/Arian: the first player is lagging. we block sendingg the tick to the next player
[1:26:43 AM] Cups/Arian: so that'd be shitty
[1:27:03 AM] Cups/Arian: so the player receives the tick.  It reads the buffer. parses as many packets as possible. Starts executing each event it parsed
[1:27:11 AM] Cups/Arian: either discards the rest of the queue or not
[1:27:18 AM] Cups/Arian: then sends a message back to the region thread "Im done"
[1:27:42 AM] Cups/Arian: if a player times out it also sends back to the region thread
[1:27:55 AM] Cups/Arian: the region thread removes timed out players etc
[1:28:06 AM] Cups/Arian: then starts the update sequence
[1:28:07 AM] Shawn Davies: yeah thats good cause there actually is a function for removing a player
[1:28:10 AM] Shawn Davies: that u gotta implement
[1:28:28 AM] Shawn Davies: i think you have to send bits even if ur removing a player
[1:28:30 AM] Cups/Arian: sends an event to each player  thread that it needs to send the update packet
[1:28:35 AM] Cups/Arian: the players send the update packet
[1:29:07 AM] Cups/Arian: do I wait for the player to send back if sending update packet was successful?
[1:29:09 AM] Cups/Arian: yeh right?
[1:29:19 AM] Cups/Arian: seems like a smart move


so fuck the thread per region idea. that's probably shitty.?


    player.region => tells in which region a player is
    player.position => relative to its region
    Region.absolute_position region player.position


    a region is an {x,y,0} coordinate. 
    a position is an {x,y,z} relative to its region



minimum impl:

Our player movement update
then 0 other player movement updates
flags. ignore most of em now


Region is GenServer with ets_table. only the Region process can modify the ets_table. aka
remove players etc



NOOOOOO. the world thread is the "Worldd state" no fucking multiple threads.
clients send their incoming events to the world thread. and the world thread sends outgoing
events to the client. AND THAT'S IT.

it's really freakin easy. the world is an FSM. Or perhaps a region is an fsm. andd that's tthat.


when movement updating we can prioritize mods, jmods, friends in the FOW in the player local list. Then do a BFS in the viewport

viewport = 32x32




===========

Make game_server totally protocol agnostic! THAT'S AWESOME

A lot of messages are protocol agnostic. most events are.  Differences can be handled in game logic.
