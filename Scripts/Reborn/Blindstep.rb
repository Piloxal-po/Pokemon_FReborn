module Blindstep
  def self.player_move(direction)
    pbAccessibilitySEPlay("Blindstep- Footstep_D") if direction == 2
    pbAccessibilitySEPlay("Blindstep- Footstep_L") if direction == 4
    pbAccessibilitySEPlay("Blindstep- Footstep_R") if direction == 6
    pbAccessibilitySEPlay("Blindstep- Footstep_U") if direction == 8
  end

  def self.character_update()
    return if pbMapInterpreterRunning? || $game_temp.message_window_showing

    remainder = Graphics.frame_count % (40 * ($speed_up ? $Settings.turboSpeedMultiplier : 1)).floor

    if remainder == 0
      self.playAmbientSounds

      return if self.getFacingEventType == 0

      if !$game_player.passable?($game_player.x, $game_player.y, 8)
        # pbAccessibilitySEPlay("Blindstep- Door", 75, 80) if door
        pbAccessibilitySEPlay("Blindstep- ImmediateEvent", 75, 80)
      end
      if !$game_player.passable?($game_player.x, $game_player.y, 2)
        # pbAccessibilitySEPlay("Blindstep- Door", 75, 20) if door
        pbAccessibilitySEPlay("Blindstep- ImmediateEvent", 75, 20)
      end
      if !$game_player.passable?($game_player.x, $game_player.y, 4)
        # pbAccessibilitySEPlay("Blindstep- DoorL", 75) if door
        pbAccessibilitySEPlay("Blindstep- ImmediateEventL", 75)
      end
      if !$game_player.passable?($game_player.x, $game_player.y, 6)
        # pbAccessibilitySEPlay("Blindstep- DoorR", 75) if door
        pbAccessibilitySEPlay("Blindstep- ImmediateEventR", 75)
      end
    end
  end

  def self.playAmbientSounds
    pbAccessibilitySEPlay("Blindstep- AmbientNorth", self.getDirectionVolume(8))
    pbAccessibilitySEPlay("Blindstep- AmbientSouth", self.getDirectionVolume(2))
    pbAccessibilitySEPlay("Blindstep- AmbientWest", self.getDirectionVolume(4))
    pbAccessibilitySEPlay("Blindstep- AmbientEast", self.getDirectionVolume(6))
  end

  def self.getDirectionVolume(direction)
    x = $game_player.x
    y = $game_player.y
    intensity = 6
    while intensity > 0
      break unless $game_player.passable?(x, y, direction)

      intensity -= 1
      y += 1 if direction == 2
      x -= 1 if direction == 4
      x += 1 if direction == 6
      y -= 1 if direction == 8
    end
    return 100 * intensity / 6
  end

  def self.getFacingEventType
    event = $game_player.pbFacingEvent
    return 0 unless event
    # Ignore non-interactable events
    return 0 if event.trigger != 0 || event.list.length <= 1
    return 2 if event.name == "Item"

    # TODO: Separate value for door
    return 1
  end

  # TODO: This doesn't handle regions since Reborn only has one.
  def self.flyMenu()
    items = {}
    $cache.town_map.each do |key, value|
      if value.is_a?(TownMapData) && value.flyData != [] && $PokemonGlobal.visitedMaps[value.flyData[0]]
        items[value.name] = value.flyData
      end
    end
    items = items.sort_by { |key| key }.to_h
    cmd = Kernel.pbMessage("Choose destination...", items.keys, -1)
    if cmd == -1
      return nil
    end
    return items[items.keys[cmd]]
  end
end
