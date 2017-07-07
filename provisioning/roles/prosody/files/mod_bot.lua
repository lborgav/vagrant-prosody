-- mod_bot.lua
rawset(_G, "PROXY", false);

local st = require "util.stanza"; -- Import Prosody's stanza API
local http = require 'socket.http';
local jid_bare = require "util.jid".bare;
local lunajson = require 'lunajson';

function on_message(event)
	if event.stanza.attr.type == "error" then
		return;
	end

	local stanza = event.stanza;
	local from = jid_bare(stanza.attr.from);
	local to = jid_bare(stanza.attr.to);
	local body = stanza:get_child('body');
	
	local response = get_response(body)

	module:send(st.message({ to = from, from = to, type = "chat"}, response));
	return 200;
end

function get_response(body)
	if string.find(body:get_text(), 'joke') ~= nil then
		local url = 'http://api.icndb.com/jokes/random'
		responseBody, c, l, h = http.request(url)
		decoded = lunajson.decode(responseBody)
		return decoded.value.joke;
	end
	return "I can't understand you"
end

module:hook("message/bare", on_message);
