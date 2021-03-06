--- Refer to mapper.md for documentation

local M = {}

local bindings = {}

local DEFAULT_PLAYER_BINDINGS = hash("DEFAULT_PLAYER_BINDINGS")


local function get_player_bindings(player)
	player = player or DEFAULT_PLAYER_BINDINGS
	bindings[player] = bindings[player] or {}
	return bindings[player]
end


--- Bind an input trigger to an action, optionally associating the binding
-- to a specific player
-- @param trigger The input trigger to bind (key, gamepad, mouse etc)
-- @param action The action that will be generated by the trigger
-- @param player Optional id for a player to bind input trigger to
-- @param gamepad Optional gamepad index to bind input trigger to
-- @return Any previous action bound to the trigger
function M.bind(trigger, action, player, gamepad)
	assert(trigger)
	assert(action)
	local bindings = get_player_bindings(player)
	local previous = bindings[trigger]
	bindings[trigger] = {
		action = action,
		gamepad = gamepad,
	}
	return previous and previous.action
end


--- Unbind (remove) an existing input binding
-- @param trigger The input trigger to unbind (key, gamepad, mouse etc)
-- @param player Optional id for a player to unbind input trigger from
function M.unbind(trigger, player)
	assert(trigger)
	local bindings = get_player_bindings(player)
	bindings[trigger] = nil
end


--- Unbind (remove) all input trigger bindings 
-- @param player Optional id for a player to unbind input triggers from
function M.unbind_all(player)
	local bindings = get_player_bindings(player)
	for trigger,_ in pairs(bindings) do
		bindings[trigger] = nil
	end
end


--- Handle incoming input trigger from a script by finding an binding and
-- returning the bound action
-- @param trigger The input trigger received from on_input funcion (ie action_id)
-- @param player Optional id for a player to get input trigger binding for
-- @param gamepad Optional gamepad index the input trigger originated from
-- @return The bound action or nil if no binding exists
function M.on_input(trigger, player, gamepad)
	if not trigger then
		return nil
	end
	local bindings = get_player_bindings(player)
	local binding = bindings[trigger]
	if not binding then
		return nil
	end
	if not gamepad or (gamepad == binding.gamepad) then
		return binding.action
	end
end



return M
