-- Clickable head-up display.

-- Usage:
-- require("scripts/hud/hud")

require("scripts/multi_events")

-- Creates and runs a HUD for the specified game.
local function initialize_hud_features(game)

  local hud = {}

  local icons = {
      item_1 = {
          surface = sol.surface.create("hud/icon_item_1.png"),
          x = 270,
          y = 225,
          command = "item_1",
          pressed = false,
      },
      attack = {
          surface = sol.surface.create("hud/icon_attack.png"),
          x = 295,
          y = 225,
          command = "attack",
          pressed = false,
      },
      action = {
          surface = sol.surface.create("hud/icon_action.png"),
          x = 282,
          y = 205,
          command = "action",
          pressed = false,
      },
  }

  local has_hud_button_pushed = false

  -- Clickable circle icons.
  icons.item_1.surface:set_opacity(216)
  icons.attack.surface:set_opacity(216)

  function hud:on_mouse_pressed(button, x, y)

    if game:get_map() == nil then
      return
    end

    -- If the mouse position is over a button, simulate the corresponding command.
    for _, icon in pairs(icons) do

      local icon_width, icon_height = icon.surface:get_size()
      if not has_hud_button_pushed and sol.main.get_distance(x, y, icon.x, icon.y) < icon_width / 2 then
        has_hud_button_pushed = true
        self:start_command(icon)
        return true
      end
    end
  end

  function hud:on_mouse_released(button, x, y)

    if game:get_map() == nil then
      return
    end

    if has_hud_button_pushed then
      has_hud_button_pushed = false
      for _, icon in pairs(icons) do
        if icon.pressed then
          self:stop_command(icon)
          return true
        end
      end
    end
  end

  function hud:on_draw(screen)

    if game:get_map() == nil then
      return
    end

    for _, icon in pairs(icons) do
      local icon_width, icon_height = icon.surface:get_size()
      icon.surface:draw(screen, icon.x - icon_width / 2, icon.y - icon_height / 2)
    end
  end

  function hud:start_command(icon)

    if not icon.pressed then
      icon.pressed = true
      game:simulate_command_pressed(icon.command)
    end
  end

  function hud:stop_command(icon)

    if icon.pressed then
      icon.pressed = false
      game:simulate_command_released(icon.command)
    end
  end

  function hud:has_button_pushed()

    return has_hud_button_pushed
  end

  -- Start the HUD.
  sol.menu.start(game, hud)
end

-- Set up the HUD features on any game that starts.
local game_meta = sol.main.get_metatable("game")
game_meta:register_event("on_started", initialize_hud_features)
return true
