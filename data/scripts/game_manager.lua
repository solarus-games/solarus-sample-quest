-- Script that creates a game ready to be played.

-- Usage:
-- local game_manager = require("scripts/game_manager")
-- local game = game_manager:create("savegame_file_name")
-- game:start()

require("scripts/multi_events")
local initial_game = require("scripts/initial_game")
local game_manager = {}

function game_manager:create(file)

  -- Create the game (but do not start it).
  local exists = sol.game.exists(file)
  local game = sol.game.load(file)
  if not exists then
    -- Initialize a new savegame.
    game:set_max_life(12)
    game:set_life(game:get_max_life())
    game:set_ability("lift", 2)
    game:set_ability("sword", 1)
    game:set_starting_location("first_map") -- Starting location.
  end

  game:register_event("on_started", function()

    local hero = game:get_hero()
    hero:set_tunic_sprite_id("main_heroes/eldran")
  end)

  return game
end

return game_manager
