function inList(list, element)
  for i, k in pairs(list) do
    if k == element then
      return true
    end
  end
  return false
end

function renderMap(map_name)
  --get mapBankNumber and NumberInBank from map_name
  --adding maps in progress
  local map_selector = {
    ['Viridian Forest'] = {1, 0},
    ['Mt Moon 1'] = {1, 1},
    ['Mt Moon 2'] = {1, 2},
    ['Mt Moon 3'] = {1, 3},
    ['SS Anne Dock'] = {1, 4},
    ['SS Anne Entrance'] = {1, 5},
    ['SS Anne 2'] = {1, 6},
    ['SS Anne 3'] = {1, 7},
    ['SS Anne 4'] = {1, 8},
    ['SS Anne 5'] = {1, 9},
    ['SS Anne 6'] = {1, 10},
    ['SS Anne 7'] = {1, 11},
    ['SS Anne 8'] = {1, 12},
    ['SS Anne 9'] = {1, 13},
    ['SS Anne 10'] = {1, 14},
    ['SS Anne 11'] = {1, 15},
    ['SS Anne 12'] = {1, 16},
    ['SS Anne 13'] = {1, 17},
    ['SS Anne 14'] = {1, 18},
    ['SS Anne 15'] = {1, 19},
    ['SS Anne 16'] = {1, 20},
    ['SS Anne 17'] = {1, 21},
    ['SS Anne 18'] = {1, 22},
    ['SS Anne 19'] = {1, 23},
    ['SS Anne 20'] = {1, 24},
    ['SS Anne 21'] = {1, 25},
    ['SS Anne 22'] = {1, 26},
    ['SS Anne 23'] = {1, 27},
    ['SS Anne 24'] = {1, 28},
    ['SS Anne 25'] = {1, 29},
    ['NS UG Path CerC'] = {1, 30},
    ['NS UG Path'] = {1, 31},
    ['NS UG Path VerC'] = {1, 32},
    ['EW UG Path LT'] = {1, 33},
    ['EW UG Path'] = {1, 34},
    ['EW UG Path CelC'] = {1, 35},
    ['Diglett\'s Cave VerC'] = {1, 36},
    ['Diglett\'s Cave'] = {1, 37},
    ['Diglett\'s Cave VirC'] = {1, 38},
    ['Victory Road 1'] = {1, 39},
    ['Vicotry Road 2'] = {1, 40},
    ['Victory Road 3'] = {1, 41},
    ['GC_1'] = {1, 42},
    ['GC_2'] = {1, 43},
    ['GC_3'] = {1, 44},
    ['GC_4'] = {1, 44},
    ['GC_L'] = {1, 44},
    ['GC_L'] = {1, 45},
    ['GC_L'] = {1, 46},
    ['Silph co lobby'] = {1, 47},
    ['Silph co f2'] = {1, 48},
    ['Silph co f3'] = {1, 49},
    ['Silph co f4'] = {1, 50},
    ['Silph co f5'] = {1, 51},
    ['Silph co f6'] = {1, 52},
    ['Silph co f7'] = {1, 53},
    ['Silph co f8'] = {1, 54},
    ['Silph co f9'] = {1, 55},
    ['Silph co f10'] = {1, 56},
    ['Silph co f11'] = {1, 57},
    ['Sliph co L'] = {1, 58},
    ['Mansion f1'] = {1, 59},
    ['Mansion f2'] = {1, 60},
    ['Mansion f3'] = {1, 61},
    ['Mansion bf1'] = {1, 62},
    ['SZ_1'] = {1, 63},
    ['SZ_2'] = {1, 64},
    ['SZ_3'] = {1, 65},
    ['SZ_4'] = {1, 66},
    ['SZ_R_1'] = {1, 67},
    ['SZ_R_2'] = {1, 68},
    ['SZ_R_3'] = {1, 69},
    ['SZ_R_4'] = {1, 70},
    ['SZ_R_s5'] = {1, 71},
    ['Cerulean Cave 1'] = {1, 72},
    ['Cerulean Cave 2'] = {1, 73},
    ['Cerulean Cave 3'] = {1, 74},
    ['Lorelai Room'] = {1, 75},
    ['Bruno Room'] = {1, 76},
    ['Agatha Room'] = {1, 77},
    ['Lance Room'] = {1, 78},
    ['Champion Room'] = {1, 79},
    ['Hall of Fame'] = {1, 80},
    ['Rock Tunnel 1'] = {1, 81},
    ['Rock Tunnel 2'] = {1, 82},
    ['Seafoam Island 1'] = {1, 83},
    ['Seafoam Island 2'] = {1, 84},
    ['Seafoam Island 3'] = {1, 85},
    ['Seafoam Island 4'] = {1, 86},
    ['Seafoam Island 5'] = {1, 87},
    ['PT_1'] = {1, 88},
    ['PT_2'] = {1, 89},
    ['PT_3'] = {1, 90},
    ['PT_4'] = {1, 91},
    ['PT_5'] = {1, 92},
    ['PT_6'] = {1, 93},
    ['PT_7'] = {1, 94},
    ['Power Plant'] = {1, 95},
    ['Pallet Town'] = {3, 0},
    ['Viridian City'] = {3, 1},
    ['Pewter City'] = {3, 2},
    ['Cerulean City'] = {3, 3},
    ['Lavender Town'] = {3, 4},
    ['Celadon City'] = {3, 5},
    ['Fuchsia City'] = {3, 6},
    ['Cinnabar Island'] = {3, 7},
    ['Indigo Plateau'] = {3, 8},
    ['Saffron City'] = {3, 9},
    ['r1'] = {3, 19},
    ['r2'] = {3, 20},
    ['r3'] = {3, 21},
    ['r4'] = {3, 22},
    ['r5'] = {3, 23},
    ['r6'] = {3, 24},
    ['r7'] = {3, 25},
    ['r8'] = {3, 26},
    ['r9'] = {3, 27},
    ['r10'] = {3, 28},
    ['r11'] = {3, 29},
    ['r12'] = {3, 30},
    ['r13'] = {3, 31},
    ['r14'] = {3, 32},
    ['r15'] = {3, 33},
    ['r16'] = {3, 34},
    ['r17'] = {3, 35},
    ['r18'] = {3, 36},
    ['r19'] = {3, 37},
    ['r20'] = {3, 38},
    ['r21_0'] = {3, 39},
    ['r21_1'] = {3, 40},
    ['r22'] = {3, 41},
    ['r23'] = {3, 42},
    ['r24'] = {3, 43},
    ['r25'] = {3, 44},
    ['Oaks Lab'] = {4, 3}
  }
  walkable = {0x30, 0x32}
  notWalkable = {0x06, 0x04}
  water = {0x11, 0x12}
  local mapBankNumber = map_selector[map_name][1]
  local NumberInBank = map_selector[map_name][2]
  --memory address for map bank is 0x3526A8
  local bankAddress = (emu.memory.cart0:read32(0x3526A8 + mapBankNumber*4))-0x8000000
  local mapAddress = (emu.memory.cart0:read32(bankAddress + (NumberInBank*4)))-0x8000000
  local mapData = emu.memory.cart0:read32(mapAddress)-0x8000000
  mapWidth = emu.memory.cart0:read32(mapData)
  mapHeight = emu.memory.cart0:read32(mapData + 4)
--  console:log(tostring(mapWidth) .. ' x ' .. tostring(mapHeight))
  tileData = emu.memory.cart0:read32(mapData + 12)-0x8000000
  console:log(string.format('%x', tileData))
  map = {}
  for i = 0, mapHeight-1, 1 do
    row = {}
    for j = 0, (mapWidth-1)*2, 2 do
      tile = emu.memory.cart0:read8(tileData+(i*2*mapWidth)+j)
      collision = emu.memory.cart0:read8(tileData+(i*2*mapWidth)+j + 1)
--      console:log(string.format('%x', tile))
      if inList(notWalkable, collision) == true then
        table.insert(row, 0)
      elseif inList(walkable, collision) == true then
        table.insert(row, 1)
      elseif inList(water, collision) == true then
        table.insert(row, 4)
      else
          console:log('Unknown Tile Collison')
          table.insert(row, 9)
      end
    end
    table.insert(map, row)
  end
return map
end
map = renderMap('Pallet Town')
for i, row in pairs(map) do
  row_str = ''
  for j, tile in pairs(row) do
    row_str = row_str .. ' (' .. tostring(tile[1]) .. ', ' ..  tostring(tile[2]) .. ') ' .. tostring(tile[3])
  end
  console:log(row_str)
end