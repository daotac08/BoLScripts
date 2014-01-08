-- ###################################################################################################### --
-- #                                                                                                    # --  
-- #                                               XT002-HUD                                            # -- v3.2 Fixed Errors
-- #                                                by Sida                                             # --
-- #                         Credit for original scripts 100% to the original authors!!                 # -- Edited And Updated 3.15 Patch BY Galaxix
-- #                                                                                                    # --
--###################################################################################################### --

--[--------- Contains ---------]

-- Stun Alert : Created by ikita/eXtragoZ
-- Low Awareness : Created by Ryan, Ported by Manciuszz
-- Simple Minion Marker : Created by Kilua
-- Enemy Tower Range : Created by SurfaceS
-- Hidden Objects : Created by SurfaceS
-- Jungle Display : Created by SurfaceS
-- Champion Ranges : Created by heist, ported by Mistal
-- Ward Prediction : Created by eXtragoZ
-- Where did he go? : Created by ViceVarsa
-- Auto Life Saver : Created by Wursti
-- Auto Potion : Created by ikita
-- MinimapTimers : Created by Surfaces



-- ############################################# LOW AWARENESS ##############################################

local alertActive = true
local championTable = {}
local playerTimer = {}
local playerDrawer = {}
local player = GetMyHero()
--showErrorsInChat = false
--showErrorTraceInChat = false

nextTick = 0 function LowAwarenessOnTick()   if nextTick > GetTickCount() then return end   nextTick = GetTickCount() + 250 --(100 is the delay) 	
    local tick = GetTickCount()
    if alertActive == true then
        for i = 1, heroManager.iCount, 1 do
        local object = heroManager:getHero(i)
            if object.team ~= player.team and object.dead == false then
                if object.visible == true and player:GetDistance(object) < 2500 then
                    if playerTimer[i] == nil then
                        PrintChat(string.format("<font color='#FF0000'> >> ALERT: %s</font>", object.charName))
                        -- PingSignal(PING_FALLBACK,object.x,object.y,object.z,2)
                        -- PingSignal(PING_FALLBACK,object.x,object.y,object.z,2)
                        -- PingSignal(PING_FALLBACK,object.x,object.y,object.z,2)
                        table.insert(championTable, object )
                        playerDrawer[i] = tick
                    end
                    playerTimer[ i ] = tick
                    if (tick - playerDrawer[i]) > 5000 then
                        for ii, tableObject in ipairs(championTable) do
                            if tableObject.charName == object.charName then
                                table.remove(championTable, ii)
                            end
                        end
                    end
                else
                    if playerTimer[i] ~= nil and (tick - playerTimer[i]) > 10000 then
                        playerTimer[i] = nil
                        for ii, tableObject in ipairs(championTable) do
                            if tableObject.charName == object.charName then
                                table.remove(championTable, ii)
                            end
                        end
                    end
                end
            end
        end
    end
end



function LowAwarenessOnDraw()
    for i,tableObject in ipairs(championTable) do
       if tableObject.visible and tableObject.dead == false and tableObject.team ~= player.team then
			for t = 0, 1 do	
				DrawCircle(tableObject.x, tableObject.y, tableObject.z, 1250 + t*0.25, 0xFFFF0000)
			end
       end
    end
end

-- ############################################# LOW AWARENESS ##############################################

-- ################################################## Minimap Timers v0.3  #######################################################
--[[
Script: minimapTimers v0.3  (3.14 LoL patch)

Author: SurfaceS 
Updated by TEAM DEKLAND
]]
do
    --[[      GLOBAL      ]]
    monsters = {
        summonerRift = {
            {   -- baron
                name = "baron",
                spawn = 900,
                respawn = 420,
                advise = true,
                camps = {
                    {
                        pos = { x = 4600, y = 60, z = 10250 },
                        name = "monsterCamp_12",
                        creeps = { { { name = "Worm12.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                },
            },
            {   -- dragon
                name = "dragon",
                spawn = 150,
                respawn = 360,
                advise = true,
                camps = {
                    {
                        pos = { x = 9459, y = 60, z = 4193 },
                        name = "monsterCamp_6",
                        creeps = { { { name = "Dragon6.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                },
            },
            {   -- blue
                name = "blue",
                spawn = 115,
                respawn = 300,
                advise = true,
                camps = {
                    {
                        pos = { x = 3632, y = 60, z = 7600 },
                        name = "monsterCamp_1",
                        creeps = { { { name = "AncientGolem1.1.1" }, { name = "YoungLizard1.1.2" }, { name = "YoungLizard1.1.3" }, }, },
                        team = TEAM_BLUE,
                    },
                    {
                        pos = { x = 10386, y = 60, z = 6811 },
                        name = "monsterCamp_7",
                        creeps = { { { name = "AncientGolem7.1.1" }, { name = "YoungLizard7.1.2" }, { name = "YoungLizard7.1.3" }, }, },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- red
                name = "red",
                spawn = 115,
                respawn = 300,
                advise = true,
                camps = {
                    {
                        pos = { x = 7455, y = 60, z = 3890 },
                        name = "monsterCamp_4",
                        creeps = { { { name = "LizardElder4.1.1" }, { name = "YoungLizard4.1.2" }, { name = "YoungLizard4.1.3" }, }, },
                        team = TEAM_BLUE,
                    },
                    {
                        pos = { x = 6504, y = 60, z = 10584 },
                        name = "monsterCamp_10",
                        creeps = { { { name = "LizardElder10.1.1" }, { name = "YoungLizard10.1.2" }, { name = "YoungLizard10.1.3" }, }, },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- wolves
                name = "wolves",
                spawn = 115,
                respawn = 50,
                advise = false,
                camps = {
                    {
                        name = "monsterCamp_2",
                        creeps = { { { name = "GiantWolf2.1.3" }, { name = "wolf2.1.1" }, { name = "wolf2.1.2" }, }, },
                        team = TEAM_BLUE,
                    },
                    {
                        name = "monsterCamp_8",
                        creeps = { { { name = "GiantWolf8.1.3" }, { name = "wolf8.1.1" }, { name = "wolf8.1.2" }, }, },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- wraiths
                name = "wraiths",
                spawn = 115,
                respawn = 50,
                advise = false,
                camps = {
                    {
                        name = "monsterCamp_3",
                        creeps = { { { name = "Wraith3.1.3" }, { name = "LesserWraith3.1.1" }, { name = "LesserWraith3.1.2" }, { name = "LesserWraith3.1.4" }, }, },
                        team = TEAM_BLUE,
                    },
                    {
                        name = "monsterCamp_9",
                        creeps = { { { name = "Wraith9.1.3" }, { name = "LesserWraith9.1.1" }, { name = "LesserWraith9.1.2" }, { name = "LesserWraith9.1.4" }, }, },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- GreatWraiths
                name = "GreatWraiths",
                spawn = 115,
                respawn = 50,
                advise = false,
                camps = {
                    {
                        name = "monsterCamp_13",
                        creeps = { { { name = "GreatWraith13.1.1" }, }, },
                        team = TEAM_BLUE,
                    },
                    {
                        name = "monsterCamp_14",
                        creeps = { { { name = "GreatWraith14.1.1" }, }, },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- Golems
                name = "Golems",
                spawn = 115,
                respawn = 50,
                advise = false,
                camps = {
                    {
                        name = "monsterCamp_5",
                        creeps = { { { name = "Golem5.1.2" }, { name = "SmallGolem5.1.1" }, }, },
                        team = TEAM_BLUE,
                    },
                    {
                        name = "monsterCamp_11",
                        creeps = { { { name = "Golem11.1.2" }, { name = "SmallGolem11.1.1" }, }, },
                        team = TEAM_RED,
                    },
                },
            },
        },
        twistedTreeline = {
            {   -- Wraith
                name = "Wraith",
                spawn = 100,
                respawn = 50,
                advise = false,
                camps = {
                    {
                        --pos = { x = 4414, y = 60, z = 5774 },
                        name = "monsterCamp_1",
                        creeps = {
                            { { name = "TT_NWraith1.1.1" }, { name = "TT_NWraith21.1.2" }, { name = "TT_NWraith21.1.3" }, },
                        },
                        team = TEAM_BLUE,
                    },
                    {
                        --pos = { x = 11008, y = 60, z = 5775 },
                        name = "monsterCamp_4",
                        creeps = {
                            { { name = "TT_NWraith4.1.1" }, { name = "TT_NWraith24.1.2" }, { name = "TT_NWraith24.1.3" }, },
                        },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- Golems
                name = "Golems",
                respawn = 50,
                spawn = 100,
                advise = false,
                camps = {
                    {
                        --pos = { x = 5088, y = 60, z = 8065 },
                        name = "monsterCamp_2",
                        creeps = {
                            { { name = "TT_NGolem2.1.1" }, { name = "TT_NGolem22.1.2" } },
                        },
                        team = TEAM_BLUE,
                    },
                    {
                        --pos = { x = 10341, y = 60, z = 8084 },
                        name = "monsterCamp_5",
                        creeps = {
                            { { name = "TT_NGolem5.1.1" }, { name = "TT_NGolem25.1.2" } },
                        },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- Wolves
                name = "Wolves",
                respawn = 50,
                spawn = 100,
                advise = false,
                camps = {
                    {
                        --pos = { x = 6148, y = 60, z = 5993 },
                        name = "monsterCamp_3",
                        creeps = { { { name = "TT_NWolf3.1.1" }, { name = "TT_NWolf23.1.2" }, { name = "TT_NWolf23.1.3" } }, },
                        team = TEAM_BLUE,
                    },
                    {
                        --pos = { x = 9239, y = 60, z = 6022 },
                        name = "monsterCamp_6",
                        creeps = { { { name = "TT_NWolf6.1.1" }, { name = "TT_NWolf26.1.2" }, { name = "TT_NWolf26.1.3" } }, },
                        team = TEAM_RED,
                    },
                },
            },
            {   -- Heal
                name = "Heal",
                spawn = 115,
                respawn = 90,
                advise = true,
                camps = {
                    {
                        pos = { x = 7711, y = 60, z = 6722 },
                        name = "monsterCamp_7",
                        creeps = { { { name = "TT_Relic7.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                },
            },
            {   -- Vilemaw
                name = "Vilemaw",
                spawn = 600,
                respawn = 300,
                advise = true,
                camps = {
                    {
                        pos = { x = 7711, y = 60, z = 10080 },
                        name = "monsterCamp_8",
                        creeps = { { { name = "TT_Spiderboss8.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                },
            },
        },
        crystalScar = {},
        provingGrounds = {
            {   -- Heal
                name = "Heal",
                spawn = 190,
                respawn = 40,
                advise = false,
                camps = {
                    {
                        pos = { x = 8922, y = 60, z = 7868 },
                        name = "monsterCamp_1",
                        creeps = { { { name = "OdinShieldRelic1.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                    {
                        pos = { x = 7473, y = 60, z = 6617 },
                        name = "monsterCamp_2",
                        creeps = { { { name = "OdinShieldRelic2.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                    {
                        pos = { x = 5929, y = 60, z = 5190 },
                        name = "monsterCamp_3",
                        creeps = { { { name = "OdinShieldRelic3.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                    {
                        pos = { x = 4751, y = 60, z = 3901 },
                        name = "monsterCamp_4",
                        creeps = { { { name = "OdinShieldRelic4.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                },
            },
        },
        howlingAbyss = {
            {   -- Heal
                name = "Heal",
                spawn = 190,
                respawn = 40,
                advise = false,
                camps = {
                    {
                        pos = { x = 8922, y = 60, z = 7868 },
                        name = "monsterCamp_1",
                        creeps = { { { name = "HA_AP_HealthRelic1.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                    {
                        pos = { x = 7473, y = 60, z = 6617 },
                        name = "monsterCamp_2",
                        creeps = { { { name = "HA_AP_HealthRelic2.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                    {
                        pos = { x = 5929, y = 60, z = 5190 },
                        name = "monsterCamp_3",
                        creeps = { { { name = "HA_AP_HealthRelic3.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                    {
                        pos = { x = 4751, y = 60, z = 3901 },
                        name = "monsterCamp_4",
                        creeps = { { { name = "HA_AP_HealthRelic4.1.1" }, }, },
                        team = TEAM_NEUTRAL,
                    },
                },
            },
        },
    }

    altars = {
        summonerRift = {},
        twistedTreeline = {
            {
                name = "Left Altar",
                spawn = 180,
                respawn = 85,
                advise = true,
                objectName = "TT_Buffplat_L",
                locked = false,
                lockNames = {"TT_Lock_Blue_L.troy", "TT_Lock_Purple_L.troy", "TT_Lock_Neutral_L.troy", },
                unlockNames = {"TT_Unlock_Blue_L.troy", "TT_Unlock_purple_L.troy", "TT_Unlock_Neutral_L.troy", },
            },
            {
                name = "Right Altar",
                spawn = 180,
                respawn = 85,
                advise = true,
                objectName = "TT_Buffplat_R",
                locked = false,
                lockNames = {"TT_Lock_Blue_R.troy", "TT_Lock_Purple_R.troy", "TT_Lock_Neutral_R.troy", },
                unlockNames = {"TT_Unlock_Blue_R.troy", "TT_Unlock_purple_R.troy", "TT_Unlock_Neutral_R.troy", },
            },
        },
        crystalScar = {},
        provingGrounds = {},
        howlingAbyss = {},
    }

    relics = {
        summonerRift = {},
        twistedTreeline = {},
        crystalScar = {
            {
                pos = { x = 5500, y = 60, z = 6500 },
                name = "Relic",
                team = TEAM_BLUE,
                spawn = 180,
                respawn = 180,
                advise = true,
                locked = false,
                precenceObject = (player.team == TEAM_BLUE and "Odin_Prism_Green.troy" or "Odin_Prism_Red.troy"),
            },
            {
                pos = { x = 7550, y = 60, z = 6500 },
                name = "Relic",
                team = TEAM_RED,
                spawn = 180,
                respawn = 180,
                advise = true,
                locked = false,
                precenceObject = (player.team == TEAM_RED and "Odin_Prism_Green.troy" or "Odin_Prism_Red.troy"),
            },
        },
        provingGrounds = {},
        howlingAbyss = {},
    }

    heals = {
        summonerRift = {},
        twistedTreeline = {},
        provingGrounds = {},
        crystalScar = {
            {
                name = "Heal",
                objectName = "OdinShieldRelic",
                respawn = 30,
                objects = {},
            },
        },
        howlingAbyss = {},
    }

    inhibitors = {}

    function addCampCreepAltar(object)
        if object ~= nil and object.name ~= nil then
            if object.name == "Order_Inhibit_Gem.troy" or object.name == "Chaos_Inhibit_Gem.troy" then
                table.insert(inhibitors, { object = object, destroyed = false, lefttime = 0, x = object.x, y = object.y, z = object.z, minimap = GetMinimap(object), textTick = 0 })
                return
            elseif object.name == "Order_Inhibit_Crystal_Shatter.troy" or object.name == "Chaos_Inhibit_Crystal_Shatter.troy" then
                for i,inhibitor in pairs(inhibitors) do
                    if GetDistance(inhibitor, object) < 200 then
                        local tick = GetTickCount()
                        inhibitor.dtime = tick
                        inhibitor.rtime = tick + 300000
                        inhibitor.ltime = 300000
                        inhibitor.destroyed = true
                    end
                end
                return
            end
            for i,monster in pairs(monsters[mapName]) do
                for j,camp in pairs(monster.camps) do
                    if camp.name == object.name then
                        camp.object = object
                        return
                    end
                    if object.type == "obj_AI_Minion" then
                        for k,creepPack in ipairs(camp.creeps) do
                            for l,creep in ipairs(creepPack) do
                                if object.name == creep.name then
                                    creep.object = object
                                    return
                                end
                            end
                        end
                    end
                end
            end
            for i,altar in pairs(altars[mapName]) do
                if altar.objectName == object.name then
                    altar.object = object
                    altar.textTick = 0
                    altar.minimap = GetMinimap(object)
                end
                if altar.locked then
                    for j,lockName in pairs(altar.unlockNames) do
                        if lockName == object.name then
                            altar.locked = false
                            return
                        end
                    end
                else
                    for j,lockName in pairs(altar.lockNames) do
                        if lockName == object.name then
                            altar.drawColor = 0
                            altar.drawText = ""
                            altar.locked = true
                            altar.advised = false
                            altar.advisedBefore = false
                            return
                        end
                    end
                end
            end
            for i,relic in pairs(relics[mapName]) do
                if relic.precenceObject == object.name then
                    relic.object = object
                    relic.textTick = 0
                    relic.locked = false
                    return
                end
            end
            for i,heal in pairs(heals[mapName]) do
                if heal.objectName == object.name then
                    for j,healObject in pairs(heal.objects) do
                        if (GetDistance(healObject, object) < 50) then
                            healObject.object = object
                            healObject.found = true
                            healObject.locked = false
                            return
                        end
                    end
                    local k = #heal.objects + 1
                    heals[mapName][i].objects[k] = {found = true, locked = false, object = object, x = object.x, y = object.y, z = object.z, minimap = GetMinimap(object), textTick = 0,}
                    return
                end
            end
        end
    end

    function removeCreep(object)
        if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
            for i,monster in pairs(monsters[mapName]) do
                for j,camp in pairs(monster.camps) do
                    for k,creepPack in ipairs(camp.creeps) do
                        for l,creep in ipairs(creepPack) do
                            if object.name == creep.name then
                                creep.object = nil
                                return
                            end
                        end
                    end
                end
            end
        end
    end

    function MiniMapTimersOnLoad()
        mapName = GetGame().map.shortName
        if monsters[mapName] == nil then
            mapName = nil
            monsters = nil
            addCampCreepAltar = nil
            removeCreep = nil
            addAltarObject = nil
            return
        else
            startTick = GetGame().tick
            -- CONFIG
            MMTConfig = scriptConfig("Timers 0.2", "minimapTimers")
            MMTConfig:addParam("pingOnRespawn", "Ping on respawn", SCRIPT_PARAM_ONOFF, true) -- ping location on respawn
            MMTConfig:addParam("pingOnRespawnBefore", "Ping before respawn", SCRIPT_PARAM_ONOFF, true) -- ping location before respawn
            MMTConfig:addParam("textOnRespawn", "Chat on respawn", SCRIPT_PARAM_ONOFF, true) -- print chat text on respawn
            MMTConfig:addParam("textOnRespawnBefore", "Chat before respawn", SCRIPT_PARAM_ONOFF, true) -- print chat text before respawn
            MMTConfig:addParam("adviceEnemyMonsters", "Advice enemy monster", SCRIPT_PARAM_ONOFF, true) -- advice enemy monster, or just our monsters
            MMTConfig:addParam("adviceBefore", "Advice Time", SCRIPT_PARAM_SLICE, 20, 1, 40, 0) -- time in second to advice before monster respawn
            MMTConfig:addParam("textOnMap", "Text on map", SCRIPT_PARAM_ONOFF, true) -- time in second on map
            for i,monster in pairs(monsters[mapName]) do
                monster.isSeen = false
                for j,camp in pairs(monster.camps) do
                    camp.enemyTeam = (camp.team == TEAM_ENEMY)
                    camp.textTick = 0
                    camp.status = 0
                    camp.drawText = ""
                    camp.drawColor = 0xFF00FF00
                end
            end
            for i = 1, objManager.maxObjects do
                local object = objManager:getObject(i)
                if object ~= nil then
                    addCampCreepAltar(object)
                end
            end
            AddCreateObjCallback(addCampCreepAltar)
            AddDeleteObjCallback(removeCreep)
        end
    end
    function MiniMapTimersOnTick()
        if GetGame().isOver then return end
        local GameTime = (GetTickCount()-startTick) / 1000
        local monsterCount = 0
        for i,monster in pairs(monsters[mapName]) do
            for j,camp in pairs(monster.camps) do
                local campStatus = 0
                for k,creepPack in ipairs(camp.creeps) do
                    for l,creep in ipairs(creepPack) do
                        if creep.object ~= nil and creep.object.valid and creep.object.dead == false then
                            if l == 1 then
                                campStatus = 1
                            elseif campStatus ~= 1 then
                                campStatus = 2
                            end
                        end
                    end
                end
                --[[  Not used until camp.showOnMinimap work
                if (camp.object and camp.object.showOnMinimap == 1) then
                -- camp is here
                if campStatus == 0 then campStatus = 3 end
                elseif camp.status == 3 then                        -- empty not seen when killed
                campStatus = 5
                elseif campStatus == 0 and (camp.status == 1 or camp.status == 2) then
                campStatus = 4
                camp.deathTick = tick
                end
                ]]
                -- temp fix until camp.showOnMinimap work
                -- not so good
                if camp.object ~= nil and camp.object.valid then
                    camp.minimap = GetMinimap(camp.object)
                    if campStatus == 0 then
                        if (camp.status == 1 or camp.status == 2) then
                            campStatus = 4
                            camp.advisedBefore = false
                            camp.advised = false
                            camp.respawnTime = math.ceil(GameTime) + monster.respawn
                            camp.respawnText = (camp.enemyTeam and "Enemy " or "")..monster.name.." respawn at "..TimerText(camp.respawnTime)
                        elseif (camp.status == 4) then
                            campStatus = 4
                        else
                            campStatus = 3
                        end
                    end
                elseif camp.pos ~= nil then
                    camp.minimap = GetMinimap(camp.pos)
                    if (GameTime < monster.spawn) then
                        campStatus = 4
                        camp.advisedBefore = true
                        camp.advised = true
                        camp.respawnTime = monster.spawn
                        camp.respawnText = (camp.enemyTeam and "Enemy " or "")..monster.name.." spawn at "..TimerText(camp.respawnTime)
                    end
                end
                if camp.status ~= campStatus or campStatus == 4 then
                    if campStatus ~= 0 then
                        if monster.isSeen == false then monster.isSeen = true end
                        camp.status = campStatus
                    end
                    if camp.status == 1 then                -- ready
                        camp.drawText = "ready"
                        camp.drawColor = 0xFF00FF00
                    elseif camp.status == 2 then            -- ready, master creeps dead
                        camp.drawText = "stolen"
                        camp.drawColor = 0xFFFF0000
                    elseif camp.status == 3 then            -- ready, not creeps shown
                        camp.drawText = "   ?"
                        camp.drawColor = 0xFF00FF00
                    elseif camp.status == 4 then            -- empty from creeps kill
                        local secondLeft = math.ceil(math.max(0, camp.respawnTime - GameTime))
                        if monster.advise == true and (MMTConfig.adviceEnemyMonsters == true or camp.enemyTeam == false) then
                            if secondLeft == 0 and camp.advised == false then
                                camp.advised = true
                                if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.."</font><font color='#FFAA00'> has respawned</font>") end
                                if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
                            elseif secondLeft <= MMTConfig.adviceBefore and camp.advisedBefore == false then
                                camp.advisedBefore = true
                                if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.."</font><font color='#FFAA00'> will respawn in </font><font color='#00FFCC'>"..secondLeft.." sec</font>") end
                                if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
                            end
                        end
                        -- temp fix until camp.showOnMinimap work
                        if secondLeft == 0 then
                            camp.status = 0
                        end
                        camp.drawText = " "..TimerText(secondLeft)
                        camp.drawColor = 0xFFFFFF00
                    elseif camp.status == 5 then            -- camp found empty (not using yet)
                        camp.drawText = "   -"
                        camp.drawColor = 0xFFFF0000
                    end
                end
                -- shift click
                if IsKeyDown(16) and camp.status == 4 then
                    camp.drawText = " "..(camp.respawnTime ~= nil and TimerText(camp.respawnTime) or "")
                    camp.textUnder = (CursorIsUnder(camp.minimap.x - 9, camp.minimap.y - 5, 20, 8))
                else
                    camp.textUnder = false
                end
                if MMTConfig.textOnMap and camp.status == 4 and camp.object and camp.object.valid and camp.textTick < GetTickCount() and camp.floatText ~= camp.drawText then
                    camp.floatText = camp.drawText
                    camp.textTick = GetTickCount() + 1000
                    PrintFloatText(camp.object,6,camp.floatText)
                end
            end
        end

        -- altars
        for i,altar in pairs(altars[mapName]) do
            if altar.object and altar.object.valid then
                if altar.locked then
                    if GameTime < altar.spawn then
                        altar.secondLeft = math.ceil(math.max(0, altar.spawn - GameTime))
                    else
                        local tmpTime = ((altar.object.mana > 39600) and (altar.object.mana - 39900) / 20100 or (39600 - altar.object.mana) / 20100)
                        altar.secondLeft = math.ceil(math.max(0, tmpTime * altar.respawn))
                    end
                    altar.unlockTime = math.ceil(GameTime + altar.secondLeft)
                    altar.unlockText = altar.name.." unlock at "..TimerText(altar.unlockTime)
                    altar.drawColor = 0xFFFFFF00
                    if altar.advise == true then
                        if altar.secondLeft == 0 and altar.advised == false then
                            altar.advised = true
                            if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..altar.name.."</font><font color='#FFAA00'> is unlocked</font>") end
                            if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,altar.object.x,altar.object.y,altar.object.z,2) end
                        elseif altar.secondLeft <= MMTConfig.adviceBefore and altar.advisedBefore == false then
                            altar.advisedBefore = true
                            if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..altar.name.."</font><font color='#FFAA00'> will unlock in </font><font color='#00FFCC'>"..altar.secondLeft.." sec</font>") end
                            if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,altar.object.x,altar.object.y,altar.object.z,2) end
                        end
                    end
                    -- shift click
                    if IsKeyDown(16) then
                        altar.drawText = " "..(altar.unlockTime ~= nil and TimerText(altar.unlockTime) or "")
                        altar.textUnder = (CursorIsUnder(altar.minimap.x - 9, altar.minimap.y - 5, 20, 8))
                    else
                        altar.drawText = " "..(altar.secondLeft ~= nil and TimerText(altar.secondLeft) or "")
                        altar.textUnder = false
                    end
                    if MMTConfig.textOnMap and altar.object and altar.object.valid and altar.textTick < GetTickCount() and altar.floatText ~= altar.drawText then
                        altar.floatText = altar.drawText
                        altar.textTick = GetTickCount() + 1000
                        PrintFloatText(altar.object,6,altar.floatText)
                    end
                end
            end
        end

        -- relics
        for i,relic in pairs(relics[mapName]) do
            if (not relic.locked and (not relic.object or not relic.object.valid or relic.dead)) then
                if GameTime < relic.spawn then
                    relic.unlockTime = relic.spawn - GameTime
                else
                    relic.unlockTime = math.ceil(GameTime + relic.respawn)
                end
                relic.advised = false
                relic.advisedBefore = false
                relic.drawText = ""
                relic.unlockText = relic.name.." respawn at "..TimerText(relic.unlockTime)
                relic.drawColor = 4288610048
                --FF9EFF00
                relic.minimap = GetMinimap(relic.pos)
                relic.locked = true
            end
            if relic.locked then
                relic.secondLeft = math.ceil(math.max(0, relic.unlockTime - GameTime))
                if relic.advise == true then
                    if relic.secondLeft == 0 and relic.advised == false then
                        relic.advised = true
                        if MMTConfig.textOnRespawn then PrintChat("<font color='#00FFCC'>"..relic.name.."</font><font color='#FFAA00'> has respawned</font>") end
                        if MMTConfig.pingOnRespawn then PingSignal(PING_FALLBACK,relic.pos.x,relic.pos.y,relic.pos.z,2) end
                    elseif relic.secondLeft <= MMTConfig.adviceBefore and relic.advisedBefore == false then
                        relic.advisedBefore = true
                        if MMTConfig.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..relic.name.."</font><font color='#FFAA00'> will respawn in </font><font color='#00FFCC'>"..relic.secondLeft.." sec</font>") end
                        if MMTConfig.pingOnRespawnBefore then PingSignal(PING_FALLBACK,relic.pos.x,relic.pos.y,relic.pos.z,2) end
                    end
                end
                -- shift click
                if IsKeyDown(16) then
                    relic.drawText = " "..(relic.unlockTime ~= nil and TimerText(relic.unlockTime) or "")
                    relic.textUnder = (CursorIsUnder(relic.minimap.x - 9, relic.minimap.y - 5, 20, 8))
                else
                    relic.drawText = " "..(relic.secondLeft ~= nil and TimerText(relic.secondLeft) or "")
                    relic.textUnder = false
                end
            end
        end

        for i,heal in pairs(heals[mapName]) do
            for j,healObject in pairs(heal.objects) do
                if (not healObject.locked and healObject.found and (not healObject.object or not healObject.object.valid or healObject.object.dead)) then
                    healObject.drawColor = 0xFF00FF04
                    healObject.unlockTime = math.ceil(GameTime + heal.respawn)
                    healObject.drawText = ""
                    healObject.found = false
                    healObject.locked = true
                end
                if healObject.locked then
                    -- shift click
                    local secondLeft = math.ceil(math.max(0, healObject.unlockTime - GameTime))
                    if IsKeyDown(16) then
                        healObject.drawText = " "..(healObject.unlockTime ~= nil and TimerText(healObject.unlockTime) or "")
                        healObject.textUnder = (CursorIsUnder(healObject.minimap.x - 9, healObject.minimap.y - 5, 20, 8))
                    else
                        healObject.drawText = " "..(secondLeft ~= nil and TimerText(secondLeft) or "")
                        healObject.textUnder = false
                    end
                    if secondLeft == 0 then healObject.locked = false end
                end
            end
        end
        -- inhib
        for i,inhibitor in pairs(inhibitors) do
            if inhibitor.destroyed then
                local tick = GetTickCount()
                if inhibitor.rtime < tick then
                    inhibitor.destroyed = false
                else
                    inhibitor.ltime = (inhibitor.rtime - GetTickCount()) / 1000;
                    inhibitor.drawText = TimerText(inhibitor.ltime)
                    --inhibitor.drawText = (IsKeyDown(16) and TimerText(inhibitor.rtime) or TimerText(inhibitor.rtime))
                    if MMTConfig.textOnMap and inhibitor.textTick < tick then
                        inhibitor.textTick = tick + 1000
                        PrintFloatText(inhibitor.object,6,inhibitor.drawText)
                    end
                end
            end
        end
    end

    function MiniMapTimersOnDraw()
        if GetGame().isOver then return end
        for i,monster in pairs(monsters[mapName]) do
            if monster.isSeen == true then
                for j,camp in pairs(monster.camps) do
                    if camp.status == 2 then
                        DrawText("X",16,camp.minimap.x - 4, camp.minimap.y - 5, camp.drawColor)
                    elseif camp.status == 4 then
                        DrawText(camp.drawText,16,camp.minimap.x - 9, camp.minimap.y - 5, camp.drawColor)
                    end
                end
            end
        end
        for i,altar in pairs(altars[mapName]) do
            if altar.locked then
                DrawText(altar.drawText,16,altar.minimap.x - 9, altar.minimap.y - 5, altar.drawColor)
            end
        end
        for i,relic in pairs(relics[mapName]) do
            if relic.locked then
                DrawText(relic.drawText,16,relic.minimap.x - 9, relic.minimap.y - 5, relic.drawColor)
            end
        end
        for i,heal in pairs(heals[mapName]) do
            for j,healObject in pairs(heal.objects) do
                if healObject.locked then
                    DrawText(healObject.drawText,16,healObject.minimap.x - 9, healObject.minimap.y - 5, healObject.drawColor)
                end
            end
        end
        for i,inhibitor in pairs(inhibitors) do
            if inhibitor.destroyed == true then
                DrawText(inhibitor.drawText,16,inhibitor.minimap.x - 9, inhibitor.minimap.y - 5, 0xFFFFFF00)
            end
        end
    end

    function MiniMapTimersOnWndMsg(msg,key)
        if msg == WM_LBUTTONDOWN and IsKeyDown(16) then
            for i,monster in pairs(monsters[mapName]) do
                if monster.isSeen == true then
                    if monster.iconUnder then
                        monster.advise = not monster.advise
                        break
                    else
                        for j,camp in pairs(monster.camps) do
                            if camp.textUnder then
                                if camp.respawnText ~= nil then SendChat(""..camp.respawnText) end
                                break
                            end
                        end
                    end
                end
            end
            for i,altar in pairs(altars[mapName]) do
                if altar.locked and altar.textUnder then
                    if altar.unlockText ~= nil then SendChat(""..altar.unlockText) end
                    break
                end
            end
        end
    end
end

-- ############################################# STUN ALERT ################################################

--[[
Stun Alert v1.4 by eXtragoZ

	Checks the number of CC off-cooldown that could disrupt channels: silences, knockbacks, stuns, and suppression
	
	Features:
		- Sphere marker for champions with CC
		- The sphere is thicker depending on how much CC has the enemy
		- Script will print the number of champions that currently has a CC and the number of CC
		- You can move it with shift + mouse
	
	Types of CC:
		- Hard CC (disrupt the channelling)
			- Airborne
				- Knockback
				- Knockup
				- Pull/Fling
			- Forced Action
				- Charm
				- Fear
				- Flee
				- Taunt
			- Polymorph
			- Silence
			- Stun
			- Suppression
		- Soft CC
			- Blind
			- Entangle
			- Slow
			- Snare
			- Wall
]]
local basicthickness = 10
local radius = 60
local tablex = 550
local tabley = 645
local UIHK = 16 --shift
local moveui = false
--[[		Code		]]
PrintChat(" >> Stun alert v1.4 loaded!")
function StunAlertOnDraw()
	local stunChamps = 0
	local amountCC = 0
	for i=1, heroManager.iCount do
		local target = heroManager:GetHero(i)
		if target.team ~= myHero.team and not target.dead then
			local targetCC = GetTargetCC("HardCC",target)
			if targetCC > 0 then
				stunChamps = stunChamps+1
				amountCC = amountCC+targetCC
				if target.visible then
					thickness = basicthickness*targetCC
					for j=1, thickness do
						local ycircle = (j*(radius/thickness*2)-radius)
						local r = math.sqrt(radius^2-ycircle^2)
						ycircle = ycircle/1.3
						DrawCircle(target.x, target.y+250+ycircle, target.z, r, 0x00FF00)
					end
				end
			end
		end
	end
	if moveui then tablex,tabley = GetCursorPos().x-40,GetCursorPos().y-15 end

	if KCConfig.StunAlertSummary then
		DrawText("Hard CC: "..amountCC, 20, tablex, tabley, 0xFFFFFF00)
		DrawText("CC champions: "..stunChamps, 20, tablex, tabley+15, 0xFFFFFF00)
	end
end
function GetTargetCC(typeCC,target)
	local HardCC, Airborne, Charm, Fear, Taunt, Polymorph, Silence, Stun, Suppression = 0, 0, 0, 0, 0, 0, 0, 0, 0
	local SoftCC, Blind, Entangle, Slow, Snare, Wall = 0, 0, 0, 0, 0, 0
	local targetName = target.charName
	local annieStun = nil
	local QREADY = (target:CanUseSpell(_Q) == 3)
	local WREADY = (target:CanUseSpell(_W) == 3)
	local EREADY = (target:CanUseSpell(_E) == 3)
	local RREADY = (target:CanUseSpell(_R) == 3)
	if targetName == "Ahri" then
		if EREADY then
			HardCC = HardCC+1
			Charm = Charm+1
		end
	elseif targetName == "Akali" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Alistar" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if WREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Amumu" then
		if QREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Entangle = Entangle+1
		end
	elseif targetName == "Anivia" then
		if QREADY then
			HardCC = HardCC+1
			Stun = Stun+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if WREADY then
			SoftCC = SoftCC+1
			Wall = Wall+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Annie" then
		if annieStun ~= nil and annieStun.valid and target:GetDistance(annieStun) <= 100 then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Ashe" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Stun = Stun+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Blitzcrank" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if RREADY then
			HardCC = HardCC+1
			Silence = Silence+1
		end
	elseif targetName == "Brand" then
		if QREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Caitlyn" then
		if WREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Cassiopeia" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Stun = Stun+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Chogath" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if WREADY then
			HardCC = HardCC+1
			Silence = Silence+1
		end
	elseif targetName == "Darius" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1			
		end
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Diana" then
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "DrMundo" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Draven" then
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Elise" then
		if EREADY and target:GetSpellData(_E).name == "EliseHumanE" then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Evelynn" then
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1			
		end
	elseif targetName == "FiddleSticks" then
		if QREADY then
			HardCC = HardCC+1
			Fear = Fear+1
		end
		if EREADY then
			HardCC = HardCC+1
			Silence = Silence+1
		end
	elseif targetName == "Fizz" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1	
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Galio" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1			
		end
		if RREADY then
			HardCC = HardCC+1
			Taunt = Taunt+1			
		end
	elseif targetName == "Gangplank" then
		SoftCC = SoftCC+1
		Slow = Slow+1	
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1	
		end
	elseif targetName == "Garen" then
		if QREADY then
			HardCC = HardCC+1
			Silence = Silence+1			
		end
	elseif targetName == "Gragas" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1			
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1		
		end
	elseif targetName == "Graves" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1			
		end
	elseif targetName == "Hecarim" then
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1	
		end
		if RREADY then
			HardCC = HardCC+1
			Fear = Fear+1
		end
	elseif targetName == "Heimerdinger" then
		if EREADY then
			HardCC = HardCC+1
			Stun = Stun+1
			SoftCC = SoftCC+1
			Blind = Blind+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Irelia" then
		if EREADY then
			if (target.health/target.maxHealth) <= (myHero.health/myHero.maxHealth) then
				HardCC = HardCC+1
				Stun = Stun+1
			else
				SoftCC = SoftCC+1
				Slow = Slow+1
			end			
		end
	elseif targetName == "Janna" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "JarvanIV" then
		if QREADY and EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Wall = Wall+1
		end
	elseif targetName == "Jax" then
		if EREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Jayce" then
		if QREADY and target:GetSpellData(_Q).name == "JayceToTheSkies" then
			SoftCC = SoftCC+1
			Slow = Slow+1			
		end
		if EREADY and target:GetSpellData(_E).name == "JayceThunderingBlow" then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Karma" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Karthus" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Kassadin" then
		if QREADY then
			HardCC = HardCC+1
			Silence = Silence+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Kayle" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Kennen" then
		if QREADY and WREADY and EREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
		if RREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Khazix" then
		SoftCC = SoftCC+1
		Slow = Slow+1
	elseif targetName == "KogMaw" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "LeBlanc" then
		if QREADY and (WREADY or EREADY or RREADY) then
			HardCC = HardCC+1
			Silence = Silence+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
			Snare = Snare+1
		end
		if RREADY and target:GetSpellData(_R).name == "LeblancChaosOrbM" and (WREADY or EREADY or QREADY) then
			HardCC = HardCC+1
			Silence = Silence+1
		end
		if RREADY and target:GetSpellData(_R).name == "LeblancSoulShackleM" then
			SoftCC = SoftCC+1
			Slow = Slow+1
			Snare = Snare+1
		end
	elseif targetName == "LeeSin" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Leona" then
		if QREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
		if RREADY then
			HardCC = HardCC+1
			Stun = Stun+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Lulu" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if WREADY then
			HardCC = HardCC+1
			Polymorph = Polymorph+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Lux" then
		if QREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Malphite" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Malzahar" then
		if QREADY then
			HardCC = HardCC+1
			Silence = Silence+1			
		end
		if RREADY then
			HardCC = HardCC+1
			Suppression = Suppression+1
		end
	elseif targetName == "Maokai" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if WREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
	elseif targetName == "MissFortune" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Morgana" then
		if QREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
		if RREADY then
			HardCC = HardCC+1
			Stun = Stun+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Nami" then
		if QREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Nasus" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Nautilus" then
		HardCC = HardCC+1
		Stun = Stun+1
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end	
	elseif targetName == "Nocturne" then
		if EREADY then
			HardCC = HardCC+1
			Fear = Fear+1
		end
	elseif targetName == "Nunu" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Olaf" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Orianna" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Pantheon" then
		if WREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Poppy" then
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			Stun = Stun+1
		end
	elseif targetName == "Rammus" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if EREADY then
			HardCC = HardCC+1
			Taunt = Taunt+1	
		end
	elseif targetName == "Renekton" then
		if WREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Rengar" then -----------------------------------
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Riven" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if WREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Rumble" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Ryze" then
		if WREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
	elseif targetName == "Sejuani" then
		SoftCC = SoftCC+1
		Slow = Slow+1
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Shaco" then
		if WREADY then
			HardCC = HardCC+1
			Fear = Fear+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Shen" then
		if EREADY then
			HardCC = HardCC+1
			Taunt = Taunt+1
		end
	elseif targetName == "Shyvana" then
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Singed" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Sion" then
		if QREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Skarner" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Suppression = Suppression+1
		end
	elseif targetName == "Sona" then-------------
		if RREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Soraka" then
		if EREADY then
			HardCC = HardCC+1
			Silence = Silence+1
		end
	elseif targetName == "Swain" then
		if QREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if WREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
	elseif targetName == "Syndra" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Talon" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if EREADY then
			HardCC = HardCC+1
			Silence = Silence+1
		end
	elseif targetName == "Taric" then
		if EREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Teemo" then
		if QREADY then
			SoftCC = SoftCC+1
			Blind = Blind+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Tristana" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Trundle" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
			Wall = Wall+1
		end
	elseif targetName == "Tryndamere" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1			
		end
	elseif targetName == "TwistedFate" then
		if target:GetSpellData(_W).name == "goldcardlock" then
			HardCC = HardCC+1
			Stun = Stun+1
		end
		if target:GetSpellData(_W).name == "redcardlock" then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Twitch" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Udyr" then---------
		if EREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Urgot" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Suppression = Suppression+1
		end
	elseif targetName == "Varus" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
	elseif targetName == "Vayne" then
		if EREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
			Stun = Stun+1
		end
	elseif targetName == "Veigar" then
		if EREADY then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "Vi" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Viktor" then
		if WREADY then
			HardCC = HardCC+1
			Stun = Stun+1
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Silence = Silence+1
		end
	elseif targetName == "Vladimir" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Volibear" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Warwick" then
		if RREADY then
			HardCC = HardCC+1
			Suppression = Suppression+1
		end
	elseif targetName == "MonkeyKing" then
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Xerath" then
		if EREADY and (QREADY or RREADY) then
			HardCC = HardCC+1
			Stun = Stun+1
		end
	elseif targetName == "XinZhao" then
		if QREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	elseif targetName == "Yorick" then
		if WREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Zed" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Ziggs" then
		if WREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Zilean" then
		if EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
	elseif targetName == "Zyra" then
		if WREADY and EREADY then
			SoftCC = SoftCC+1
			Slow = Slow+1
		end
		if EREADY then
			SoftCC = SoftCC+1
			Snare = Snare+1
		end
		if RREADY then
			HardCC = HardCC+1
			Airborne = Airborne+1
		end
	end
	if typeCC == "HardCC" then return HardCC
	elseif typeCC == "Airborne" then return Airborne
	elseif typeCC == "Charm" then return Charm
	elseif typeCC == "Fear" then return Fear
	elseif typeCC == "Taunt" then return Taunt
	elseif typeCC == "Polymorph" then return Polymorph
	elseif typeCC == "Silence" then return Silence
	elseif typeCC == "Stun" then return Stun
	elseif typeCC == "Suppression" then return Suppression
	elseif typeCC == "SoftCC" then return SoftCC
	elseif typeCC == "Blind" then return Blind
	elseif typeCC == "Entangle" then return Entangle
	elseif typeCC == "Slow" then return Slow
	elseif typeCC == "Snare" then return Snare
	elseif typeCC == "Wall" then return Wall
	else return 0 end
end
function StunAlertOnCreateObj(obj)
	if obj.name:find("StunReady.troy") then
		for i = 1, heroManager.iCount do
		local h = heroManager:getHero(i)
			if h.team ~= myHero.team and GetDistance(obj) <= 100 then
				annieStun = obj 
			end
		end
	end
end
function StunAlertOnWndMsg(msg,key)
	if msg == WM_LBUTTONUP or not IsKeyDown(UIHK) then moveui = false end
    if msg == WM_LBUTTONDOWN and IsKeyDown(UIHK) then
		if CursorIsUnder(tablex, tabley, 130, 40) then moveui = true end
	end
end

-- ############################################# STUN ALERT ################################################

-- ############################################# TOWER RANGE ################################################


local towerRange = {
	turrets = {},
	typeText = {"OFF", "ON (enemy close)", "ON (enemy)", "ON (all)", "ON (all close)"},
	--[[         Config         ]]
	turretRange = 950,	 				-- 950
	fountainRange = 1050,	 			-- 1050
	allyTurretColor = 0x80FF00, 		-- Green color
	enemyTurretColor = 0xFF0000, 		-- Red color
	activeType = 1,						-- 0 Off, 1 Close enemy towers, 2 All enemy towers, 3 Show all, 4 Show all close
	tickUpdate = 1000,
	nextUpdate = 0,
}

function towerRange.checkTurretState()
	if towerRange.activeType > 0 then
		for name, turret in pairs(towerRange.turrets) do
			turret.active = false
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil and object.type == "obj_AI_Turret" then
				local name = object.name
				if towerRange.turrets[name] ~= nil then towerRange.turrets[name].active = true end
			end
		end
		for name, turret in pairs(towerRange.turrets) do
			if turret.active == false then towerRange.turrets[name] = nil end
		end
	end
end

function TowerRangeOnDraw()
	if GetGame().isOver then return end
	if towerRange.activeType > 0 then
		for name, turret in pairs(towerRange.turrets) do
			if turret ~= nil then
				if (towerRange.activeType == 1 and turret.team ~= player.team and player.dead == false and GetDistance(turret) < 2000)
				or (towerRange.activeType == 2 and turret.team ~= player.team)
				or (towerRange.activeType == 3)
				or (towerRange.activeType == 4 and player.dead == false and GetDistance(turret) < 2000) then
					DrawCircle(turret.x, turret.y, turret.z, turret.range, turret.color)
				end
			end
		end
	end
end
function TowerRangeOnTick()
end
function TowerRangeOnDeleteObj(object)
	if object ~= nil and object.type == "obj_AI_Turret" then
		for name, turret in pairs(towerRange.turrets) do
			if name == object.name then
				towerRange.turrets[name] = nil
				return
			end
		end
	end
end
function TowerRangeOnLoad()
	gameState = GetGame()
	for i = 1, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil and object.type == "obj_AI_Turret" then
			local turretName = object.name
			towerRange.turrets[turretName] = {
				object = object,
				team = object.team,
				color = (object.team == player.team and towerRange.allyTurretColor or towerRange.enemyTurretColor),
				range = towerRange.turretRange,
				x = object.x,
				y = object.y,
				z = object.z,
				active = false,
			}
			if turretName == "Turret_OrderTurretShrine_A" or turretName == "Turret_ChaosTurretShrine_A" then
				towerRange.turrets[turretName].range = towerRange.fountainRange
				for j = 1, objManager.maxObjects do
					local object2 = objManager:getObject(j)
					if object2 ~= nil and object2.type == "obj_SpawnPoint" and GetDistance(object, object2) < 1000 then
						towerRange.turrets[turretName].x = object2.x
						towerRange.turrets[turretName].z = object2.z
					elseif object2 ~= nil and object2.type == "obj_HQ" and object2.team == object.team then
						towerRange.turrets[turretName].y = object2.y
					end
				end
			end
		end
	end
end

-- ############################################# TOWER RANGE ################################################

-- ############################################# MINION MARKER ################################################

function MinionMarkerOnLoad()
	minionTable = {}
	for i = 0, objManager.maxObjects do
		local obj = objManager:GetObject(i)
		if obj ~= nil and obj.type ~= nil and obj.type == "obj_AI_Minion" then 
			table.insert(minionTable, obj) 
		end
	end
end

function MinionMarkerOnDraw() 
	for i,minionObject in ipairs(minionTable) do
		if not ValidTarget(minionObject) then
			table.remove(minionTable, i)
			i = i - 1
		elseif minionObject ~= nil and myHero:GetDistance(minionObject) ~= nil and myHero:GetDistance(minionObject) < 1500 and minionObject.health ~= nil and minionObject.health <= myHero:CalcDamage(minionObject, myHero.addDamage+myHero.damage) and minionObject.visible ~= nil and minionObject.visible == true then
			for g = 0, 6 do
				DrawCircle(minionObject.x, minionObject.y, minionObject.z,80 + g,255255255)
			end
        end
    end
end


function MinionMarkerOnCreateObj(object)
	if object ~= nil and object.type ~= nil and object.type == "obj_AI_Minion" then table.insert(minionTable, object) end
end

-- ############################################# MINION MARKER ################################################

-- ############################################# HIDDENOBJECTS ################################################



--[[
	Script: Hidden Objects Display v0.3
	Author: SurfaceS
	
	required libs : 		
	required sprites : 		Hidden Objects Sprites (if used)
	exposed variables : 	hiddenObjects
	
	UPDATES :
	v0.1				initial release
	v0.1b				change spells names for 3 champs (thx TRUS)
	v0.1c				change spells names for teemo
	v0.1d				fix the perma show
	v0.2				BoL Studio Version
	v0.3				Reworked
	-- todo : maybe add zira ?
	
	USAGE :
	Hold shift key to see the hidden object's range.
]]

local hiddenObjects = {
	--[[      CONFIG      ]]
	showOnMiniMap = true,			-- show objects on minimap
	useSprites = true,				-- show sprite on minimap
	--[[      GLOBAL      ]]
	objectsToAdd = {
		{ name = "ItemMiniWard", objectType = "wards", spellName = "ItemMiniWard", charName = "ItemMiniWard", color = 0x0000FF00, range = 1450, duration = 60000, sprite = "greenPoint"},
		{ name = "ItemGhostWard", objectType = "wards", spellName = "ItemGhostWard", charName = "ItemGhostWard", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
		{ name = "VisionWard", objectType = "wards", spellName = "VisionWard", charName = "VisionWard", color = 0x00FF00FF, range = 1450, duration = 180000, sprite = "yellowPoint"},
		{ name = "SightWard", objectType = "wards", spellName = "SightWard", charName = "SightWard", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
		{ name = "WriggleLantern", objectType = "wards", spellName = "WriggleLantern", charName = "WriggleLantern", color = 0x0000FF00, range = 1450, duration = 180000, sprite = "greenPoint"},
		{ name = "Jack In The Box", objectType = "boxes", spellName = "JackInTheBox", charName = "ShacoBox", color = 0x00FF0000, range = 300, duration = 60000, sprite = "redPoint"},
		{ name = "Cupcake Trap", objectType = "traps", spellName = "CaitlynYordleTrap", charName = "CaitlynTrap", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
		{ name = "Noxious Trap", objectType = "traps", spellName = "Bushwhack", charName = "Nidalee_Spear", color = 0x00FF0000, range = 300, duration = 240000, sprite = "cyanPoint"},
		{ name = "Noxious Trap", objectType = "traps", spellName = "BantamTrap", charName = "TeemoMushroom", color = 0x00FF0000, range = 300, duration = 600000, sprite = "cyanPoint"},
		{ name = "Seed", objectType = "traps", spellName = "zyraseed", charName = "ZyraSeed", color = 0x00FF0000, range = 300, duration = 30000, sprite = "cyanPoint"},
		-- to confirm spell
		{ name = "DoABarrelRoll", objectType = "boxes", spellName = "MaokaiSapling2", charName = "MaokaiSproutling", color = 0x00FF0000, range = 300, duration = 35000, sprite = "redPoint"},
	},
	tmpObjects = {},
	sprites = {
		cyanPoint = { spriteFile = "PingMarkerCyan_8", }, 
		redPoint = { spriteFile = "PingMarkerRed_8", }, 
		greenPoint = { spriteFile = "PingMarkerGreen_8", }, 
		yellowPoint = { spriteFile = "PingMarkerYellow_8", },
		greyPoint = { spriteFile = "PingMarkerGrey_8", },
	},
	objects = {},
}
	--[[      CODE      ]]
	function hiddenObjects.objectExist(charName, pos, tick)
		for i,obj in pairs(hiddenObjects.objects) do
			if obj.object == nil and obj.charName == charName and GetDistance(obj.pos, pos) < 200 and tick < obj.seenTick then
				return i
			end
		end	
		return nil
	end

	function hiddenObjects.addObject(objectToAdd, pos, object)
		-- add the object
		local tick = GetTickCount()
		local objId = objectToAdd.charName..(math.floor(pos.x) + math.floor(pos.z))
		--check if exist
		local objectExist = hiddenObjects.objectExist(objectToAdd.charName, {x = pos.x, z = pos.z,}, tick - 2000)
		if objectExist ~= nil then
			objId = objectExist
		end
		if hiddenObjects.objects[objId] == nil then
			hiddenObjects.objects[objId] = {
				object = object,
				color = objectToAdd.color,
				range = objectToAdd.range,
				sprite = objectToAdd.sprite,
				charName = objectToAdd.charName,
				seenTick = tick,
				endTick = tick + objectToAdd.duration,
				visible = (object == nil),
				objectFound = (object ~= nil),
				display = { visible = false, text = ""},
			}
		elseif hiddenObjects.objects[objId].object == nil and object ~= nil and object.valid then
			hiddenObjects.objects[objId].object = object
			hiddenObjects.objects[objId].objectFound = true
		end
		if (object ~= nil and object.valid and object.maxMana > 0) then 
		endTick = tick + object.mana 
		end
		hiddenObjects.objects[objId].pos = {x = pos.x, y = pos.y, z = pos.z, }
		if hiddenObjects.showOnMiniMap == true then hiddenObjects.objects[objId].minimap = GetMinimap(pos) end
	end

	function HiddenObjectsOnCreateObj(object)
		if object ~= nil and object.valid and object.type == "obj_AI_Minion" then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if object.name == objectToAdd.name then
					local tick = GetTickCount()
					table.insert(hiddenObjects.tmpObjects, {tick = tick, object = object})
				end
			end
		end
	end

	function HiddenObjectsOnProcessSpell(object,spell)
		if object ~= nil and object.valid and object.team == TEAM_ENEMY and object.type == "obj_AI_Hero" then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if spell.name:lower() == objectToAdd.spellName then
					ticked = GetTickCount()
					hiddenObjects.addObject(objectToAdd, spell.endPos)
				end
			end
		end
	end

	function HiddenObjectsOnDeleteObj(object)
		if object ~= nil and object.valid and object.name ~= nil and object.type == "obj_AI_Minion" then
			for i,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
				if object.charName == objectToAdd.charName then
					-- remove the object
					for j,obj in pairs(hiddenObjects.objects) do
						if obj.object ~= nil and obj.object.valid and obj.object.networkID ~= nil and obj.object.networkID == object.networkID then
							hiddenObjects.objects[j] = nil
							return
						end
					end
				end
			end
		end
	end

	function HiddenObjectsOnDraw()
		if GetGame().isOver then return end
		local shiftKeyPressed = IsKeyDown(16)
		for i,obj in pairs(hiddenObjects.objects) do
			if obj.visible == true then
				if obj.object ~= nil and obj.object.valid then
					DrawCircle(obj.pos.x, obj.pos.y, obj.pos.z, 100, 0x00FFFFFF)
				else
					DrawCircle(obj.pos.x, obj.pos.y, obj.pos.z, 100, obj.color)
				end
				DrawCircle(obj.pos.x, obj.pos.y, obj.pos.z, (shiftKeyPressed and obj.range or 200), obj.color)
				--minimap
				if hiddenObjects.showOnMiniMap == true then
					if hiddenObjects.useSprites then
						hiddenObjects.sprites[obj.sprite].sprite:Draw(obj.minimap.x, obj.minimap.y, 0xFF)
					else
						DrawText("o",31,obj.minimap.x-7,obj.minimap.y-13,obj.color)
					end
					if obj.display.visible then
						DrawText(obj.display.text,14,obj.display.x,obj.display.y,obj.display.color)
					end
				end
			end
		end
	end

	function HiddenObjectsOnTick()
		if GetGame().isOver then return end
		local tick = GetTickCount()
		for i,obj in pairs(hiddenObjects.tmpObjects) do
			if tick > obj.tick + 1000 or obj.object == nil or not obj.object.valid or obj.object.team == player.team then
				hiddenObjects.tmpObjects[i] = nil
			else
				for j,objectToAdd in pairs(hiddenObjects.objectsToAdd) do
					if obj.object.charName == objectToAdd.charName and obj.object.team == TEAM_ENEMY then
						hiddenObjects.addObject(objectToAdd, obj.object, obj.object)
						hiddenObjects.tmpObjects[i] = nil
						break
					end
				end
			end
		end
		for i,obj in pairs(hiddenObjects.objects) do
			if tick > obj.endTick 
			or (obj.objectFound and obj.object.valid and obj.object.team == player.team)
			or (obj.objectFound and (not obj.object.valid or obj.object.dead or (obj.object.maxHealth > 0 and obj.object.health == 0))) then
				hiddenObjects.objects[i] = nil
			else
			--objectType = "wards"
				if obj.object == nil or (obj.objectFound and obj.object.valid and not obj.object.dead) then
					obj.visible = true
				else
					obj.visible = false
				end
				-- cursor pos
				if obj.visible and GetDistanceFromMouse(obj.pos) < 150 then
					local cursor = GetCursorPos()
					obj.display.color = (obj.objectFound and 0xFFFF0000 or 0xFF00FF00)
					obj.display.text = timerText((obj.endTick-tick)/1000)
					obj.display.x = cursor.x - 50
					obj.display.y = cursor.y - 50
					obj.display.visible = true
				else
					obj.display.visible = false
				end
			end
		end
	end

	function HiddenObjectsOnLoad()
		gameState = GetGame()
		if hiddenObjects.showOnMiniMap and hiddenObjects.useSprites then
			for i,sprite in pairs(hiddenObjects.sprites) do hiddenObjects.sprites[i].sprite = GetSprite("hiddenObjects/"..sprite.spriteFile..".dds") end
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil then OnCreateObj(object) end
		end
	end
	
-- ############################################# HIDDEN OBJECTS ################################################

-- ############################################# JUNGLE DISPLAY ################################################

--[[
        Script: Jungle Display v0.1d
		Author: SurfaceS
		
		required libs : 		
		required sprites : 		Jungle Sprites (if jungle.useSprites = true)
		exposed variables : 	-
		
		UPDATES :
		v0.1					initial release
		v0.1b					added twisted treeline + ping and chat functions.
		v0.1c					added ingame time.
		v0.1d					added advice on/off by click + send chat respawn on click
		v0.1e					added use minimap only mode, use "start" and "gameOver" lib now.
		v0.1f					local variables
		v0.2					BoL Studio Version
		
		USAGE :
		The script allow you to move and rotate the display
		
		Icons :
		You have 2 icons on the top left of the jungle display.
		First is for moving, the second is for rotate the display.
		The third icon is advice or not on this monster
		
		Moving :
		Hold the shift key, clic the move icon and drag the jungle display were you want.
		Settings are saved between games
		
		Rotate :
		Hold the shift key, clic the rotate icon. (4 types of rotation)
		Settings are saved between games
		
		Send to all by click : hold the shift key, and click on the timer.
]]


--[[      GLOBAL      ]]
local jungle = {}

-- [[     CONFIG     ]]
jungle.pingOnRespawn = true				-- ping location on respawn
jungle.pingOnRespawnBefore = true		-- ping location before respawn
jungle.textOnRespawn = true				-- print chat text on respawn
jungle.textOnRespawnBefore = true		-- print chat text before respawn
jungle.adviceBefore = 20				-- time in second to advice before monster respawn
jungle.adviceEnemyMonsters = true		-- advice enemy monster, or just our monsters
jungle.useSprites = true				-- nice shown or not
jungle.useMiniMapVersion = true			-- use minimap version (erase all display sprite or text)

--[[      GLOBAL      ]]

jungle.monsters = {
	summonerRift = {
		{	-- baron
			name = "baron",
			spriteFile = "Baron_Square_64",
			respawn = 420,
			advise = true,
			camps = {
				{
					name = "monsterCamp_12",
					creeps = { { { name = "Worm12.1.1" }, }, },
					team = TEAM_NEUTRAL,
				},
			},
		},
		{	-- dragon
			name = "dragon",
			spriteFile = "Dragon_Square_64",
			respawn = 360,
			advise = true,
			camps = {
				{
					name = "monsterCamp_6",
					creeps = { { { name = "Dragon6.1.1" }, }, },
					team = TEAM_NEUTRAL,
				},
			},
		},
		{	-- blue
			name = "blue",
			spriteFile = "AncientGolem_Square_64",
			respawn = 300,
			advise = true,
			camps = {
				{
					name = "monsterCamp_1",
					creeps = { { { name = "AncientGolem1.1.1" }, { name = "YoungLizard1.1.2" }, { name = "YoungLizard1.1.3" }, }, },
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_7",
					creeps = { { { name = "AncientGolem7.1.1" }, { name = "YoungLizard7.1.2" }, { name = "YoungLizard7.1.3" }, }, },
					team = TEAM_RED,
				},
			},
		},
		{	-- red
			name = "red",
			spriteFile = "LizardElder_Square_64",
			respawn = 300,
			advise = true,
			camps = {
				{
					name = "monsterCamp_4",
					creeps = { { { name = "LizardElder4.1.1" }, { name = "YoungLizard4.1.2" }, { name = "YoungLizard4.1.3" }, }, },
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_10",
					creeps = { { { name = "LizardElder10.1.1" }, { name = "YoungLizard10.1.2" }, { name = "YoungLizard10.1.3" }, }, },
					team = TEAM_RED,
				},
			},
		},
		{	-- wolves
			name = "wolves",
			spriteFile = "Giantwolf_Square_64",
			respawn = 60,
			advise = false,
			camps = {
				{
					name = "monsterCamp_2",
					creeps = { { { name = "GiantWolf2.1.3" }, { name = "wolf2.1.1" }, { name = "wolf2.1.2" }, }, },
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_8",
					creeps = { { { name = "GiantWolf8.1.3" }, { name = "wolf8.1.1" }, { name = "wolf8.1.2" }, }, },
					team = TEAM_RED,
				},
			},
		},
		{	-- wraiths
			name = "wraiths",
			spriteFile = "Wraith_Square_64",
			respawn = 50,
			advise = false,
			camps = {
				{
					name = "monsterCamp_3",
					creeps = { { { name = "Wraith3.1.1" }, { name = "LesserWraith3.1.2" }, { name = "LesserWraith3.1.3" }, { name = "LesserWraith3.1.4" }, }, },
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_9",
					creeps = { { { name = "Wraith9.1.1" }, { name = "LesserWraith9.1.2" }, { name = "LesserWraith9.1.3" }, { name = "LesserWraith9.1.4" }, }, },
					team = TEAM_RED,
				},
			},
		},
		{	-- Golems
			name = "Golems",
			spriteFile = "AncientGolem_Square_64",
			respawn = 60,
			advise = false,
			camps = {
				{
					name = "monsterCamp_5",
					creeps = { { { name = "Golem5.1.2" }, { name = "SmallGolem5.1.1" }, }, },
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_11",
					creeps = { { { name = "Golem11.1.2" }, { name = "SmallGolem11.1.1" }, }, },
					team = TEAM_RED,
				},
			},
		},
	},
	twistedTreeline = {
		{	-- Dragon
			name = "Dragon",
			spriteFile = "Dragon_Square_64",
			respawn = 300,
			advise = true,
			camps = {
				{
					name = "monsterCamp_7",
					creeps = { { { name = "blueDragon7$1" }, }, },
					team = TEAM_NEUTRAL,
				},
			},
		},
		{	-- Lizard
			name = "Lizard",
			spriteFile = "LizardElder_Square_64",
			respawn = 240,
			advise = true,
			camps = {
				{
					name = "monsterCamp_8",
					creeps = { { { name = "TwistedLizardElder8$1" }, }, },
					team = TEAM_NEUTRAL,
				},
			},
		},
		{	-- Ghast Wraith or Radib Wolf
			name = "Buff Camp",
			spriteFile = "Wraith_Square_64",
			respawn = 180,
			advise = true,
			camps = {
				{
					name = "monsterCamp_5",
					creeps = {
						{ { name = "Ghast5$1" }, { name = "TwistedBlueWraith5$2" }, { name = "TwistedBlueWraith5$3" }, },
						{ { name = "RabidWolf5$1" }, { name = "TwistedGiantWolf5$2" }, { name = "TwistedGiantWolf5$3" }, },
					},
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_6",
					creeps = {
						{ { name = "Ghast6$1" }, { name = "TwistedBlueWraith6$2" }, { name = "TwistedBlueWraith6$3" }, },
						{ { name = "RabidWolf6$1" }, { name = "TwistedGiantWolf6$2" }, { name = "TwistedGiantWolf6$3" }, },
					},
					team = TEAM_RED,
				},
				
			},
		},
		{	-- Small Golems - Young Lizard, Lizard, Golem
			name = "bottom small camp",
			spriteFile = "Gem_Square_64",
			respawn = 75,
			advise = false,
			camps = {
				{
					name = "monsterCamp_1",
					creeps = {
						{ { name = "Lizard1$1" }, { name = "TwistedGolem1$2" }, { name = "TwistedYoungLizard1$3" }, },
						{ { name = "TwistedBlueWraith1$1" }, { name = "TwistedTinyWraith1$2" }, { name = "TwistedTinyWraith1$3" }, { name = "TwistedTinyWraith1$4" }, },
					},
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_2",
					creeps = { 
						{ { name = "Lizard2$1" }, { name = "TwistedGolem2$2" }, { name = "TwistedYoungLizard2$3" }, },
						{ { name = "TwistedBlueWraith2$1" }, { name = "TwistedTinyWraith2$2" }, { name = "TwistedTinyWraith2$3" }, { name = "TwistedTinyWraith2$4" }, },
					 },
					team = TEAM_RED,
				},
			},
		},
		{	-- Small Golems - Young Lizard, Lizard, Golem
			name = "Top small camp",
			spriteFile = "Angel_Square_64",
			respawn = 75,
			advise = false,
			camps = {
				{
					name = "monsterCamp_3",
					creeps = { 
						{ { name = "TwistedGiantWolf3$3" }, { name = "TwistedSmallWolf3$1" }, { name = "TwistedSmallWolf3$2" }, },
						{ { name = "TwistedGolem3$1" }, { name = "TwistedGolem3$2" } },
					},
					team = TEAM_BLUE,
				},
				{
					name = "monsterCamp_4",
					creeps = { 
						{ { name = "TwistedGiantWolf4$3" }, { name = "TwistedSmallWolf4$1" }, { name = "TwistedSmallWolf4$2" }, },
						{ { name = "TwistedGolem4$1" }, { name = "TwistedGolem4$2" } },
					},
					team = TEAM_RED,
				},
			},
		},
	},
}

jungle.shiftKeyPressed = false

function _miniMap__OnLoad()
if _miniMap.init then
  local map = GetGame().map
  if not WINDOW_W or not WINDOW_H then
   WINDOW_H = GetGame().WINDOW_H
   WINDOW_W = GetGame().WINDOW_W
  end
  if WINDOW_H < 500 or WINDOW_W < 500 then return true end
  local percent = math.max(WINDOW_W/1920, WINDOW_H/1080)
  _miniMap.step = {x = 265*percent/map.x, y = -264*percent/map.y}
  _miniMap.x = WINDOW_W-270*percent - _miniMap.step.x * map.min.x
  _miniMap.y = WINDOW_H-8*percent - _miniMap.step.y * map.min.y
  _miniMap.init = nil
end
return _miniMap.init
end

if not jungle.useMiniMapVersion then
	jungle.configFile = "./Common/jungle.cfg"
	jungle.display = {}
	jungle.display.x = 500
	jungle.display.y = 20
	jungle.display.rotation = 0
	jungle.display.move = false
	jungle.display.moveUnder = false
	jungle.display.rotateUnder = false
	jungle.display.size = 64
	
	if file_exists(jungle.configFile) then jungle.display = assert(loadfile(jungle.configFile))() end

	function jungle.writeConfigs()
		local file = io.open(jungle.configFile, "w")
		if file then
			file:write("return { x = "..jungle.display.x..", y = "..jungle.display.y..", rotation = "..jungle.display.rotation..", move = false, moveUnder = false, rotateUnder = false, size = "..jungle.display.size.." }")
			file:close()
		end
	end

	if jungle.useSprites then
		jungle.icon = { 
			arrowPressed = { spriteFile = "ArrowPressed_16", }, 
			arrowReleased = { spriteFile = "ArrowReleased_16", }, 
			arrowSwitch = { spriteFile = "ArrowSwitch_16", }, 
			advise = { spriteFile = "Advise_16", }, 
			adviseRed = { spriteFile = "AdviseRed_16", },
		}
		jungle.teams = {
			team100 = {	spriteFile = "TeamBlue_64",	},
			team200 = {	spriteFile = "TeamRed_64",},
			team300 = {	spriteFile = "TeamNeutral_64", },
		}
	end
end

-- Need to be on a lib
function jungle.timerSecondLeft(tick, respawn, deathTick)
	return math.ceil(math.max(0, respawn - (tick - deathTick) / 1000))
end

function jungle.addCampAndCreep(object)
	if object ~= nil and object.name ~= nil then
		for i,monster in pairs(jungle.monsters[mapName]) do
			for j,camp in pairs(monster.camps) do
				if camp.name == object.name then
					camp.object = object
					return
				end
				if object.type == "obj_AI_Minion" then
					for k,creepPack in ipairs(camp.creeps) do
						for l,creep in ipairs(creepPack) do
							if object.name == creep.name then
								creep.object = object
								return
							end
						end
					end
				end
			end
		end
	end
end

function jungle.removeCreep(object)
	if object ~= nil and object.type == "obj_AI_Minion" and object.name ~= nil then
		for i,monster in pairs(jungle.monsters[mapName]) do
			for j,camp in pairs(monster.camps) do
				for k,creepPack in ipairs(camp.creeps) do
					for l,creep in ipairs(creepPack) do
						if object.name == creep.name then
							creep.object = nil
							return
						end
					end
				end
			end
		end
	end
end

function JungleDisplayOnLoad()
	startTick = GetGame().tick
	mapName = GetGame().map.shortName
	gameState = GetGame()
	if jungle.monsters[mapName] == nil then
		jungle = nil
		function JungleDisplayOnTick()
		end
		function JungleDisplayOnDraw()
		end
		function JungleDisplayOnCreateObj(obj)
		end
		function JungleDisplayOnWndMsg(msg, key)
		end
	else
		if jungle.useSprites and jungle.useMiniMapVersion == false then
			-- load icons drawing sprites
			for i,icon in pairs(jungle.icon) do icon.sprite = GetSprite("jungle/"..icon.spriteFile..".dds") end
			-- load side drawing sprites
			for i,camps in pairs(jungle.teams) do camps.sprite = GetSprite("jungle/"..camps.spriteFile..".dds") end
		end
		-- load monster sprites and init values
		for i,monster in pairs(jungle.monsters[mapName]) do
			if jungle.useSprites and jungle.useMiniMapVersion == false then monster.sprite = GetSprite("Characters/"..monster.spriteFile..".dds") end
			monster.isSeen = false
			for j,camp in pairs(monster.camps) do
				camp.enemyTeam = (camp.team == TEAM_ENEMY)
				camp.status = 0
				camp.drawText = ""
				camp.drawColor = 0xFF00FF00
			end
		end
		for i = 1, objManager.maxObjects do
			local object = objManager:getObject(i)
			if object ~= nil then 
				jungle.addCampAndCreep(object)
			end
		end
		
		if jungle.useMiniMapVersion then
			-- test the minimap working
			if GetMinimapX(0) == -100 then PrintChat("Minimap not working, please reload") end
			--
			function JungleDisplayOnDraw()
				if GetGame().isOver then return end
				for i,monster in pairs(jungle.monsters[mapName]) do
					if monster.isSeen == true then
						for j,camp in pairs(monster.camps) do
							if camp.status == 2 then
								DrawText("X",16,camp.minimap.x - 4, camp.minimap.y - 5, camp.drawColor)
							elseif camp.status == 4 then
								DrawText(camp.drawText,16,camp.minimap.x - 9, camp.minimap.y - 5, camp.drawColor)
							end
						end
					end
				end
			end
		elseif jungle.useSprites then
			function JungleDisplayOnDraw()
				if GetGame().isOver then return end
				local monsterCount = 0
				for i,monster in pairs(jungle.monsters[mapName]) do
					if monster.isSeen == true then
						jungle.monsters[mapName][i].sprite:Draw(jungle.display.x + monster.shift.x,jungle.display.y + monster.shift.y,0xFF)
						if monster.advise then jungle.icon.advise.sprite:Draw(jungle.display.x + monster.shift.x + jungle.display.size - 18,jungle.display.y - 2,0xFF) end
						for j,camp in pairs(monster.camps) do
							if camp.status ~= 0 then
								jungle.teams["team"..camp.team].sprite:Draw(jungle.display.x + camp.shift.x,jungle.display.y + camp.shift.y,0xFF)
								DrawText(camp.drawText,17,jungle.display.x + camp.shift.x + 10,jungle.display.y + camp.shift.y - 3,camp.drawColor)
							end
						end
						monsterCount = monsterCount + 1
					end
				end
				if monsterCount > 0 then
					jungle.icon.arrowPressed.sprite:Draw(jungle.display.x,jungle.display.y,(jungle.shiftKeyPressed and 0xFF or 0xAA))
					jungle.icon.arrowSwitch.sprite:Draw(jungle.display.x+16,jungle.display.y,(jungle.shiftKeyPressed and 0xFF or 0xAA))
				end
			end
		else
			function JungleDisplayOnDraw()
				if GetGame().isOver then return end
				local monsterCount = 0
				for i,monster in pairs(jungle.monsters[mapName]) do
					if monster.isSeen == true then
						DrawText(monster.name..(monster.advise and " *" or ""),17,jungle.display.x + monster.shift.x,jungle.display.y + monster.shift.y,0xFFFF0000)
						for j,camp in pairs(monster.camps) do
							if camp.status ~= 0 then
								DrawText(camp.team.." - "..camp.drawText,17,jungle.display.x + camp.shift.x + 10,jungle.display.y + camp.shift.y - 3,camp.drawColor)
							end
						end
						monsterCount = monsterCount + 1
					end
				end
			end
		end
		
		function JungleDisplayOnCreateObj(object)
			if object ~= nil then
				jungle.addCampAndCreep(object)
			end
		end
		
		function JungleDisplayOnWndMsg(msg,key)
			if msg == WM_LBUTTONDOWN and IsKeyDown(16) then
				for i,monster in pairs(jungle.monsters[mapName]) do
					if monster.isSeen == true then
						if monster.iconUnder then
							monster.advise = not monster.advise
							break
						else
							for j,camp in pairs(monster.camps) do
								if camp.textUnder then
									if camp.respawnText ~= nil then SendChat(""..camp.respawnText) end
									break
								end
							end
						end
					end
				end
			end
		end
		
		function JungleDisplayOnDeleteObj(object)
			if object ~= nil then
				jungle.removeCreep(object)
			end
		end
		
		function JungleDisplayOnTick()
			if GetGame().isOver then return end
			-- walkaround OnWndMsg bug
			jungle.shiftKeyPressed = IsKeyDown(16)
			if jungle.useMiniMapVersion == false and jungle.display.moveUnder and IsKeyDown(1) then
				jungle.display.move = true
			elseif jungle.useMiniMapVersion == false and jungle.display.move and IsKeyDown(1) == false then
				jungle.display.move = false
				jungle.display.moveUnder = false
				jungle.display.cursorShift = nil
				jungle.writeConfigs()
			elseif jungle.useMiniMapVersion == false and jungle.display.rotateUnder and IsKeyDown(1) then
				jungle.display.rotation = (jungle.display.rotation == 3 and 0 or jungle.display.rotation + 1)
				jungle.writeConfigs()
			end
			local tick = GetTickCount()
			local monsterCount = 0
			for i,monster in pairs(jungle.monsters[mapName]) do
				for j,camp in pairs(monster.camps) do
					local campStatus = 0
					for k,creepPack in ipairs(camp.creeps) do
						for l,creep in ipairs(creepPack) do
							if creep.object ~= nil and creep.object.dead == false then
								if l == 1 then
									campStatus = 1
								elseif campStatus ~= 1 then
									campStatus = 2
								end
							end
						end
					end
					--[[  Not used until camp.showOnMinimap work
					if (camp.object and camp.object.showOnMinimap == 1) then
						-- camp is here
						if campStatus == 0 then campStatus = 3 end
					elseif camp.status == 3 then 						-- empty not seen when killed
						campStatus = 5
					elseif campStatus == 0 and (camp.status == 1 or camp.status == 2) then
						campStatus = 4
						camp.deathTick = tick
					end
					]]
					-- temp fix until camp.showOnMinimap work
					-- not so good
					if jungle.useMiniMapVersion and camp.object ~= nil then camp.minimap = GetMinimap(camp.object) end
					if camp.object ~= nil and campStatus == 0 then
						if (camp.status == 1 or camp.status == 2) then
							campStatus = 4
							camp.deathTick = tick
							camp.advisedBefore = false
							camp.advised = false
							camp.respawnTime = math.ceil((tick - startTick) / 1000) + monster.respawn
							camp.respawnText = (camp.enemyTeam and "Enemy " or "")..monster.name.." respawn at "..TimerText(camp.respawnTime)
						elseif (camp.status == 4) then
							campStatus = 4
						else
							campStatus = 3
						end
					end
					if jungle.useMiniMapVersion == false and campStatus ~= 0 then
						if jungle.display.rotation == 0 then
							camp.shift = { x = monsterCount * jungle.display.size, y = (camp.enemyTeam and jungle.display.size + 26 or jungle.display.size + 6), }
						elseif jungle.display.rotation == 1 then
							camp.shift = { x = jungle.display.size + 6, y = (monsterCount * jungle.display.size) + (camp.enemyTeam and 32 or 12 ), }
						elseif jungle.display.rotation == 2 then
							camp.shift = { x = monsterCount * jungle.display.size, y = (camp.enemyTeam and -(jungle.display.size - 24) or -(jungle.display.size - 44)), }
						elseif jungle.display.rotation == 3 then
							camp.shift = { x = -(jungle.display.size + 6), y = (monsterCount * jungle.display.size) + (camp.enemyTeam and 32 or 12 ), }
						end
					end
					if camp.status ~= campStatus or campStatus == 4 then
						if campStatus ~= 0 then
							if monster.isSeen == false then monster.isSeen = true end
							camp.status = campStatus
						end
						if camp.status == 1 then				-- ready
							camp.drawText = "ready"
							camp.drawColor = 0xFF00FF00
						elseif camp.status == 2 then			-- ready, master creeps dead
							camp.drawText = "stolen"
							camp.drawColor = 0xFFFF0000
						elseif camp.status == 3 then			-- ready, not creeps shown
							camp.drawText = "   ?"
							camp.drawColor = 0xFF00FF00			
						elseif camp.status == 4 then			-- empty from creeps kill
							local secondLeft = jungle.timerSecondLeft(tick, monster.respawn, camp.deathTick)
							if monster.advise == true and (jungle.adviceEnemyMonsters == true or camp.enemyTeam == false) then
								if secondLeft == 0 and camp.advised == false then
									camp.advised = true
									if jungle.textOnRespawn then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.." has respawned</font>") end
									-- if jungle.pingOnRespawn then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
								elseif secondLeft <= jungle.adviceBefore and camp.advisedBefore == false then
									camp.advisedBefore = true
									if jungle.textOnRespawnBefore then PrintChat("<font color='#00FFCC'>"..(camp.enemyTeam and "Enemy " or "")..monster.name.." will respawn in "..secondLeft.." sec</font>") end
									-- if jungle.pingOnRespawnBefore then PingSignal(PING_FALLBACK,camp.object.x,camp.object.y,camp.object.z,2) end
								end
							end
							-- temp fix until camp.showOnMinimap work
							if secondLeft == 0 then
								camp.status = 0
							end
							camp.drawText = " "..TimerText(secondLeft)
							camp.drawColor = 0xFFFFFF00
						elseif camp.status == 5 then			-- camp found empty (not using yet)
							camp.drawText = "   -"
							camp.drawColor = 0xFFFF0000
						end
					end
					if jungle.shiftKeyPressed and camp.status == 4 then
						camp.drawText = " "..(camp.respawnTime ~= nil and TimerText(camp.respawnTime) or "")
						if jungle.useMiniMapVersion then 
							camp.textUnder = (CursorIsUnder(camp.minimap.x - 9, camp.minimap.y - 5, 20, 8))
						else
							camp.textUnder = (jungle.display.move == false and jungle.display.moveUnder == false and jungle.display.rotateUnder == false and CursorIsUnder(jungle.display.x + camp.shift.x, jungle.display.y + camp.shift.y, jungle.display.size, 16))
						end
					else
						camp.textUnder = false
					end
				end
					-- update monster pos
				if monster.isSeen == true and jungle.useMiniMapVersion == false then
					if jungle.display.rotation == 0 or jungle.display.rotation == 2 then
						monster.shift = { x = monsterCount * jungle.display.size, y = 0, }
					else
						monster.shift = { x = 0, y = monsterCount * jungle.display.size, }
					end
					monster.iconUnder = (jungle.shiftKeyPressed and jungle.display.move == false and jungle.display.moveUnder == false and jungle.display.rotateUnder == false and CursorIsUnder(jungle.display.x + monster.shift.x, jungle.display.y + monster.shift.y, jungle.display.size, jungle.display.size))
					monsterCount = monsterCount + 1
				end
			end
			-- update icon mouse
			if jungle.useMiniMapVersion == false then
				if jungle.display.move == true then
					if jungle.display.cursorShift == nil or jungle.display.cursorShift.x == nil or jungle.display.cursorShift.y == nil then
						jungle.display.cursorShift = { x = GetCursorPos().x - jungle.display.x, y = GetCursorPos().y - jungle.display.y, }
					else
						jungle.display.x = GetCursorPos().x - jungle.display.cursorShift.x
						jungle.display.y = GetCursorPos().y - jungle.display.cursorShift.y
					end
				else
					jungle.display.moveUnder = (jungle.shiftKeyPressed and CursorIsUnder(jungle.display.x, jungle.display.y, 16, 16))
					jungle.display.rotateUnder = (jungle.shiftKeyPressed and CursorIsUnder(jungle.display.x + 16, jungle.display.y, 16, 16))
				end
			end
		end
	end
end

-- ############################################# JUNGLEDISPLAY ################################################

-- ############################################# ENEMY RANGE ################################################

-- Simple Player and Enemy Range Circles
-- by heist
-- v1.0
-- Initial release
-- v1.0.1
-- Adjusted AA range to be more accurate
-- Adopted to studio by Mistal

champAux = {}
champ = {
	Ahri = { 880, 975 },
	Akali = { 800, 0 },
	Alistar = { 650, 0 },
	Amumu = { 0, 600 },
	Anivia = { 650, 1100 },
	Annie = { 625, 0 },
	Ashe = { 1200, 0 },
	Blitzcrank = { 1000, 0 },
	Brand = { 900, 0 },
	Caitlyn = { 1300, 0 },
	Cassiopeia = { 700, 850 },
	Chogath = { 950, 700 },
	Corki = { 1200, 0 },
	Darius = {550, 475}, -- his E and R
	Diana = {830, 900}, -- Q and R
	Draven = {550, 0 }, -- his Ulti is global, his normal range is 550
	DrMundo = { 1000, 0 },
	Evelynn = { 325, 0 },
	Ezreal = { 1000, 0 },
	Fiddlesticks = { 475, 575 },
	Fiora = { 600, 400 },
	Fizz = { 550, 1275 },
	Galio = { 1000, 550 },
	Gangplank = { 625, 0 },
	Garen = { 400, 0 },
	Gragas = { 1150, 1050 },
	Graves = { 750, 0 },
	Hecarim = { 325, 0 }, -- Placeholder
	Heimerdinger = { 1000, 0 },
	Irelia = { 650, 425 },
	Janna = { 800, 1700 },
	JarvanIV = { 770, 650 },
	Jax = { 700, 0 },
	Jayce = { 500, 1050 }, -- normal range attack and ulti
	Karma = { 800, 0 },
	Karthus = { 850, 1000 },
	Kassadin = { 700, 650 },
	Katarina = { 700, 0 },
	Kayle = { 650, 0 },
	Kennen = { 1050, 0 },
	KogMaw = { 1000, 0 },
	Leblanc = { 1300, 600 },
	LeeSin = { 1100, 0 },
	Leona = { 1200, 0 },
	Lulu = { 925, 650 },
	Lux = { 1000, 0 },
	Malphite = { 1000, 0 },
	Malzahar = { 700, 0 },
	Maokai = { 650, 0 },
	MasterYi = { 600, 0 },
	MissFortune = { 625, 1400 },
	MonkeyKing = { 625, 325 },
	Mordekaiser = { 700, 1125 },
	Morgana = { 1300, 600 },
	Nasus = { 700, 0 },
	Nautilus = { 950, 850 },
	Nidalee = { 1500, 0 },
	Nocturne = { 1200, 465 },
	Nunu = { 550, 0 },
	Olaf = { 1000, 0 },
	Orianna = { 825, 0 },
	Pantheon = { 0, 600 },
	Poppy = { 525, 0 },
	Rammus = { 0, 325 },
	Renekton = { 550, 0 },
	Riven = { 0, 250 },
	Rumble = { 600, 1000 },
	Ryze = { 675, 625 },
	Sejuani = { 700, 1150 },
	Shaco = { 625, 0 },
	Shen = { 0, 600 },
	Shyvana = { 1000, 0 },
	Singed = { 0, 125 },
	Sion = { 550, 0 },
	Sivir = { 1100, 0 },
	Skarner = { 600, 350 },
	Sona = { 0, 1000 },
	Soraka = { 0, 725 },
	Swain = { 900, 0 },
	Syndra = { 550, 0 },
	Talon = { 700, 0 },
	Taric = { 0, 625 },
	Teemo = { 680, 0 },
	Tristana = { 900, 700 },
	Trundle = { 0, 1000 },
	Tryndamere = { 660, 0 },
	TwistedFate = { 1700, 0 },
	Twitch = { 1200, 0 },
	Udyr = { 625, 0 },
	Urgot = { 1000, 0 },
	Varus = { 925, 1075 },
	Vayne = { 0, 450 },
	Veigar = { 650, 0 },
	Viktor = { 600, 0 },
	Vladimir = { 600, 700 },
	Volibear = { 425, 0 },
	Warwick = { 0, 700 },
	Xerath = { 1300, 900 },
	XinZhao = { 650, 0 },
	Yorick = { 600, 0 },
	Ziggs = { 1000, 850 },
	Zilean = { 700, 0 },
	Zyra = { 825, 1100 },
}
champAux = champ
player = GetMyHero()
heroindex, c = {}, 0
for i = 1, heroManager.iCount do
local h = heroManager:getHero(i)
if h.name == player.name or h.team ~= player.team then
heroindex[c+1] = i
c = c+1
end
end

function RangesOnDraw()
for _,v in ipairs(heroindex) do
local h = heroManager:getHero(v)
local t = champAux[h.charName]

if h.visible and not h.dead then
         if h.range > 400 and (t == nil or (h.range + 100 ~= t[1] and h.range + 100 ~= t[2])) then
         DrawCircle(h.x, h.y, h.z,h.range + 100, 0xFF646464)
         end
         if t ~= nil then
         if t[1] > 0 then
                 DrawCircle(h.x, h.y, h.z,t[1], 0xFF006400)
         end
         if t[2] > 0 then
                 DrawCircle(h.x, h.y, h.z,t[2], 0xFF640000)
         end
         end
end
end
end

-- ############################################# ENEMY RANGE ################################################

-- ############################################# WARD PREDICTION RANGE ################################################

--[[
	Ward Prediction 1.0 by eXtragoZ
			
		It uses AllClass
	
	Features:
		- Prints in the chat the amount of wards purchased and used by allies and enemies
		- Indicates the position where may be the ward that use the enemy with circles and says the remaining duration
		- You can remove the marks pressing shift and double click in the circle
]]
--[[		Config		]]
local WardPredictionHK = 16 --shift
--[[		Code		]]
local WardPredictionlastclick = 0
local WardPredictiondeletewards = 0
local WardPredictioncountSightWard,WardPredictionlastcountSightWard,WardPredictioncountVisionWard,WardPredictioncountlastcountVisionWard = {},{},{},{}
local WardPredictionitemslot = {ITEM_1,ITEM_2,ITEM_3,ITEM_4,ITEM_5,ITEM_6}
local WardPredictioncolorteam = "#0095FF"
local WardPredictionunittraveled = {}
local WardPredictionMissTimer = {}
local WardPredictionMissSec = {}
local WardPredictiontick_heros = {}
local WardPredictioncenterpos = {}
local WardPredictionpossibleposlist = {}

function WardPredictionOnLoad()
	for i=1, heroManager.iCount do WardPredictioncountSightWard[i],WardPredictionlastcountSightWard[i],WardPredictioncountVisionWard[i],WardPredictioncountlastcountVisionWard[i] = 0,0,0,0 end
	PrintChat(" >> Ward Prediction 1.0 loaded!")
end
function WardPredictionOnTick()
	for i=1, heroManager.iCount do
		local champion = heroManager:GetHero(i)
		WardPredictioncountSightWard[i] = 0
		WardPredictioncountVisionWard[i] = 0
		for j=1, 6 do
			local item = champion:getItem(WardPredictionitemslot[j])
			if item ~= nil and item.id == 2044 then WardPredictioncountSightWard[i] = WardPredictioncountSightWard[i] + item.stacks end
			if item ~= nil and item.id == 2043 then WardPredictioncountVisionWard[i] = WardPredictioncountVisionWard[i] + item.stacks end
		end
		WardPredictioncolorteam = (champion.team == myHero.team and "#0095FF" or "#FF0000")
		if WardPredictionlastcountSightWard[i] > WardPredictioncountSightWard[i] then
			PrintChat("<font color='"..WardPredictioncolorteam.."'>"..champion.charName.."</font><font color='#EEA111'> used "..WardPredictionlastcountSightWard[i]-WardPredictioncountSightWard[i].." </font><font color='#199C33'>Sight Ward</font>")
			if WardPredictionunittraveled[i] ~= nil and champion.team ~= myHero.team then
				table.insert(WardPredictionpossibleposlist, {x = (WardPredictioncenterpos[i].x+champion.x)/2, y = (WardPredictioncenterpos[i].y+champion.y)/2, z = (WardPredictioncenterpos[i].z+champion.z)/2, wardtime = GetTickCount()+180000, warddistance = WardPredictionunittraveled[i]/2+680})
			end
		end
		if WardPredictionlastcountSightWard[i] < WardPredictioncountSightWard[i] then
			PrintChat("<font color='"..WardPredictioncolorteam.."'>"..champion.charName.."</font><font color='#FFFC00'> buy "..WardPredictioncountSightWard[i]-WardPredictionlastcountSightWard[i].." </font><font color='#199C33'>Sight Ward</font>")
		end
		if WardPredictioncountlastcountVisionWard[i] > WardPredictioncountVisionWard[i] then
			PrintChat("<font color='"..WardPredictioncolorteam.."'>"..champion.charName.."</font><font color='#EEA111'> used "..WardPredictioncountlastcountVisionWard[i]-WardPredictioncountVisionWard[i].." </font><font color='#C000FF'>Vision Ward</font>")
			if WardPredictionunittraveled[i] ~= nil and champion.team ~= myHero.team then
				table.insert(WardPredictionpossibleposlist, {x = (WardPredictioncenterpos[i].x+champion.x)/2, y = (WardPredictioncenterpos[i].y+champion.y)/2, z = (WardPredictioncenterpos[i].z+champion.z)/2, wardtime = GetTickCount()+180000, warddistance = WardPredictionunittraveled[i]/2+680})
			end
		end
		if WardPredictioncountlastcountVisionWard[i] < WardPredictioncountVisionWard[i] then
			PrintChat("<font color='"..WardPredictioncolorteam.."'>"..champion.charName.."</font><font color='#FFFC00'> buy "..WardPredictioncountVisionWard[i]-WardPredictioncountlastcountVisionWard[i].." </font><font color='#C000FF'>Vision Ward</font>")
		end
		WardPredictionlastcountSightWard[i] = WardPredictioncountSightWard[i]
		WardPredictioncountlastcountVisionWard[i] = WardPredictioncountVisionWard[i]
	end
	for i,object in ipairs(WardPredictionpossibleposlist) do
		if GetTickCount() > object.wardtime then
			table.remove(WardPredictionpossibleposlist,i)
		elseif GetTickCount()-WardPredictiondeletewards <= 50 then
			if GetDistance(object,mousePos)<=object.warddistance then
				table.remove(WardPredictionpossibleposlist,i)
			end
		end
	end
	for i=1, heroManager.iCount do
		local heros = heroManager:GetHero(i)
		if heros.team ~= myHero.team and not heros.visible and not heros.dead then
			if WardPredictiontick_heros[i] == nil then WardPredictiontick_heros[i] = GetTickCount() end
			WardPredictionMissTimer[i] = GetTickCount() - WardPredictiontick_heros[i]			
			WardPredictionMissSec[i] =  WardPredictionMissTimer[i]/1000
			WardPredictionunittraveled[i] = heros.ms*WardPredictionMissSec[i]
		else
			WardPredictiontick_heros[i] = nil
			WardPredictionMissTimer[i] = nil
			WardPredictionMissSec[i] = 0
			WardPredictionunittraveled[i] = 0
		end
		WardPredictioncenterpos[i] = {x = heros.x, y = heros.y, z = heros.z}
	end
end

function WardPredictionOnDraw()
	local order = 0
	for i,object in ipairs(WardPredictionpossibleposlist) do
		if object.warddistance <= 10000 then
			DrawCircle(object.x, object.y, object.z, object.warddistance, 0xFF11FF)
		end
		if GetDistance(object,mousePos)<=object.warddistance then
			local cursor = GetCursorPos()
			DrawText("Possible ward "..timerText((object.wardtime-GetTickCount())/1000),16, cursor.x, cursor.y + 50+15*order, RGBA(255,100,0,255))
			order = order+1
		end
	end
end

function WardPredictionOnWndMsg(msg,key)
	if IsKeyDown(WardPredictionHK) then
		if msg == WM_LBUTTONUP then
			if GetTickCount()-WardPredictionlastclick <= 200 then
				WardPredictiondeletewards = GetTickCount()
			end
			WardPredictionlastclick = GetTickCount()
		end
	end
end

-- ############################################# WARD PREDICTION RANGE ################################################


-- ############################################ Where did he go? #########################################
--[[#####   Where did he go? v0.4 by ViceVersa   #####]]--
--[[Draws a line to the location where enemys blink or flash to.]]

--Vars
local blink = {} --Blink Ability Array
local vayneUltEndTick = 0
local shacoIndex = 0


--Functions
function FindNearestNonWall(x0, y0, z0, maxRadius, precision) --returns the nearest non-wall-position of the given position(Credits to gReY)
    
    --Convert to vector
    local vec = D3DXVECTOR3(x0, y0, z0)
    
    --If the given position it a non-wall-position return it
    if not IsWall(vec) then return vec end
    
    --Optional arguments
    precision = precision or 50
    maxRadius = maxRadius and math.floor(maxRadius / precision) or math.huge
    
    --Round x, z
    x0, z0 = math.round(x0 / precision) * precision, math.round(z0 / precision) * precision

    --Init vars
    local radius = 1
    
    --Check if the given position is a non-wall position
    local function checkP(x, y) 
        vec.x, vec.z = x0 + x * precision, z0 + y * precision 
        return not IsWall(vec) 
    end
    
    --Loop through incremented radius until a non-wall-position is found or maxRadius is reached
    while radius <= maxRadius do
        --A lot of crazy math (ask gReY if you don't understand it. I don't)
        if checkP(0, radius) or checkP(radius, 0) or checkP(0, -radius) or checkP(-radius, 0) then 
            return vec 
        end
        local f, x, y = 1 - radius, 0, radius
        while x < y - 1 do
            x = x + 1
            if f < 0 then 
                f = f + 1 + 2 * x
            else 
                y, f = y - 1, f + 1 + 2 * (x - y)
            end
            if checkP(x, y) or checkP(-x, y) or checkP(x, -y) or checkP(-x, -y) or 
               checkP(y, x) or checkP(-y, x) or checkP(y, -x) or checkP(-y, -x) then 
                return vec 
            end
        end
        --Increment radius every iteration
        radius = radius + 1
    end
end
    
    
--Callbacks
function WDHGOnLoad() --Called one time on load
    
    --Fill the Blink Ability Array
    for i, heroObj in pairs(GetEnemyHeroes()) do
        
        --If the object exists and the player is in the enemy team
        if heroObj and heroObj.valid then
            
            --Summoner Flash
            if heroObj:GetSpellData(SUMMONER_1).name:find("Flash") or heroObj:GetSpellData(SUMMONER_2).name:find("Flash") then
                table.insert(blink,{name = "SummonerFlash"..heroObj.charName, maxRange = 400, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "Flash"})
            end
            
            --Ezreal E
            if heroObj.charName == "Ezreal" then
                table.insert(blink,{name = "EzrealArcaneShift", maxRange = 475, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "E"})
            
            --Fiora R
            elseif heroObj.charName == "Fiora" then
                table.insert(blink,{name = "FioraDance", maxRange = 700, delay = 1, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "R", target = {}, targetDead = false})
            
            --Kassadin R
            elseif heroObj.charName == "Kassadin" then
                table.insert(blink,{name = "RiftWalk", maxRange = 700, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "R"})
            
            --Katarina E
            elseif heroObj.charName == "Katarina" then
                table.insert(blink,{name = "KatarinaE", maxRange = 700, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "E"})
            
            --Leblanc W
            elseif heroObj.charName == "Leblanc" then
                table.insert(blink,{name = "LeblancSlide", maxRange = 600, delay = 0.5, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "W"})
                table.insert(blink,{name = "leblancslidereturn", delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "W"})
                table.insert(blink,{name = "LeblancSlideM", maxRange = 600, delay = 0.5, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "W"})
                table.insert(blink,{name = "leblancslidereturnm", delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "W"})
            
            --[[Lissandra E (wip)(ToDo: Draw where she blinks to only when she does)
            elseif heroObj.charName == "Lissandra" then
                table.insert(blink,{name= "LissandraE", maxRange = 700, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "E"})]]
            
            --Master Yi Q
            elseif heroObj.charName == "MasterYi" then
                table.insert(blink,{name = "AlphaStrike", maxRange = 600, delay = 0.9, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "Q", target = {}, targetDead = false})
            
            --Shaco Q
            elseif heroObj.charName == "Shaco" then
                table.insert(blink,{name = "Deceive", maxRange = 400, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "Q", outOfBush = false})
                shacoIndex = #blink --Save the position of shacos Q

            --Talon E
            elseif heroObj.charName == "Talon" then
                table.insert(blink,{name = "TalonCutthroat", maxRange = 700, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "E"})
            
            --Vayne Q
            elseif heroObj.charName == "Vayne" then
                table.insert(blink,{name = "VayneTumble", maxRange = 250, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "Q"})
                vayneUltEndTick = 1 --Start to check for Vayne's ult
            
            --[[Zed W (wip)(ToDo: Draw where he blinks when he swaps place with shadow)
            elseif heroObj.charName == "Zed" then
                table.insert(blink,{name= "ZedShadowDash", maxRange = 999, delay = 0, casted = false, timeCasted = 0, startPos = {}, endPos = {}, castingHero = heroObj, shortName = "W"})]]
            
            end
            
        end
    end
    
    --If something was added to the array
    if #blink > 0 then

        --Shift-Menu
        WDHGConfig = scriptConfig("Where did he go?","whereDidHeGo")
        WDHGConfig:addParam("wallPrediction",     "Use Wall Prediction",      SCRIPT_PARAM_ONOFF, false)
        WDHGConfig:addParam("displayTime",        "Display time (No Vision)", SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
        WDHGConfig:addParam("displayTimeVisible", "Display time (Vision)",    SCRIPT_PARAM_SLICE, 1, 0.5, 3, 1)
        WDHGConfig:addParam("lineColor",          "Line Color",               SCRIPT_PARAM_COLOR, {255,255,255,0})
        WDHGConfig:addParam("lineWidth",          "Line Width",               SCRIPT_PARAM_SLICE, 3, 1, 5, 0)
        WDHGConfig:addParam("circleColor",        "Circle Color",             SCRIPT_PARAM_COLOR, {255,255,25,0})
        WDHGConfig:addParam("circleSize",         "Circle Size",              SCRIPT_PARAM_SLICE, 100, 50, 300, 0)
    
        --Print Load-Message
        --if #blink > 1 then
            --print('<font color="#A0FF00">Where did he go? >> v0.4 loaded! (Found '..#blink..' abilitys)</font>')
        --else
            --print('<font color="#A0FF00">Where did he go? >> v0.4 loaded! (Found 1 ability)</font>')
        --end
        
    --else
        --Print Notice
        --print('<font color="#FFFF55">Where did he go? >> No characters with blink abilitys or flash found!</font>')
    end
    
end

function WDHGOnProcessSpell(unit, spell)--When a spell is casted
    
    --If the casting unit is in the enemy team and if it is a champion-ability
    if unit and unit.valid and unit.team == TEAM_ENEMY and unit.type == "obj_AI_Hero" then
        
        --If the spell is Vayne's R
        if vayneUltEndTick > 0 and spell.name == "vayneinquisition" then
            vayneUltEndTick = os.clock() + 6 + 2*spell.level
            return --skip the array
        end
        
        --For each skillshot in the array
        for i=1, #blink, 1 do
            
            --If the casted spell is in the array
            if spell.name == blink[i].name or spell.name..unit.charName == blink[i].name then                
                
                --local function to set the normal end position
                local function SetNormalEndPosition(i, spell)
                    --If the position the enemy clicked is inside the range of the ability set the end position to that position
                    if GetDistance(spell.startPos, spell.endPos) <= blink[i].maxRange then
                        --Set the end position
                        blink[i].endPos = { x = spell.endPos.x, y = spell.endPos.y, z = spell.endPos.z }
                    
                    --Else Calculate the true position if the enemy clicked outside of the ability range
                    else
                        local vStartPos = Vector(spell.startPos.x, spell.startPos.y, spell.startPos.z)
                        local vEndPos = Vector(spell.endPos.x, spell.endPos.y, spell.endPos.z)
                        local tEndPos = vStartPos - (vStartPos - vEndPos):normalized() * blink[i].maxRange
                        
                        --If enabled, Check if the position is in a wall and return the position where the player was really flashed to
                        if WDHGConfig.wallPrediction then
                            tEndPos = FindNearestNonWall(tEndPos.x, tEndPos.y, tEndPos.z, 1000)
                        end
                        
                        --Set the end position
                        blink[i].endPos = { x = tEndPos.x, y = tEndPos.y, z = tEndPos.z }
                    
                    end
                end
                
                --##### Champion-Specific-Stuff #####--
                --#Vayne#
                --Exit if the spell is Vayne's Q and her ult isn't running
                if blink[i].name == "VayneTumble" and os.clock() >= vayneUltEndTick then return end
                
                --#Shaco#
                --Set outOfBush to false if the spell can be tracked
                if blink[i].name == "Deceive" then
                    blink[i].outOfBush = false
                end
                
                --#Leblanc#
                --If the spell is a mirrored W
                if blink[i].name == "LeblancSlideM" then
                    
                    --Cancel the normal W
                    blink[i-2].casted = false
                    
                    --Set the start position to the start position of the first W
                    blink[i].startPos = { x = blink[i-2].startPos.x, y = blink[i-2].startPos.y, z = blink[i-2].startPos.z }
                    
                    --Set the normal end position
                    SetNormalEndPosition(i, spell)
                
                --If the spell is one of Leblanc's returns
                elseif blink[i].name == "leblancslidereturn" or blink[i].name == "leblancslidereturnm" then
                    
                    --Cancel the other W-spells if she returns
                    if blink[i].name == "leblancslidereturn" then
                        blink[i-1].casted = false
                        blink[i+1].casted = false
                        blink[i+2].casted = false
                    else
                        blink[i-3].casted = false
                        blink[i-2].casted = false
                        blink[i-1].casted = false
                    end
                    
                    --Set the normal start position
                    blink[i].startPos = { x = spell.startPos.x, y = spell.startPos.y, z = spell.startPos.z }
                    
                    --Set the end position to the start position of her last slide
                    blink[i].endPos = { x = blink[i-1].startPos.x, y = blink[i-1].startPos.y, z = blink[i-1].startPos.z }
                
                --#Fiora# / #MasterYi#
                elseif blink[i].name == "FioraDance" or blink[i].name == "AlphaStrike" then
                    
                    --Set the target minion
                    blink[i].target = spell.target
                    
                    --Set targetDead to false
                    blink[i].targetDead = false
                    
                    --Set the normal start position
                    blink[i].startPos = { x = spell.startPos.x, y = spell.startPos.y, z = spell.startPos.z }
                    
                    --Set the end position to the position of the targeted unit
                    blink[i].endPos = { x = blink[i].target.x, y = blink[i].target.y, z = blink[i].target.z }
                    
                    
                --##### End of Champion-Specific-Stuff #####--
                                
                --Else set the normal positions
                else
                    
                    --Set the start position
                    blink[i].startPos = { x = spell.startPos.x, y = spell.startPos.y, z = spell.startPos.z }
                    
                    --Set the end position
                    SetNormalEndPosition(i, spell)

                end
                
                --Set casted to true
                blink[i].casted = true
                
                --Set the time when the ability is casted
                blink[i].timeCasted = os.clock()
                                
                --Exit loop
                break
                
            end
            
        end
    end
end

function WDHGOnCreateObj(obj)
    if shacoIndex ~= 0 and obj and obj.valid and obj.name == "JackintheboxPoof2.troy" and not blink[shacoIndex].casted then
        --Set the start and end position of shacos Q to the position of the obj
        blink[shacoIndex].startPos = { x = obj.x, y = obj.y, z = obj.z }
        blink[shacoIndex].endPos = { x = obj.x, y = obj.y, z = obj.z }
        
        --Set casted to true
        blink[shacoIndex].casted = true
        
        --Set the time when the ability is casted
        blink[shacoIndex].timeCasted = os.clock()
        
        --Set outOfBush to true to draw the circle instead the line
        blink[shacoIndex].outOfBush = true
    end
end

function WDHGOnTick()
    --Loop through all abilitys
    for i=1, #blink, 1 do
        
        --If the ability was casted
        if blink[i].casted then
            
            --If the enemy is Fiora or Master Yi and the target is not dead
            if blink[i].name == "FioraDance" or blink[i].name == "AlphaStrike" and not blink[i].targetDead then
                if os.clock() > (blink[i].timeCasted + blink[i].delay + 0.2) then
                    blink[i].casted = false
                elseif blink[i].target.dead then
                    --Save startPos in a temp var
                    local tempPos = { x = blink[i].endPos.x, y = blink[i].endPos.y, z = blink[i].endPos.z }
                    --Set the end position to the start position
                    blink[i].endPos = { x = blink[i].startPos.x, y = blink[i].startPos.y, z = blink[i].startPos.z }
                    --Set the start position to the enemy position
                    blink[i].startPos = { x = tempPos.x, y = tempPos.y, z = tempPos.z }
                    --Set targetDead to true
                    blink[i].targetDead = true
                else
                    --Set the end position the the target unit
                    blink[i].endPos = { x = blink[i].target.x, y = blink[i].target.y, z = blink[i].target.z }
                end
            
            --If the champ is dead or display time is over stop the drawing
            elseif blink[i].castingHero.dead or (not blink[i].castingHero.visible and os.clock() > (blink[i].timeCasted + WDHGConfig.displayTime + blink[i].delay)) or (blink[i].castingHero.visible and os.clock() > (blink[i].timeCasted + WDHGConfig.displayTimeVisible + blink[i].delay)) then
                blink[i].casted = false
                
            --If the enemy is visible after the delay set the target to his position
            elseif not blink[i].outOfBush and blink[i].castingHero.visible and os.clock() > blink[i].timeCasted + blink[i].delay then
                --Set the end position the the current position of the enemy
                blink[i].endPos = { x = blink[i].castingHero.x, y = blink[i].castingHero.y, z = blink[i].castingHero.z }
                
            end
        end
    end
end

function WDHGOnDraw()
    --For each ability in the array
    for i=1, #blink, 1 do
        
        --If the ability is casted
        if blink[i].casted then
            
            --Convert 3D-coordinates to 2D-coordinates for DrawLine and InfoText
            local lineStartPos = WorldToScreen(D3DXVECTOR3(blink[i].startPos.x, blink[i].startPos.y, blink[i].startPos.z))
            local lineEndPos = WorldToScreen(D3DXVECTOR3(blink[i].endPos.x, blink[i].endPos.y, blink[i].endPos.z))            
            
            --If the ability is shacos Q out of a bush draw only a circle
            if blink[i].outOfBush then
                --Draw a circle showing the possible target
                for j=0, 3, 1 do
                    DrawCircle(blink[i].endPos.x , blink[i].endPos.y , blink[i].endPos.z, blink[i].maxRange+j*2, ARGB(255, 255, 25, 0))
                end
            
            --Else draw the normal circle with a line
            else
                --Draw Circle at target position
                for j=0, 3, 1 do
                    DrawCircle(blink[i].endPos.x , blink[i].endPos.y , blink[i].endPos.z , WDHGConfig.circleSize+j*2, RGB(WDHGConfig.circleColor[2],WDHGConfig.circleColor[3],WDHGConfig.circleColor[4]))
                end
                                
                --Draw Line beetween the start and target position
                DrawLine(lineStartPos.x, lineStartPos.y, lineEndPos.x, lineEndPos.y, WDHGConfig.lineWidth, RGB(WDHGConfig.lineColor[2],WDHGConfig.lineColor[3],WDHGConfig.lineColor[4]))
            end
            
            --Draw the info text (Credits to Weee :3)
            local offset = 30
            local infoText = blink[i].castingHero.charName .. " " .. blink[i].shortName
            DrawLine(lineEndPos.x, lineEndPos.y, lineEndPos.x + offset, lineEndPos.y - offset, 1, ARGB(255,255,255,255))
            DrawLine(lineEndPos.x + offset, lineEndPos.y - offset, lineEndPos.x + offset + 6 * infoText:len(), lineEndPos.y - offset, 1, ARGB(255,255,255,255))
            DrawTextA(infoText, 12, lineEndPos.x + offset + 1, lineEndPos.y - offset, ARGB(255,255,255,255), "left", "bottom")

        end
    end
end

--[[  Config  ]]
local exhaustLimit = 0.25
     
--[[  Globals  ]]
local player = GetMyHero()
local sums = {player:GetSpellData(SUMMONER_1).name, player:GetSpellData(SUMMONER_2).name}

--[[ 		Globals		]]
local abilitySequence
local qOff, wOff, eOff, rOff = 0,0,0,0


function ConsoleOnLoad()
    --[[
        Console Version 1.0
        
        @author frd
        @author Husky
        
        This script is to help seperate script errors from chat and provide
        a nice interface for viewing errors and script notifications.
        
        The other big benefit of this script is for in-game debugging with ability
        to execute Lua and view environment variables directly in the console.
        
        One of the features we wrote that we weren't sure were going to be used
        is the ability to create binds. This is something we want to get feedback
        on from the community and we can expand it from there.
        
        Examples:
        bind j say going b; recall
        bind k cast q; recall -- Stealth recall for Shaco?
        
        Please use your imagination and give us ideas and extra commands you
        might want to see.
        
        Current Commands:
            clear -- Clear console
            say -- Message team
            say_all -- Message all
            buy -- Buy an item, eg: buy 1001 (buy boots)
            cast -- Cast a spell eg: cast q (options: q, w, e, r, summoner1, summoner2, flash)
            flash -- Flash
            recall -- Recall
            bind -- Bind a key eg: bind k say hello
            unbind -- Unbind a key eg: unbind k
            unbindall -- Unbind all keys
            
        Binds are automatically saved and loaded.
        
        To open the console press the tilt. (`)
        German keyboards can use the (^) under the esc key.
        ========================================================================
        Current Console Commands:

        The following non-lua commands are available in the console:

        clear -- Clears console
        say -- Message team
        say_all -- Message all
        buy -- Buy an item, eg: buy 1001 (buy boots)
        cast -- Cast a spell eg: cast q (options: q, w, e, r, summoner1, summoner2, flash)
        flash -- Flash
        recall -- Recall
        bind -- Bind a key eg: bind k say hello
        unbind -- Unbind a key eg: unbind k
        unbindall -- Unbind all keys


        Binds are automatically saved and loaded.

        How to use it:

        To open the console press the tilt. (`)
        German keyboards can use the (^) under the esc key.

        The following examples show a few binds that can be done with the console:

        -- Stealth recall for shaco
        bind s cast q;cast recall

        -- Notifying teammates about recalling
        bind b cast recall;say brb - base
        
    ]]

    -- Console Configuration
    local console = {
        bgcolor = RGBA( 0, 0, 0, 170 ),
        padding = 10,
        textSize = 16,
        height = WINDOW_H / 2,
        width = WINDOW_W,
        linePadding = 2,
        brand = "Bot of Legends - Console Version 1.0",
        scrolling = {
            width   = 12
        },
        colors = {
            script = { R =   0, G = 255, B = 0 },
            console = { R = 255, G = 255, B = 0 },
            command = { R = 150, G = 255, B = 0 },
            prompt = { R =   0, G = 255, B = 0 },
            default = { R =  0, G = 255, B = 0 }
        },
        keys = {
            220 --, -- German Tilt = "|, \" key in english
            --192 -- English Tilt
        },
        selection = {
            content = "",
            startLine = 1,
            endLine = 1,
            startPosition = 1,
            endPosition = 1
        }
    }

    -- Notifications Configuration
    local notifications = {
        bgcolor = RGBA( 0, 0, 0, 80 ),
        max = 6,
        length = 5000,
        fadeTime = 500,
        slideTime = 200,
        perma = 0
    }

    -- Binds
    local binds = {}

    -- Command line structure
    local command = {
        bullet = ">",
        history = {},
        offset = 1,
        buffer = "",
        methods = {
            -- DEFINED at end of script to allow access to all methods
        }
    }

    -- Spell mapping (for cast/level command, etc)
    local spells = {
        q = _Q,
        w = _W,
        e = _E,
        r = _R,
        recall = RECALL,
        summoner1 = SUMMONER_1,
        summoner2 = SUMMONER_2,
        flash = function()
            if myHero:GetSpellData(SUMMONER_1).name:find("SummonerFlash") then return SUMMONER_1
            elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerFlash") then return SUMMONER_2
            else return nil end
        end
    }

    -- Cursor structure
    local cursor = {
        blinkSpeed = 1200,
        offset = 0,
    }

    -- Is the console active or not
    local active = false

    -- The stack of console messages
    local stack = {}
    local offset = 1

    -- Last notification time
    local closeTick = 0

    -- Unorganized variables
    local stayAtBottom = true

    -- Calculated max console messages to display on a single screen
    local maxMessages = math.floor((console.height - 2 * console.padding - 2 * console.textSize) / (console.textSize + console.linePadding)) + 1

    -- Code ------------------------------------------------
    local function LoadBinds()
        pcall(function() lines = io.lines(SCRIPT_PATH .. "binds.cfg") end)
        if lines ~= nil then
            for line in lines do
                local parts = string.split(line, " ", 3)
                binds[parts[2]] = parts[3]
            end
        end
    end

    local function SaveBinds()
        local file = assert(io.open(SCRIPT_PATH .. "binds.cfg", "w+"))
        if file then
            for key, cmd in pairs(binds) do
                file:write("bind " .. key .. " " .. cmd .. "\n")
            end
            file:close()
        end
    end

    local function IsConsoleKey(key)
        for i, k in ipairs(console.keys) do
            if k == key then
                return true
            end
        end

        return false
    end

    local function GetTextColor(type, opacity)
        local c = console.colors.default

        if console.colors[type] then
            c = console.colors[type]
        end

        return RGBA(c.R, c.G, c.B, (opacity or 1) * 255)
    end

    local function AddMessage(msg, type, insertionOffset)
        if insertionOffset then
            table.insert(stack, insertionOffset, {
                msg = tostring(msg),
                ticks = GetTickCount(),
                gameTime = GetInGameTimer(),
                type = type
            })
        else
            table.insert(stack, {
                msg = tostring(msg),
                ticks = GetTickCount(),
                gameTime = GetInGameTimer(),
                type = type
            })
        end

        if #stack - offset >= maxMessages and stayAtBottom then
            offset = offset + 1
        end

        if notifications.perma > 0 then
            for i = 1, notifications.perma do
                if #stack - i >= 1 then
                    local item = stack[#stack - i]

                    if item.ticks < GetTickCount() - notifications.length + notifications.fadeTime then
                        item.ticks = GetTickCount() - notifications.length + notifications.fadeTime
                        closeTick = GetTickCount() - notifications.length + notifications.fadeTime - 1
                    end
                end
            end
        end
    end

    local function LazyProcess(cmd)
        local preExecutionStackCount = #stack
        local successful, result = ExecuteLUA('return ' .. cmd)

        if successful then
            successfull, result = pcall(function() return cmd .. " = " .. tostring(result) end)
            if successfull then
                table.remove(stack, preExecutionStackCount)
                AddMessage(result, "command", preExecutionStackCount)
            else
                table.remove(stack, preExecutionStackCount)
                AddMessage(cmd .. " = <unknown>", "command", preExecutionStackCount)
            end     
        else
            AddMessage("Lua Error: " .. result:gsub("%[string \"\"%]:1: ", ""), "console")
        end
    end

    function ExecuteLUA(cmd)
        local func, err = load(cmd, "", "t", _ENV)

        if func then
            return pcall(func)
        else
            return false, err
        end
    end

    local function ProcessCommand(cmd)
        local parts = string.split(cmd, " ", 2)
        if command.methods[parts[1]] == nil then return end
        return command.methods[parts[1]](#parts == 2 and parts[2] or nil)
    end

    local function ExecuteCommand(cmd)
        if cmd ~= "" then
            AddMessage(cmd, "command")

            if string.len(cmd) == 0 then return end

            -- Display command in console, and add to history stack
            table.insert(command.history, cmd)

            -- Parse the command
            local process = ProcessCommand(cmd)

            -- If no command was found, we will attempt to execute the command as LUA code
            if not process then
                LazyProcess(cmd)
            end
        end
    end

    local function GetTextWidth(text, textSize)
        return GetTextArea("_" .. text .. "_", textSize or console.textSize).x - 2 * GetTextArea("_", textSize or console.textSize).x
    end

    local function DrawRectangle(x, y, width, height, color)
        DrawLine(x, y + (height/2), x + width, y + (height/2), height, color)
    end

    function Console__WriteConsole(msg)
        AddMessage(msg, "script")
    end

    function Console__OnLoad()
        AddMessage("Game started", "console")
        AddMessage("Champion: " .. myHero.charName, "console")
        LoadBinds()
    end

    function Console__OnDraw()
        local messageBoxHeight = 2 * console.padding + (maxMessages - 1) * (console.textSize + console.linePadding) + console.textSize
        local promptHeight       = 2 * console.padding + console.textSize
        local consoleHeight     = messageBoxHeight + promptHeight
        local scrollbarHeight   = math.ceil(messageBoxHeight / math.max(#stack / maxMessages, 1))

        if active == true then
            local showRatio = math.min((GetTickCount() - closeTick) / notifications.slideTime, 1)
            local slideOffset = (1 - showRatio) * consoleHeight

            -- Draw console background
            DrawRectangle(0, 0 - slideOffset, console.width, consoleHeight, RGBA(0, 0, 0, showRatio * 170))
            DrawLine(0, messageBoxHeight - slideOffset, console.width, messageBoxHeight - slideOffset, 1, GetTextColor("prompt", showRatio * 0.16))
            DrawLine(0, consoleHeight - slideOffset, console.width, consoleHeight - slideOffset, 1, GetTextColor("prompt", showRatio * 0.58))
            
            -- Display stack of messages
            console.selection.content = ""
            if #stack > 0 then
                for i = offset, offset + maxMessages - 1 do
                    if i > #stack then break end

                    local message = stack[i]

                    local selectionStartLine, selectionEndLine, selectionStartPosition, selectionEndPosition
                    if console.selection.startLine < console.selection.endLine or (console.selection.startLine == console.selection.endLine and console.selection.startPosition < console.selection.endPosition) then
                        selectionStartLine = console.selection.startLine
                        selectionEndLine = console.selection.endLine
                        selectionStartPosition = console.selection.startPosition
                        selectionEndPosition = console.selection.endPosition
                    else
                        selectionStartLine = console.selection.endLine
                        selectionEndLine = console.selection.startLine
                        selectionStartPosition = console.selection.endPosition
                        selectionEndPosition = console.selection.startPosition
                    end

                    if i >= selectionStartLine and i <= selectionEndLine then
                        local rightOffset
                        
                        local leftOffset = (i == selectionStartLine) and (GetTextArea("_" .. ("[" .. TimerText(message.gameTime) .. "] " .. message.msg):sub(1, selectionStartPosition - 1) .. "_", console.textSize).x - 2 * GetTextArea("_", console.textSize).x) or 0

                        if i == selectionEndLine then
                            local selectedText = ("[" .. TimerText(message.gameTime) .. "] " .. message.msg):sub(selectionStartLine == selectionEndLine and selectionStartPosition or 1, selectionEndPosition - 1)
                            rightOffset = GetTextWidth(selectedText)

                            console.selection.content = console.selection.content .. (console.selection.content ~= "" and "\r\n" or "") .. selectedText
                        else
                            local selectedText = ("[" .. TimerText(message.gameTime) .. "] " .. message.msg):sub(selectionStartLine == i and selectionStartPosition or 1)
                            rightOffset = WINDOW_W - 2 * console.padding - leftOffset - (scrollbarHeight == messageBoxHeight and 0 or console.scrolling.width)

                            console.selection.content = console.selection.content .. (console.selection.content ~= "" and "\r\n" or "") .. selectedText
                        end

                        DrawRectangle(console.padding + leftOffset, console.padding + (i - offset) * (console.textSize + console.linePadding) - slideOffset - console.linePadding / 2, rightOffset, console.textSize + console.linePadding, 1157627903)
                    end

                    if message ~= nil then
                        DrawText("[" .. TimerText(message.gameTime) .. "] " .. message.msg, console.textSize, console.padding, console.padding + (i - offset) * (console.textSize + console.linePadding) - slideOffset, GetTextColor(message.type, showRatio))
                    end
                end
            end

            -- Show what user is currently typing
            DrawText(command.bullet .. " " .. command.buffer, console.textSize, console.padding, messageBoxHeight + console.padding - slideOffset, GetTextColor("prompt", showRatio))
            if GetTickCount() % cursor.blinkSpeed > cursor.blinkSpeed / 2 then
                DrawText("_", console.textSize, console.padding + GetTextArea(command.bullet .. " " .. command.buffer:sub(1, cursor.offset) .. "_", console.textSize).x - GetTextArea("_", console.textSize).x, messageBoxHeight + console.padding - slideOffset, GetTextColor("prompt", showRatio))
            end

            DrawText(console.brand, console.textSize, console.width - GetTextArea(console.brand, console.textSize).x - console.padding, messageBoxHeight + console.padding - slideOffset, GetTextColor("prompt", showRatio * 0.58))

            if scrollbarHeight ~= messageBoxHeight then
                DrawRectangle(console.width - console.scrolling.width, 0 - slideOffset + (offset - 1) / (#stack - maxMessages) * (messageBoxHeight - scrollbarHeight), console.scrolling.width, scrollbarHeight, GetTextColor("prompt", showRatio * 0.4))
            end
        elseif #stack > 0 then
            local filteredStack = {}

            for i = #stack, math.max(#stack - notifications.max + 1, 1), - 1 do
                if (GetTickCount() - stack[i].ticks > notifications.length or stack[i].ticks < closeTick) and (#stack - i) >= notifications.perma then break end
                table.insert(filteredStack, stack[i])
            end

            if #filteredStack > 0 then
                local slideOffset = 0
                for i = 1, #filteredStack do
                    slideOffset = slideOffset - (console.textSize + (i == #filteredStack and console.padding * 2 or console.linePadding)) * ((#filteredStack - i < notifications.perma) and 0 or math.max((GetTickCount() - filteredStack[#filteredStack - i + 1].ticks - notifications.length + notifications.fadeTime) / notifications.fadeTime, 0))
                end

                DrawRectangle(0, 0, console.width, (console.textSize * #filteredStack) + (console.padding * 2) + (#filteredStack - 1) * console.linePadding + slideOffset, notifications.bgcolor)
                DrawLine(0, (console.textSize * #filteredStack) + (console.padding * 2) + slideOffset + (#filteredStack - 1) * console.linePadding, console.width, (console.textSize * #filteredStack) + (console.padding * 2) + slideOffset + (#filteredStack - 1) * console.linePadding, 1, GetTextColor("prompt", 0.27))

                for i = 1, #filteredStack do
                    local item = filteredStack[#filteredStack + 1 - i]

                    DrawText("[" .. TimerText(item.gameTime) .. "] " .. item.msg, console.textSize, console.padding, console.padding + (i - 1) * (console.linePadding + console.textSize) + slideOffset, GetTextColor(item.type, 1 - ((#filteredStack - i < notifications.perma) and 0 or math.max((GetTickCount() - item.ticks - notifications.length + notifications.fadeTime) / notifications.fadeTime, 0))) )
                end
            end
        end
    end

    function getLineCoordinates(referencePoint)
        local yValue = math.max(math.ceil((referencePoint.y - console.padding - console.textSize) / (console.textSize + console.linePadding)) + 1, 1) + offset - 1
        local xValue = referencePoint.x - console.padding

        if yValue > #stack then
            return #stack + 1, math.huge
        else
            local stringValue = "[" .. TimerText(stack[yValue].gameTime) .. "] " .. stack[yValue].msg
            local stringWidth = 0
            local charNumber = 0
            for i = 1, #stringValue do
                newStringWidth = stringWidth + GetTextArea("_" .. stringValue:sub(i,i) .. "_", console.textSize).x - 2 * GetTextArea("_", console.textSize).x
                if newStringWidth > xValue then break end
                stringWidth = newStringWidth
                charNumber = i
            end

            return yValue, charNumber + 1
        end
    end

    function Console__OnMsg(msg, key)
        local messageBoxHeight = 2 * console.padding + (maxMessages - 1) * (console.textSize + console.linePadding) + console.textSize
        local promptHeight       = 2 * console.padding + console.textSize
        local consoleHeight     = messageBoxHeight + promptHeight
        local scrollbarHeight   = math.ceil(messageBoxHeight / math.max(#stack / maxMessages, 1))

        if active and msg == WM_RBUTTONUP then
            SetClipboardText(console.selection.content)
            console.selection = {
                content = "",
                startLine = 1,
                endLine = 1,
                startPosition = 1,
                endPosition = 1
            }
        elseif active and msg == WM_LBUTTONDOWN then
            if GetCursorPos().x >= console.width - console.scrolling.width then
                dragConsole = true
                dragStart = {x = GetCursorPos().x, y = GetCursorPos().y}
                startOffset = offset
            else
                local line, char = getLineCoordinates(GetCursorPos())

                if line then
                    console.selection.startLine = line
                    console.selection.endLine = line
                    console.selection.startPosition = char
                    console.selection.endPosition = char

                    selecting = true
                end
            end
        elseif active and msg == WM_LBUTTONUP then
            if selecting then
                local line, char = getLineCoordinates(GetCursorPos())

                if line then
                    console.selection.endLine = line
                    console.selection.endPosition = char
                end
            end

            dragConsole = false
            selecting = false
        elseif active and msg == WM_MOUSEMOVE then
            if selecting then
                local line, char = getLineCoordinates(GetCursorPos())

                if line then
                    console.selection.endLine = line
                    console.selection.endPosition = char
                end
            end

            if dragConsole then
                if #stack > maxMessages then
                    stayAtBottom = false

                    offset = startOffset + math.round(((GetCursorPos().y - dragStart.y) * (#stack - maxMessages) / (messageBoxHeight - scrollbarHeight)) + 1)
                    if offset < 1 then
                        offset = 1
                    elseif offset >= #stack - maxMessages + 1 then
                        offset = #stack - maxMessages + 1
                        stayAtBottom = true
                    end
                end
            end
        end

        if active then
            BlockMsg()
        end

        if active and msg == KEY_DOWN then
            local oldCommandBuffer = command.buffer
        
            if key == 13 then --enter
                ExecuteCommand(command.buffer)
                if #stack > maxMessages then
                    offset = #stack - maxMessages + 1
                end
                command.buffer = ""
                cursor.offset = 0
                stayAtBottom = true
            elseif key == 8 then --backspace
                if cursor.offset > 0 then
                    command.buffer = command.buffer:sub(1, cursor.offset - 1) .. oldCommandBuffer:sub(cursor.offset + 1)
                    cursor.offset = cursor.offset - 1
                end
            elseif key == 46 then -- delete
                command.buffer = command.buffer:sub(1, cursor.offset) .. oldCommandBuffer:sub(cursor.offset + 2)
            elseif key == 33 then --pgup
                offset = math.max(offset - maxMessages, 1)
                stayAtBottom = false
            elseif key == 34 then --pgdn
                offset = math.max(math.min(offset + maxMessages, #stack - maxMessages + 1), 1)
                if offset == #stack - maxMessages + 1 then
                    stayAtBottom = true
                end
            elseif key == 38 and #command.history > 0 then --up arrow
                if command.offset < #command.history then
                    command.offset = command.offset + 1
                end
                command.buffer = command.history[command.offset]
                cursor.offset = #command.buffer
            elseif key == 40 and #command.history > 0 then --down arrow
                if command.offset > 1 then
                    command.offset = command.offset - 1
                end
                command.buffer = command.history[command.offset]
                cursor.offset = #command.buffer
            elseif key == 37 then --left arrow
                cursor.offset = math.max(cursor.offset - 1, 0)
            elseif key == 39 then --right arrow
                cursor.offset = math.min(cursor.offset + 1, #command.buffer)
            elseif key == 35 then
                cursor.offset = #command.buffer
            elseif key == 36 then
                cursor.offset = 0
            elseif ToAscii(key) == string.char(3) then
                SetClipboardText(console.selection.content)
                console.selection = {
                    content = "",
                    startLine = 1,
                    endLine = 1,
                    startPosition = 1,
                    endPosition = 1
                }
            elseif ToAscii(key) == string.char(22) then
                local textToAdd = GetClipboardText():gsub("\r", ""):gsub("\n", " ")
                command.buffer = oldCommandBuffer:sub(1, cursor.offset) .. textToAdd .. oldCommandBuffer:sub(cursor.offset + 1)
                cursor.offset = cursor.offset + #textToAdd
            elseif key == 9 then
                for k,v in pairs(_G) do
                    if k:sub(1, #command.buffer) == command.buffer then
                        command.buffer = k
                        cursor.offset = #k
                        break
                    end
                end
            else
                local asciiChar = ToAscii(key)
                if asciiChar ~= nil then
                    command.buffer = oldCommandBuffer:sub(1, cursor.offset) .. asciiChar .. oldCommandBuffer:sub(cursor.offset + 1)
                    cursor.offset = cursor.offset + 1
                end
            end
        end
        
        if msg == KEY_DOWN and IsConsoleKey(key) then
            active = not active
            command.buffer = ""
            closeTick = GetTickCount()

            if active then
                AllowKeyInput(false)
                AllowCameraInput(false)
            else
                AllowKeyInput(true)
                AllowCameraInput(true)
            end
        end
        
        if msg == KEY_DOWN and binds[ToAscii(key)] and not active then
            local parts = string.split(binds[ToAscii(key)], ";")
            for p, cmd in ipairs(parts) do
                ProcessCommand(cmd)
            end
        end
    end

    -- Console Commands ---------------------------------
    command.methods = {
        clear = function()
            stack = {}
            offset = 1
        end,
        
        say = function(query)
            SendChat(query)
            return true
        end,
        
        say_all = function(query)
            SendChat("/all " .. query)
            return true
        end,
        
        buy = function(query)
            BuyItem(tonumber(query))
            return true
        end,

        cast = function(query)      
            local s = type(spells[query]) == "function" and spells[query]() or spells[query]
            if s then
                local target = GetTarget()
                if target ~= nil then
                    CastSpell(s, target)
                else
                    CastSpell(s, mousePos.x, mousePos.z)
                end
            else
                AddMessage("Attempted to cast invalid spell: \"" .. query .. "\"", "console")
            end
            
            return true
        end,
        
        flash = function() return command.methods.cast("flash") end,
        recall = function() return command.methods.cast("recall") end,
        
        level = function(query)
            local s = type(spells[query]) == "function" and spells[query]() or spells[query]
            if s then
                LevelSpell(s)
            end
            
            return true
        end,
        
        bind = function(query)
            local parts = string.split(query, " ", 2)
            binds[parts[1]] = parts[2]
            SaveBinds()
            return true
        end,
        
        unbind = function(query)
            binds[query] = nil
            SaveBinds()
            return true
        end,
        
        unbindall = function()
            binds = {}
            SaveBinds()
            return true
        end,
        
        reload = function()
            LoadBinds()
            return true
        end
    }

    AddLoadCallback(Console__OnLoad)
    AddDrawCallback(Console__OnDraw)
    AddMsgCallback(Console__OnMsg)
    _G.WriteConsole = Console__WriteConsole
    _G.PrintChat = _G.WriteConsole
    _G.Console__IsOpen = active

end


-- ############################################# Auto Live Saver 2.1 Final ################################################

-- ######################################  LIFE SAVER v2.1 Final  ########################################
-- #################################################################################################
-- ##                                                                                             ##
-- ##                                   Auto Life Saver                                           ##
-- ##                                Version 2.1 final                                            ##
-- ##                                                                                             ##
-- ##                            Written by Wursti                                                ##
-- ##                                                                                             ##
-- #################################################################################################
 
-- #################################################################################################
-- ##                               Main Features & Changelog                                     ##
-- #################################################################################################
-- ## 2.0 - Never really worked as expected so version 2 should fix all :)                        ##
-- ## 2.1 - Added Particle Check (Mainly for HP Pots) :)                                          ##
-- #################################################################################################
 
-- #################################################################################################
-- ## TODO:                                                                                       ##
-- ## - FIX POTION SO NO SpAMMING   (Disabled Potion)                                              ##
-- #################################################################################################
 
-- #################################################################################################
-- ## Please Send me your Feedback so I can improve this Script further :)                        ##
-- #################################################################################################
 
 
local player = GetMyHero()
local nextcheck = GetGameTimer()
local HealthCurrent = 0
local HealthBefore = 0
local NextCheck = GetTickCount()
local HealthProc = 0
ItemBurstCheck = 0
 
function InitCheck()
for i=1, #itemCodes do
CheckPurchase()
end
end
 
function GetItemCodes()
itemCodes = {
                                {name = "Zhonyas Hourglass", id= 3157, perc= 25, dropperc = 20, def = true, check = false, particle = nil},
                                {name = "Wooglet's Witchcap", id= 3090, perc= 25, dropperc = 20, def = true, check = false, particle = nil},
                                {name = "Seraph's Embrace", id= 3040, perc= 25, dropperc = 20, def = true, check = false, particle = nil},
                                --{name = "Health Potion", id= 2003, perc= 25, dropperc = 20, def = true, check = true, particle = "Regenerationpotion_itm.troy"},
                                {name = "Elixir of Fortitude", id= 2037, perc= 20, dropperc = 20, def = true, check = false, particle = nil},
                                -- MANA DOESN'T WORK VERY WELL. TAKEN OUT -- {name = "Mana Potion", id= 2004, perc= 25, dropperc = 20, def = true, check = true, particle = nil}, 
                                -- Works only when health is at the level set
                                -- Auto Potion is not working correctly...
                        }
UsableItems = {}
CheckParticles = {} 
end
 
function LifeSaverOnLoad()
GetItemCodes()
InitCheck()
--PrintChat(">> Auto Live Saver!")
--PrintChat(">> Version 2.1 - One Pot at a Time")
end
 
function Menu(ItemToCheck,ItemName,TheID,pperc,droppperc,ddef,checkk,particlee)
l = ItemToCheck
_G["SConfig"..l] = scriptConfig(ItemName.." Saver","Auto"..l)
--[[PrintChat(ItemName.." found!")]]
_G["SConfig"..l]:addParam("useItem", "Use Item: "..ItemName, SCRIPT_PARAM_ONOFF, ddef)
_G["SConfig"..l]:addParam("Burst", "Use it if drop set % in 1s", SCRIPT_PARAM_SLICE, droppperc, 1, 100, 0)
_G["SConfig"..l]:addParam("minHP", "Total min Percentage to use Item", SCRIPT_PARAM_SLICE, pperc, 1, 100, 0)
table.remove (itemCodes, TheID)
if checkk == true then
        table.insert (UsableItems, {ID = ItemToCheck, NAME = ItemName, MenuID = l, MustCheck = true})
        table.insert (CheckParticles, {ID = ItemToCheck, PARTICLE = particlee})
else
        table.insert (UsableItems, {ID = ItemToCheck, NAME = ItemName, MenuID = l, MustCheck = false})
end
 
end
 
function CheckPurchase()
for i, itemCode in pairs(itemCodes) do
        ThisItemName = itemCode.name
        ThisItemID = itemCode.id
        ThisID = i
        ThisPerc = itemCode.perc
        ThisDropPerc = itemCode.dropperc
        ThisDef = itemCode.def
        ThisCheck = itemCode.check
        ThisParticle = itemCode.particle
        if GetInventoryHaveItem(ThisItemID, player) == true then
                Menu(ThisItemID,ThisItemName,ThisID,ThisPerc,ThisDropPerc,ThisDef,ThisCheck,ThisParticle)
        end
end
end
 
function BBurst(percent,ItemSlot)
        HealthProc = (player.maxHealth*(percent/100))
        HealthCurrent = myHero.health
        if player:CanUseSpell(ItemSlot) then
                if HealthCurrent < (HealthBefore-HealthProc) then
                        if player:CanUseSpell(ItemSlot) then
                                --PrintChat("Cast!")
                                CastSpell(ItemSlot)
                        end
                end
        end
        HealthBefore = myHero.health
end
 
function HPCheck(percent,ItemSlot)
        if player.health < (player.maxHealth*(percent/100)) then
                if player:CanUseSpell(ItemSlot) then
                        CastSpell(ItemSlot)
                end
        end
end
 
function Check()
        for i, ItemReady in pairs(UsableItems) do
                CheckItemId = ItemReady.ID
                CheckItemName = ItemReady.NAME
                kay = ItemReady.MenuID
                Checker = ItemReady.MustCheck
                ActiveCheck = _G["Active"..CheckItemId]
                if GetInventoryHaveItem(CheckItemId, player) and (ActiveCheck == false or ActiveCheck == nil) then
                        ThisScript = (_G["SConfig"..kay])
                        if ThisScript.useItem then
                                HPperc = ThisScript.minHP
                                Burstperc = ThisScript.Burst
                                ItSlot = GetInventorySlotItem(CheckItemId)
                                HPCheck(HPperc,ItSlot)
                                ItemBurstCheck = _G["burst"..kay]
                                if ItemBurstCheck == nil then ItemBurstCheck = 0 end
                                if GetTickCount() >= ItemBurstCheck then
                                        _G["burst"..kay] = GetTickCount() + 1000
                                        BBurst(Burstperc,ItSlot)
                                end
                        end
                end
        end
end
 
function LifeSaverOnDeleteObj(object)
        for i, PartiChecker in pairs(CheckParticles) do
                CheckParticle = PartiChecker.PARTICLE
                ParticleItemID = PartiChecker.ID
                if object ~= nil and object.name == CheckParticle then
                        _G["Active"..ParticleItemID] = false
                end
        end
end
 
function LifeSaverOnCreateObj(object)
        for i, PartiChecker in pairs(CheckParticles) do
                CheckParticle = PartiChecker.PARTICLE
                ParticleItemID = PartiChecker.ID
                if object ~= nil and object.name == CheckParticle then
                        _G["Active"..ParticleItemID] = true
                end
        end
end
 
function LifeSaverOnTick()
if GetTickCount() >= nextcheck then
        nextcheck = GetTickCount() + 1000
        CheckPurchase()
end
if #UsableItems ~= 0 then Check() end
end

-- ######################################  LIFE SAVER v2.1 Final  ########################################


-- ############################################# AUTO POTION ################################################

--[[
Auto Potions, in case you forget.
by ikita
    Improved by Manciuszz(based on PedobearIGER's IgniteCounterer).
]]

--[[  Config   ]]
    EnableSmiteCheck = true -- self explanatory. Enable only when Jungling for auto hp pots in the jungle else leave it disabled since you won't be jungling to late game lol.
    hpLimit = 0.4  --/ if myHero health is lower than the hpLimit then activate a HP potion automatically.
	--hpLimitElixir = 0.25  --/ if myHero health is lower than the hpLimit then activate a Red Elixir automatically.
    manaLimit = 0.4 --/ if myHero mana is lower than the manaLimit then activate a MP potion automatically.
    FountainRange = 1550 -- The Fountain(Spawn-Pool) Range.
    DELAY = 100   --OnTick delay.
    --[[  Globals  ]]
    local nextTick = 0

    if myHero == nil then myHero = GetMyHero() end

    --[[   Code   ]]
    function inFountain()--distance from myHero to fountain < range
        local function getFountainCoordinates()  -- Locate the coordinates of the myHero's spawn-pool.
            for i = 1, objManager.iCount, 1 do
                local object = objManager:GetObject(i)
                if object ~= nil and object.name:lower() == ("Turret_ChaosTurretShrine"):lower() and myHero.team == TEAM_RED then return object.x, object.y, object.z, FountainRange
                elseif object ~= nil and object.name:lower() == ("Turret_OrderTurretShrine"):lower() and myHero.team == TEAM_BLUE then return object.x, object.y, object.z, FountainRange
                end
            end
        end
        if X == nil or Y == nil or Z == nil or FountainRange == nil then --check if was able to get fountainCoordinates.
            if getFountainCoordinates() ~= nil then
                X, Y, Z, FountainRange = getFountainCoordinates()
            else
                PrintChat("Can't do this Sir!")
                return
            end
        end

        if math.sqrt((X - myHero.x) ^ 2 + (Z - myHero.z) ^ 2) < FountainRange then  -- the math shit, calculating if in spawn-pool.
            return true, X, Y, Z, FountainRange
        end
        return false, X, Y, Z, FountainRange
    end

    function Buffed(target,buffName)
        if target ~= nil and not target.dead and target.visible then
            for i = 1, target.buffCount, 1 do
                local buff = target:getBuff(i)
                if buff.valid then
                    if buff.name ~= nil and buff.name:lower() == buffName:lower()then
                        return true
                    end
                end
            end
        end
        return false
    end

    function PotionOnTick()
        if myHero.dead then return end

        if nextTick > GetTickCount() then return end
        nextTick = GetTickCount() + DELAY

        local tick = GetTickCount()
			-- I just want the manaLimit scale a little lower, so flask gets used faster.
        if myHero ~= nil and myHero.mana <= myHero.maxMana* (manaLimit*0.9) and not inFountain() and not Buffed(myHero, "Recall") and not Buffed(myHero, "SummonerTeleport") and not Buffed(myHero, "RecallImproved") then
            if Buffed(myHero,"FlaskOfCrystalWater") == false then
                for i=1, 6, 1 do
                    if myHero:getInventorySlot(_G["ITEM_"..i]) == 2004 then
                        CastSpell(_G["ITEM_"..i])
                    end
                end
            end
        end

        if myHero ~= nil and myHero.health <= myHero.maxHealth* (hpLimit*0.9) and not inFountain() and not Buffed(myHero, "Recall") and not Buffed(myHero, "SummonerTeleport") and not Buffed(myHero, "RecallImproved") then
            if Buffed(myHero,"RegenerationPotion") == false or Buffed(myHero,"SummonerDot") or Buffed(myHero,"grievouswound") or Buffed(myHero,"MordekaiserChildrenOfTheGrave") then
                for i=1, 6, 1 do
                    if myHero:getInventorySlot(_G["ITEM_"..i]) == 2003 then
                        CastSpell(_G["ITEM_"..i])
                    end
                end
            end
        end

        if myHero ~= nil and (myHero.health <= myHero.maxHealth* hpLimit or myHero.mana <= myHero.maxMana* manaLimit) and not inFountain() and not Buffed(myHero, "Recall") and not Buffed(myHero, "SummonerTeleport") and not Buffed(myHero, "RecallImproved") then
            if Buffed(myHero,"ItemCrystalFlask") == false or Buffed(myHero,"SummonerDot") or Buffed(myHero,"grievouswound") or Buffed(myHero,"MordekaiserChildrenOfTheGrave") then
                for i=1, 6, 1 do
                    if myHero:getInventorySlot(_G["ITEM_"..i]) == 2041 then
                        CastSpell(_G["ITEM_"..i])
                    end
                end
            end
        end

        if myHero ~= nil and (myHero.health <= myHero.maxHealth* hpLimit or myHero.mana <= myHero.maxMana* manaLimit) and not inFountain() and not Buffed(myHero, "Recall") and not Buffed(myHero, "SummonerTeleport") and not Buffed(myHero, "RecallImproved") then
            if Buffed(myHero,"ItemMiniRegenPotion") == false or Buffed(myHero,"SummonerDot") or Buffed(myHero,"grievouswound") or Buffed(myHero,"MordekaiserChildrenOfTheGrave") then
                for i=1, 6, 1 do
                    if myHero:getInventorySlot(_G["ITEM_"..i]) == 2009 then
                        CastSpell(_G["ITEM_"..i])
                    end
                end
            end
        end
		--[[
		if myHero ~= nil and myHero.health <= myHero.maxHealth* hpLimitElixir and not inFountain() and not Buffed(myHero, "Recall") and not Buffed(myHero, "SummonerTeleport") and not Buffed(myHero, "RecallImproved") then
            if Buffed(myHero,"PotionOfGiantStrengt") == false or Buffed(myHero,"SummonerDot") or Buffed(myHero,"grievouswound") or Buffed(myHero,"MordekaiserChildrenOfTheGrave") then
                for i=1, 6, 1 do
                    if myHero:getInventorySlot(_G["ITEM_"..i]) == 2037 then
                        CastSpell(_G["ITEM_"..i])
                    end
                end
            end
        end
		--]]
    end
    
	
    function SmiteCheck()
        if myHero:GetSpellData(SUMMONER_1).name:find("Smite") ~= nil then --check if the myHero has Smite(that means he's jungling(or trolling))
            --PrintChat("Playing as a Jungler!")
            hpLimit = 0.65
        elseif myHero:GetSpellData(SUMMONER_2).name:find("Smite") ~= nil then
            --PrintChat("Playing as a Jungler!")
            hpLimit = 0.65
        end
    end

    function PotionOnLoad()
    if EnableSmiteCheck then SmiteCheck() end
    end
-- ############################################# AUTO POTION ################################################

-- XT003.2 --

function OnLoad()
	KCConfig = scriptConfig("XT003.2 HUD By Galaxix", "xt002hud")
	KCConfig:addParam("MinionMarker", "Enable Minion Marker", SCRIPT_PARAM_ONOFF, true)
	KCConfig:addParam("TowerRange", "Enable Tower Range", SCRIPT_PARAM_ONOFF, false)
	KCConfig:addParam("StunAlert", "Enable Stun Alert", SCRIPT_PARAM_ONOFF, false)
	KCConfig:addParam("StunAlertSummary", "Enable Stun Alert Summary", SCRIPT_PARAM_ONOFF, false)
	KCConfig:addParam("LowAwareness", "Enable Low Awareness", SCRIPT_PARAM_ONOFF, false)
	KCConfig:addParam("HiddenObjects", "Enable Hidden Objects", SCRIPT_PARAM_ONOFF, true)
	--KCConfig:addParam("JungleDisplay", "Enable Jungle Display", SCRIPT_PARAM_ONOFF, true)
	KCConfig:addParam("AutoPotion", "Enable Auto Potion", SCRIPT_PARAM_ONOFF, true) 
	KCConfig:addParam("Ranges", "Enable Player & Enemy Ranges", SCRIPT_PARAM_ONOFF, false)
	KCConfig:addParam("MiniMapTimers", "MiniMapTimers (Reload(F9) If Error)", SCRIPT_PARAM_ONOFF, true)
	KCConfig:addParam("WardPrediction", "Enable Ward Prediction", SCRIPT_PARAM_ONOFF, true)
	KCConfig:addParam("WhereHeGo", "Where Did He Go(RELOAD(F9) after on", SCRIPT_PARAM_ONOFF, true)
	KCConfig:addParam("LifeSaver", "Life Saver v2.1 (Reload(F9) ) if error", SCRIPT_PARAM_ONOFF, true)
			
	
	if KCConfig.WhereHeGo then
        WDHGOnLoad()
    end
				
	if KCConfig.LifeSaver then
        LifeSaverOnLoad()
    end
    if KCConfig.MiniMapTimers then
        MiniMapTimersOnLoad()
    end
	
	--JungleDisplayOnLoad()
	TowerRangeOnLoad()
	MinionMarkerOnLoad()
	HiddenObjectsOnLoad()
	WardPredictionOnLoad()
	
end

function OnTick()
	if KCConfig.TowerRange then
		TowerRangeOnTick()
	end
	if KCConfig.LowAwareness then
		LowAwarenessOnTick()
	end
	if KCConfig.HiddenObjects then
		HiddenObjectsOnTick()
	end
	--if KCConfig.JungleDisplay then
	--	JungleDisplayOnTick()
	--end
	if KCConfig.WardPrediction then
		WardPredictionOnTick()
	end
	if KCConfig.WhereHeGo then
        WDHGOnTick()
    end
	if KCConfig.AutoPotion then
		PotionOnTick()
	end
    if KCConfig.LifeSaver then
        LifeSaverOnTick()
    end
    if KCConfig.MiniMapTimers then
        MiniMapTimersOnTick()
    end
	end

function OnCreateObj(obj)
	if KCConfig.MinionMarker then
		MinionMarkerOnCreateObj(obj)
	end
	if KCConfig.HiddenObjects then
		HiddenObjectsOnCreateObj(obj)
	end	
	--if KCConfig.JungleDisplay then
	--	JungleDisplayOnCreateObj(obj)
	--end	
	if KCConfig.WhereHeGo then
        WDHGOnCreateObj(obj)
    end
		if KCConfig.LifeSaver then
        LifeSaverOnCreateObj(obj)
    end
		
	end

function OnDeleteObj(obj)
	if KCConfig.TowerRange then
		TowerRangeOnDeleteObj(obj)
	end
	if KCConfig.HiddenObjects then
		HiddenObjectsOnDeleteObj(obj)
	end
	if KCConfig.LifeSaver then
        LifeSaverOnDeleteObj(obj)
    end
	--if KCConfig.JungleDisplay then
	--	if JungleDisplayOnDeleteObj then JungleDisplayOnDeleteObj(obj) end
	--end
	
end

function OnProcessSpell(obj,spell)
    if KCConfig.WhereHeGo then
        WDHGOnProcessSpell(obj,spell)
    end
    
end

function OnDraw()
	if KCConfig.MinionMarker then
		MinionMarkerOnDraw()
	end
	if KCConfig.TowerRange then
		TowerRangeOnDraw()
	end
	if KCConfig.StunAlert then
		StunAlertOnDraw()
	end
	if KCConfig.LowAwareness then
		LowAwarenessOnDraw()
	end
	if KCConfig.HiddenObjects then
		HiddenObjectsOnDraw()
	end
	---if KCConfig.JungleDisplay then
	 --   JungleDisplayOnDraw()
	--end
	if KCConfig.MiniMapTimers then
        MiniMapTimersOnDraw()
    end
	if KCConfig.Ranges then
		RangesOnDraw()
	end
	if KCConfig.WardPrediction then
		WardPredictionOnDraw()
	end
	if KCConfig.WhereHeGo then
     WDHGOnProcessSpell(obj,spell)    
        end 
				
end

function OnWndMsg(msg,key)
	--if KCConfig.JungleDisplay then
	--	JungleDisplayOnWndMsg(msg, key	)
	--end
	if KCConfig.StunAlert then
		StunAlertOnWndMsg(msg, key)
	end
	if KCConfig.WardPrediction then
		WardPredictionOnWndMsg(msg, key)
	end
	if KCConfig.MiniMapTimers then
        MiniMapTimersOnWndMsg(msg, key)
    end
end

PrintChat(" >> XT003.2-HUD Loaded By Galaxix <<")
