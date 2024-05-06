module Blindstep
  def self.player_move(direction)
    volume = $Settings.accessibilityVolume
    pbSEPlay("Blindstep- Footstep_D", volume) if direction == 2
    pbSEPlay("Blindstep- Footstep_L", volume) if direction == 4
    pbSEPlay("Blindstep- Footstep_R", volume) if direction == 6
    pbSEPlay("Blindstep- Footstep_U", volume) if direction == 8
  end

  # If you think this is ugly, trust me that the original was much much worse.
  # Feel free to rewrite it completely but I have had enough of this. ~enu
  # For instance instead of the time shenanigans we should probably use Graphics.frame_count.
  def self.character_update()
    time = Process.clock_gettime(Process::CLOCK_MONOTONIC, :millisecond)
    time -= Process.clock_gettime(Process::CLOCK_MONOTONIC, :second) * 1000
    time %= 500
    volume = $Settings.accessibilityVolume

    if time < 50
      $game_variables[:BlindstepLastDirection] = 0
    end

    return if pbMapInterpreterRunning? || $game_temp.message_window_showing

    if time.between?(50, 99)
      return if $game_variables[:BlindstepLastDirection] == 1

      pbSEStop
      self.playAmbientSounds
      $game_variables[:BlindstepLastDirection] = 1
    end

    if time.between?(100, 199)
      return if $game_variables[:BlindstepLastDirection] == 8
      return if $game_player.passable?($game_player.x, $game_player.y, 8)

      if self.getFacingEventType > 0
        # pbSEPlay("Blindstep- Door",3*volume/4,80) if door
        pbSEPlay("Blindstep- ImmediateEvent", 3 * volume / 4, 80)
      end
      $game_variables[:BlindstepLastDirection] = 8
    end

    if time.between?(200, 299)
      return if $game_variables[:BlindstepLastDirection] == 2
      return if $game_player.passable?($game_player.x, $game_player.y, 2)

      if self.getFacingEventType > 0
        # pbSEPlay("Blindstep- Door",3*volume/4,20) if door
        pbSEPlay("Blindstep- ImmediateEvent", 3 * volume / 4, 20)
      end
      $game_variables[:BlindstepLastDirection] = 2
    end

    if time.between?(300, 399)
      return if $game_variables[:BlindstepLastDirection] == 4
      return if $game_player.passable?($game_player.x, $game_player.y, 4)

      if self.getFacingEventType > 0
        # pbSEPlay("Blindstep- DoorL",3*volume/4) if door
        pbSEPlay("Blindstep- ImmediateEventL", 3 * volume / 4)
      end
      $game_variables[:BlindstepLastDirection] = 4
    end

    if time.between?(400, 499)
      return if $game_variables[:BlindstepLastDirection] == 6
      return if $game_player.passable?($game_player.x, $game_player.y, 6)

      if self.getFacingEventType > 0
        # pbSEPlay("Blindstep- DoorR",3*volume/4) if door
        pbSEPlay("Blindstep- ImmediateEventR", 3 * volume / 4)
      end
      $game_variables[:BlindstepLastDirection] = 6
    end
  end

  def self.playAmbientSounds
    volume = $Settings.accessibilityVolume
    pbSEPlay("Blindstep- AmbientNorth", volume * self.getDirectionVolume(8) / 6)
    pbSEPlay("Blindstep- AmbientSouth", volume * self.getDirectionVolume(2) / 6)
    pbSEPlay("Blindstep- AmbientWest", volume * self.getDirectionVolume(4) / 6)
    pbSEPlay("Blindstep- AmbientEast", volume * self.getDirectionVolume(6) / 6)
  end

  def self.getDirectionVolume(direction)
    x = $game_player.x
    y = $game_player.y
    volume = 6
    while volume > 0
      return volume unless $game_player.passable?(x, y, direction)

      volume -= 1
      y += 1 if direction == 2
      x -= 1 if direction == 4
      x += 1 if direction == 6
      y -= 1 if direction == 8
    end
    return 0
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
