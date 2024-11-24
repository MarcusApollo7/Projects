require 'math'
function hexToText(hex)
  local con_grid = {['bb']='A',['bc']='B',['bd']='C',['be']='D',['bf']='E',['c0']='F',['c1']='G',['c2']='H',['c3']='I',[   'c4']='J',['c5']='K',['c6']='L',['c7']='M',['c8']='N',['c9']='O',['ca']='P',['cb']='Q',['cc']='R',['cd']='S',['ce']='T',['cf']='U',['d0']='V',['d1']='W',['d2']='X',['d3']='Y',['d4']='Z'}
  for i, k in pairs(con_grid) do
    if i == hex then
      return k
    end
  end
  return ''
end

function readName(startMonInfo)
  local name_address = startMonInfo + 8
  local name = ""
  for i=name_address, name_address + 9, 1 do
    local letter = string.format("%x", emu:read8(i))
    if letter == 'ff' then
      return name
    end
    name = name .. hexToText(letter)
  end
  return name
end
function calcHP(EV, IV, base, level)
  local numerator = (2*base+IV+(EV/4))*level
  return math.floor(numerator/100)+ level + 10
end
function calcOtherStat(EV, IV, base, level, nature)
  local numerator = (2*base+IV+(EV/4))*level
  return math.floor((math.floor(numerator/100)+5)*nature)
end
function decrypt(startMonInfo)
  local substructSelector = {
		[ 0] = {0, 1, 2, 3},
		[ 1] = {0, 1, 3, 2},
		[ 2] = {0, 2, 1, 3},
		[ 3] = {0, 3, 1, 2},
		[ 4] = {0, 2, 3, 1},
		[ 5] = {0, 3, 2, 1},
		[ 6] = {1, 0, 2, 3},
		[ 7] = {1, 0, 3, 2},
		[ 8] = {2, 0, 1, 3},
		[ 9] = {3, 0, 1, 2},
		[10] = {2, 0, 3, 1},
		[11] = {3, 0, 2, 1},
		[12] = {1, 2, 0, 3},
		[13] = {1, 3, 0, 2},
		[14] = {2, 1, 0, 3},
		[15] = {3, 1, 0, 2},
		[16] = {2, 3, 0, 1},
		[17] = {3, 2, 0, 1},
		[18] = {1, 2, 3, 0},
		[19] = {1, 3, 2, 0},
		[20] = {2, 1, 3, 0},
		[21] = {3, 1, 2, 0},
		[22] = {2, 3, 1, 0},
		[23] = {3, 2, 1, 0},
	}
  --[Nature Number] = {Attack, Defense, Speed, Spe. Attack, Spe. Defense}
  nature_selector = {
    [0] = {1, 1, 1, 1, 1},
    [1] = {1.1, .9, 1, 1, 1},
    [2] = {1.1, 1, .9, 1, 1},
    [3] = {1.1, 1, 1, .9, 1},
    [4] = {1.1, 1, 1, 1, .9},
    [5] = {.9, 1.1, 1, 1, 1},
    [6] = {1, 1, 1, 1, 1},
    [7] = {1, 1.1, .9, 1, 1},
    [8] = {1, 1.1, 1, .9, 1},
    [9] = {1, 1.1, 1, 1, .9},
    [10] = {.9, 1, 1.1, 1, 1},
    [11] = {1, .9, 1.1, 1, 1},
    [12] = {1, 1, 1, 1, 1},
    [13] = {1, 1, 1.1, .9, 1},
    [14] = {1, 1, 1.1, 1, .9},
    [15] = {.9, 1, 1, 1.1, 1},
    [16] = {1, .9, 1, 1.1, 1},
    [17] = {1, 1, .9, 1.1, 1},
    [18] = {1, 1, 1, 1, 1},
    [19] = {1, 1, 1, 1.1, .9},
    [20] = {.9, 1, 1, 1, 1.1},
    [21] = {1, .9, 1, 1, 1.1},
    [22] = {1, 1, .9, 1, 1.1},
    [23] = {1, 1, 1, .9, 1.1},
    [24] = {1, 1, 1, 1, 1}
    }
  local substructureOrder = substructSelector[emu:read32(startMonInfo) % 24]
  local MonID = emu:read32(startMonInfo)
  local nature = nature_selector[MonID % 25]
  local OTrainerID = emu:read32(startMonInfo + 4)
  local xKey = MonID~OTrainerID
  
  local block_1 = {substructureOrder[1], {emu:read32(startMonInfo+32)~xKey,
    emu:read32(startMonInfo+36)~xKey, 
    emu:read32(startMonInfo+40)~xKey}}

  local block_2 = {substructureOrder[2],{emu:read32(startMonInfo+44)~xKey,
      emu:read32(startMonInfo+48)~xKey, 
      emu:read32(startMonInfo+52)~xKey}}
  
  local block_3 = {substructureOrder[3],{emu:read32(startMonInfo+56)~xKey, 
      emu:read32(startMonInfo+60)~xKey, 
      emu:read32(startMonInfo+64)~xKey}}
  
  local block_4 = {substructureOrder[4],{emu:read32(startMonInfo+68)~xKey,
      emu:read32(startMonInfo+72)~xKey, 
      emu:read32(startMonInfo+76)~xKey}}
  
  blocks = {block_1, block_2, block_3, block_4}
  for i, v in ipairs(blocks) do
    if v[1] == 0 then
      itemHeld = math.floor(v[2][1] / 0x10000)
      monNumber = v[2][1] % 0x10000
      exp = v[2][2]
      happiness = (v[2][3]/256)%256
      move1PPUP = v[2][3] % 4
      move2PPUP = math.floor(v[2][3]/4) % 4
      move3PPUP = math.floor(v[2][3]/16) % 4
      move4PPUP = math.floor(v[2][3]/64) % 4
    elseif v[1] == 1 then
      move1 = v[2][1] % 65536
      move2 = math.floor(v[2][1] / 65536)
      move3 = v[2][2] % 65536
      move4 = math.floor(v[2][2] / 65536)
      move1PP = v[2][3] % 256
      move2PP = math.floor(v[2][3]/256) % 256
      move3PP = math.floor(v[2][3]/65536) % 256
      move4PP = math.floor(v[2][3]/16777216) % 256
    elseif v[1] == 2 then
      HPEV = v[2][1] % 256
      AtkEV = math.floor(v[2][1]/256) % 256
      DefEV = math.floor(v[2][1]/65536)% 256
      SpeEV = math.floor(v[2][1]/16777216) % 256
      SpAtkEV = v[2][2] % 256
      SpDefEV = math.floor(v[2][2]/256) % 256
    elseif v[1] == 3 then
      HPIV = v[2][2] % 32
      AtkIV = math.floor(v[2][2]/32)%32
      DefIV = math.floor(v[2][2]/1014)%32
      SpeIV = math.floor(v[2][2]/32768)%32
      SpAtkIV = math.floor(v[2][2]/1048576)%32
      SpDefIV = math.floor(v[2][2]/33554432)%32
    end
  end
  
  level = emu:read8(startMonInfo + 84)
  HP = emu:read16(startMonInfo + 88)
  Atk = emu:read16(startMonInfo + 90)
  Def = emu:read16(startMonInfo + 92)
  Spe = emu:read16(startMonInfo + 94)
  SpAtk = emu:read16(startMonInfo + 96)
  SpDef = emu:read16(startMonInfo + 98)
  return {move1, move2, move3, move4}, {HP, Atk, Def, Spe, SpAtk, SpDef}
end

function readPartyMon(party_position)
  local startMonInfo = 0x02024284 + (100 * party_position)
  friend_name = readName(startMonInfo)
  moves, stats = decrypt(startMonInfo)
  for i, k in ipairs(stats) do
    console:log(tostring(k))
  end
end


function readEnemyMon(party_position)
  local startMonInfo = 0x0202402C + (100 * party_position)
  enemy_name = readName(startMonInfo)
  moves, stats = decrypt(startMonInfo)
  
end

function inBattle()
  if emu:read16(0x2022bb8) == 0 then
    return false
  elseif emu:read16(0x2022bb8) ~= 0 then
    return true
  end
end


emu:loadStateFile("C:/Users/ccwar/Documents/AI_Pokemon/Pokemon_Fire_Red/rival1.ss0")
readPartyMon(0)
--if inBattle() == true then
  --console:log('Battle On')
  --readEnemyMon(0)
--end