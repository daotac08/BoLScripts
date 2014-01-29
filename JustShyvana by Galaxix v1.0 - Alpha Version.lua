--[[
JustShyvana by Galaxix v1.0 - Alpha Version

Features:
                        - Prodiction for VIPs, NonVIP prediction
                        - Full Combo:
                                - Full W + E + Q + R Combo
                                - Uses AoE Position for R
                                - Items toggle in combo menu
                                - Orbwalking Toggle in combo menu
                        - Harass Settings:
                                - Uses E+Q Combo to harass
                                - Orbwalking toggle for harass in menu
                        - Farming Settings:
                                - Toggle to farm with Q in menu
                                - Toggle to farm with E in menu
                        - Jungle Clear Settings:
                                - Toggle to use Q to clear jungle
                                - Toggle to use W to clear jungle
                                - Toggle to use E to clear jungle
                                - Toggle to orbwalk the jungle minions
                        - KillSteal Settings:
                                - Smart KillSteal with Overkill Check:
                                        - Checks for enemy health < Q, E, W, QE, QW, WE, QWE, QWER
                                - Toggle for Auto Ignite
                        - Drawing Settings:
                                - Toggle to draw if enemy is killable
                                - Toggle to draw Q Range if available
                                - Toggle to draw W Range if available 
                                - Toggle to draw E Range if available
                                - Toggle to draw R Range if available
                        - Misc Settings:
                                - Toggle for Auto Health Pots
                
                Credits & Mentions
                        - Kain because I've used some of his code
                        - Sida / Manciuszz for orbwalking stuff
                        - Skeem, thank you so much bro !
                        
                Changelog:
                        1.0   - First Release!
                            

]]--

if myHero.charName ~= "Shyvana" then return end

-- Prodiction for VIPs --
if VIP_USER then 
    require "Prodiction" 
end


-- OnLoad Function --
function OnLoad()
	Variables()		
	Menu()
	PrintChat("<font color='#825E68'> >> JustShyvana by Galaxix v1.0 Loaded ! <<</font>")
end

-- OnTick Function --
function OnTick()
	Checks()
	UseConsumables()
	DamageCalcs()

	-- Menu Variables --
	ComboKey = Menu.combo.comboKey
	HarassKey = Menu.harass.harassKey
	FarmingKey = Menu.farming.farmKey
	JungleKey = Menu.jungle.jungleKey

	if ComboKey then Combo() end
	if HarassKey then HarassCombo() end
	if JungleKey then JungleClear() end
	if Menu.ks.killsteal then autoKs() end	
	if Menu.ks.AutoIgnite then AutoIgnite() end
	if FarmingKey and not (ComboKey or HarassKey) then FarmMinions() end
	if FarmingKey and not (ComboKey or HarassKey) then FarmMinions2() end
	end
	
-- Variables Function --
function Variables()
	qRange, wRange, eRange, rRange = 125, 325, 925, 1000
	qName, wName, eName, rName = "Twin Bite", "Burnout", "Flame Breath", "Dragon's Descent"
	qReady, wReady, eReady, rReady = false, false, false, false
	hpReady, mpReady, fskReady, Recalling = false, false, false, false
	usingHPot, usingMPot = false, false
	eSpeed, eDelay, eWidth = .150, .125, 80
	if VIP_USER then
                ePos = nil
                rPos = nil
                Prodict = ProdictManager.GetInstance()
                ProdictE = Prodict:AddProdictionObject(_E, eRange, 1500, 0.125, 80)
                ProdictR = Prodict:AddProdictionObject(_R, rRange, 1000, 0.125, 100)
    end
	TextList = {"Harass", "Q Kill", "Q+W Kill", "Q+E Kill", "Full Combo Kill"}
	KillText = {}
	waittxt = {} -- prevents UI lags, all credits to Dekaron
	for i=1, heroManager.iCount do waittxt[i] = i*3 end
	enemyMinions = minionManager(MINION_ENEMY, qRange, player, MINION_SORT_HEALTH_ASC)
	JungleMobs = {}
	JungleFocusMobs = {}
	lastAnimation = nil
	lastSpell = nil
	lastAttack = 0
	lastAttackCD = 0
	lastWindUpTime = 0
	
	-- Stolen from Apple who Stole it from Sida --
	JungleMobNames = { -- List stolen from SAC Revamped. Sorry, Sida!
        ["wolf8.1.1"] = true,
        ["wolf8.1.2"] = true,
        ["YoungLizard7.1.2"] = true,
        ["YoungLizard7.1.3"] = true,
        ["LesserWraith9.1.1"] = true,
        ["LesserWraith9.1.2"] = true,
        ["LesserWraith9.1.4"] = true,
        ["YoungLizard10.1.2"] = true,
        ["YoungLizard10.1.3"] = true,
        ["SmallGolem11.1.1"] = true,
        ["wolf2.1.1"] = true,
        ["wolf2.1.2"] = true,
        ["YoungLizard1.1.2"] = true,
        ["YoungLizard1.1.3"] = true,
        ["LesserWraith3.1.1"] = true,
        ["LesserWraith3.1.2"] = true,
        ["LesserWraith3.1.4"] = true,
        ["YoungLizard4.1.2"] = true,
        ["YoungLizard4.1.3"] = true,
        ["SmallGolem5.1.1"] = true,
}

	FocusJungleNames = {
        ["Dragon6.1.1"] = true,
        ["Worm12.1.1"] = true,
        ["GiantWolf8.1.1"] = true,
        ["AncientGolem7.1.1"] = true,
        ["Wraith9.1.1"] = true,
        ["LizardElder10.1.1"] = true,
        ["Golem11.1.2"] = true,
        ["GiantWolf2.1.1"] = true,
        ["AncientGolem1.1.1"] = true,
        ["Wraith3.1.1"] = true,
        ["LizardElder4.1.1"] = true,
        ["Golem5.1.2"] = true,
        ["GreatWraith13.1.1"] = true,
        ["GreatWraith14.1.1"] = true,
}
	for i = 0, objManager.maxObjects do
		local object = objManager:getObject(i)
		if object ~= nil then
			if FocusJungleNames[object.name] then
				table.insert(JungleFocusMobs, object)
			elseif JungleMobNames[object.name] then
				table.insert(JungleMobs, object)
			end
		end
	end
end

-- Menu Function -- 
function Menu()
	Menu = scriptConfig("JustShyvana by Galaxix", "Shyvana")

	Menu:addSubMenu("["..myHero.charName.." - Combo Settings]", "combo")
		Menu.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		Menu.combo:addParam("comboQ", "Use "..qName.." (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("comboW", "Use "..wName.." (W) in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("comboE", "Use "..eName.." (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("comboR", "Use "..rName.." (R) in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("comboItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:addParam("comboOrbwalk", "Orbwalk in Combo", SCRIPT_PARAM_ONOFF, true)
		Menu.combo:permaShow("comboKey")

	Menu:addSubMenu("["..myHero.charName.." - Harass Settings]", "harass")
		Menu.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 88)
		Menu.harass:addParam("harassQ", "Use "..qName.." (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		Menu.harass:addParam("harassW", "Use "..wName.." (W) in Harass", SCRIPT_PARAM_ONOFF, true)
		Menu.harass:addParam("harassE", "Use "..eName.." (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		Menu.harass:addParam("harassOrbwalk", "Orbwalk in Harass", SCRIPT_PARAM_ONOFF, true)
		Menu.harass:permaShow("harassKey")

	Menu:addSubMenu("["..myHero.charName.." - Farming Settings]", "farming")
		Menu.farming:addParam("farmKey", "Farming ON/OFF", SCRIPT_PARAM_ONKEYTOGGLE, false, 90)
		Menu.farming:addParam("farmQ", "Farm with "..qName.." (Q)", SCRIPT_PARAM_ONOFF, true)
		Menu.farming:addParam("farmE", "Farm with "..eName.." (E)", SCRIPT_PARAM_ONOFF, true)
		Menu.farming:permaShow("farmKey")

	Menu:addSubMenu("["..myHero.charName.." - Jungle Clear Settings]", "jungle")
		Menu.jungle:addParam("jungleKey", "Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
		Menu.jungle:addParam("jungleQ", "Clear with "..qName.." (Q)", SCRIPT_PARAM_ONOFF, true)
		Menu.jungle:addParam("jungleW", "Clear with "..wName.." (W)", SCRIPT_PARAM_ONOFF, true)
		Menu.jungle:addParam("jungleE", "Clear with "..eName.." (E)", SCRIPT_PARAM_ONOFF, true)
		Menu.jungle:addParam("jungleOrbwalk", "Orbwalk while Clearing", SCRIPT_PARAM_ONOFF, true)
		Menu.jungle:permaShow("jungleKey")

	Menu:addSubMenu("["..myHero.charName.." - Kill Steal Settings]", "ks")
		Menu.ks:addParam("killsteal", "Use Smart KillSteal", SCRIPT_PARAM_ONOFF, true)
		Menu.ks:addParam("AutoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		Menu.ks:permaShow("killsteal")

	Menu:addSubMenu("["..myHero.charName.." - Drawing Settings]", "drawing")
		Menu.drawing:addParam("mDraw", "Disable All Ranges Drawing", SCRIPT_PARAM_ONOFF, false)
		Menu.drawing:addParam("cDraw", "Draw Enemy Text", SCRIPT_PARAM_ONOFF, true)
		Menu.drawing:addParam("qDraw", "Draw "..qName.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		Menu.drawing:addParam("wDraw", "Draw "..wName.." (W) Range", SCRIPT_PARAM_ONOFF, false)
		Menu.drawing:addParam("eDraw", "Draw "..eName.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		Menu.drawing:addParam("rDraw", "Draw "..rName.." (R) Range", SCRIPT_PARAM_ONOFF, false)
		Menu.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)

	Menu:addSubMenu("["..myHero.charName.." - Misc Settings]", "misc")
		Menu.misc:addParam("aHP", "Auto Health Pots", SCRIPT_PARAM_ONOFF, true)
		Menu.misc:addParam("HPHealth", "Min % for Health Pots", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_PYSHCIAL)
	TargetSelector.name = "Shyvana"
	Menu:addTS(TargetSelector)
end

-- Combo Function --
function Combo()
	if Menu.combo.comboOrbwalk then
		if Target ~= nil then
			OrbWalking(Target)
		else
			moveToCursor()
		end
	end
	if Target ~= nil then
		if Menu.combo.comboItems then UseItems(Target) end
		if Menu.combo.comboR and rReady and GetDistance(Target) <= rRange then CastR(Target) end
		if Menu.combo.comboE and eReady and GetDistance(Target) <= eRange then CastE(Target) end
		if Menu.combo.comboW and wReady and GetDistance(Target) <= wRange then CastSpell(_W) end
		if Menu.combo.comboQ and qReady and GetDistance(Target) <= qRange then CastSpell(_Q) end
		end
	  end
    
-- Harass Function --
function HarassCombo()
	if Menu.harass.harassOrbwalk then
		if Target ~= nil then
			OrbWalking(Target)
		else
			moveToCursor()
		end
	end
	if Target ~= nil then
		if Menu.harass.harassE and eReady and GetDistance(Target) <= eRange then CastE(Target) end
		if Menu.harass.harassW and wReady and GetDistance(Target) <= wRange then CastSpell(_W) end
		if Menu.harass.harassQ and qReady and GetDistance(Target) <= qRange then CastSpell(_Q) end
		end
end

-- Farming Function --
function FarmMinions()
	for _, minion in pairs(enemyMinions.objects) do
			local qMinionDmg = getDmg("Q", minion, myHero)+getDmg("AD", minion, myHero)
			if ValidTarget(minion) then
				if Menu.farming.farmQ and qReady and GetDistance(minion) <= qRange and minion.health <= qMinionDmg then
					CastSpell(_Q, minion.x, minion.z)
				end
			end
		end
	end

-- Farming Function2
function FarmMinions2()
	for _, minion in pairs(enemyMinions.objects) do
			local eMinionDmg = getDmg("E", minion, myHero)+getDmg("AD", minion, myHero)
			if ValidTarget(minion) then
				if Menu.farming.farmE and qeReady and GetDistance(minion) <= eRange and minion.health <= eMinionDmg then
					CastSpell(_E, minion.x, minion.z)
				end
			end
		end
	end

-- Jungle Farming --
function JungleClear()
	JungleMob = GetJungleMob()
	if Menu.jungle.jungleOrbwalk then 
		if JungleMob ~= nil then 
			OrbWalking(JungleMob)
		else
			moveToCursor()
		end
	end
	if JungleMob ~= nil then
		if Menu.jungle.jungleE and GetDistance(JungleMob) <= eRange then CastSpell(_E, JungleMob.x, JungleMob.z) end
		if Menu.jungle.jungleW and GetDistance(JungleMob) <= wRange then CastSpell(_W) end
		if Menu.jungle.jungleQ and GetDistance(JungleMob) <= wRange then CastSpell(_Q) end
	end
end

-- Get Jungle Mob--
function GetJungleMob()
        for _, Mob in pairs(JungleFocusMobs) do
                if ValidTarget(Mob, qRange) then return Mob end
        end
        for _, Mob in pairs(JungleMobs) do
                if ValidTarget(Mob, qRange) then return Mob end
        end
end

-- Cast E  --
function CastE(Target)
    if Target and (myHero:CanUseSpell(_E) == READY) then
    if VIP_USER then
    if ePos ~= nil then
    CastSpell(_E, ePos.x, ePos.z)
    end
          
    else
    
    local ePred = TargetPrediction(eRange, eSpeed, eDelay, eWidth)
    local ePrediction = ePred:GetPrediction(enemy)
    if ePrediction then
    CastSpell(_E, enemy.x, enemy.z)
    end
        end
    end
  end

-- Cast R --
function CastR(Target)
    if Target and (myHero:CanUseSpell(_R) == READY) then
    if VIP_USER then
    if rPos ~= nil then
    CastSpell(_R, ePos.x, ePos.z)
    end            
      
    else
                
    local ultPos = GetAoESpellPosition(1000, Target)
    if ultPos and GetDistance(ultPos) <= rRange then
    CastSpell(_R, ultPos.x, ultPos.z)
                        end
                end
        end
end
-- Using Items --
function UseItems(enemy)
	if not enemy then
		enemy = Target
	end
	if Target ~= nil then
		if dfgReady and GetDistance(enemy) <= 750 then CastSpell(dfgSlot, enemy) end
		if hxgReady and GetDistance(enemy) <= 600 then CastSpell(hxgSlot, enemy) end
		if bwcReady and GetDistance(enemy) <= 450 then CastSpell(bwcSlot, enemy) end
		if brkReady and GetDistance(enemy) <= 450 then CastSpell(brkSlot, enemy) end
		if tmtReady and GetDistance(enemy) <= 185 then CastSpell(tmtSlot) end
		if hdrReady and GetDistance(enemy) <= 185 then CastSpell(hdrSlot) end
	end
end

-- Killsteal Function -- 
function autoKs()
	if Target ~= nil then
		if Menu.ks.killsteal then
		        if qReady and Target.health <= qDmg and GetDistance(Target) <= qRange then 
                        CastSpell(_Q)
                elseif eReady and Target.health <= eDmg and GetDistance(Target) <= eRange then
                        CastE(Target)
                elseif wReady and Target.health <= wDmg and GetDistance(Target) <= wRange then
                        CastSpell(_W)
                elseif qReady and eReady and Target.health <= (qDmg + eDmg) and GetDistance(Target) <= eRange then
                        CastE(Target)
                        CastSpell(_Q)
                elseif qReady and wReady and Target.health <= (qDmg + wDmg) and GetDistance(Target) <= qRange then
                        CastSpell(_Q)
                        CastSpell(_W, Target)
                elseif eReady and wReady and Target.health <= (eDmg + wDmg) and GetDistance(Target) <= eRange then
                        CastE(Target)
                        CastSpell(_Q)
                elseif qReady and eReady and wReady and Target.health <= (qDmg + eDmg + wDmg) and GetDistance(Target) <= wRange then
                        CastE(Target)
                        CastSpell(_Q)
                        CastSpell(_W)
                elseif qReady and eReady and wReady and rReady and Target.health <= (qDmg + eDmg + wDmg + rDmg) and GetDistance(Target) <= rRange then
                        CastE(Target)
                        CastR(Target) 
                        CastSpell(_Q)
                        CastSpell(_W, Target)
                                               
                        
                end
        end
    end
end

-- Auto Ignite --
function AutoIgnite()
	if Target ~= nil then
		if Target.health <= iDmg and GetDistance(Target) <= 600 then
			if iReady then CastSpell(ignite, Target) end
		end
	end
end

-- Using Consumables --
function UseConsumables()
	if not InFountain() and not Recalling and Target ~= nil then
		if Menu.misc.aHP and myHero.health < (myHero.maxHealth * (Menu.misc.HPHealth / 100))
			and not (usingHPot or usingFlask) and (hpReady or fskReady)	then
				CastSpell((hpSlot or fskSlot)) 
		   end
		end
	end

-- Damage Calculations --
function DamageCalcs()
	for i=1, heroManager.iCount do
	local enemy = heroManager:GetHero(i)
		if ValidTarget(enemy) then
			dfgDmg, hxgDmg, bwcDmg, iDmg  = 0, 0, 0, 0
			qDmg, wDmg, rDmg, eDmg = 0, 0, 0, 0
			aDmg = getDmg("AD",enemy,myHero)
			if qReady then qDmg = getDmg("Q", enemy, myHero) end
			if wReady then wDmg = getDmg("W", enemy, myHero) end
			if rReady then rDmg = getDmg("R", enemy, myHero) end
			if eReady then eDmg = getDmg("E", enemy, myHero) end
			if dfgReady then dfgDmg = (dfgSlot and getDmg("DFG",enemy,myHero) or 0)	end
            if hxgReady then hxgDmg = (hxgSlot and getDmg("HXG",enemy,myHero) or 0) end
            if bwcReady then bwcDmg = (bwcSlot and getDmg("BWC",enemy,myHero) or 0) end
            if iReady then iDmg = (ignite and getDmg("IGNITE",enemy,myHero) or 0) end
            onspellDmg = (liandrysSlot and getDmg("LIANDRYS",enemy,myHero) or 0)+(blackfireSlot and getDmg("BLACKFIRE",enemy,myHero) or 0)
            extraDmg = dfgDmg + hxgDmg + bwcDmg + onspellDmg + iDmg
                   KillText[i] = 1
                  if enemy.health <= qDmg then
                          KillText[i] = 2
                  elseif enemy.health <= (qDmg + wDmg) and enemy.health <= qDmg and wDmg then
                          KillText[i] = 3
                  elseif enemy.health <= (qDmg + rDmg) and enemy.health <= qDmg and eDmg then
                          KillText[i] = 4
                  elseif enemy.health <= (qDmg + wDmg + eDmg + rDmg) and enemy.health <= qDmg and eDmg and wDmg and rDmg then
                          KillText[i] = 5
            end        
        end
    end
end

-- Object Handling Functions --
function OnCreateObj(obj)
	if obj ~= nil then
		if obj.name:find("Global_Item_HealthPotion.troy") then
			if GetDistance(obj, myHero) <= 70 then
				usingHPot = true
				usingFlask = true
			end
		end
		if obj.name:find("Global_Item_ManaPotion.troy") then
			if GetDistance(obj, myHero) <= 70 then
				usingFlask = true
				usingMPot = true
			end
		end
		if obj.name:find("TeleportHome.troy") then
			if GetDistance(obj) <= 70 then
				Recalling = true
			end
		end
		if FocusJungleNames[obj.name] then
			table.insert(JungleFocusMobs, obj)
		elseif JungleMobNames[obj.name] then
            table.insert(JungleMobs, obj)
		end
	end
end

function OnDeleteObj(obj)
	if obj ~= nil then
			if obj.name:find("Global_Item_HealthPotion.troy") then
			if GetDistance(obj) <= 70 then
				usingHPot = false
				usingFlask = false
			end
		end
		if obj.name:find("Global_Item_ManaPotion.troy") then
			if GetDistance(obj) <= 70 then
				usingMPot = false
				usingFlask = false
			end
		end
		if obj.name:find("TeleportHome.troy") then
			if GetDistance(obj) <= 70 then
				Recalling = false
			end
		end
		for i, Mob in pairs(JungleMobs) do
			if obj.name == Mob.name then
				table.remove(JungleMobs, i)
			end
		end
		for i, Mob in pairs(JungleFocusMobs) do
			if obj.name == Mob.name then
				table.remove(JungleFocusMobs, i)
			end
		end
	end
end

-- Function Ondraw --
function OnDraw()
	-- Ranges --
	if not Menu.drawing.mDraw and not myHero.dead then
		if qReady and Menu.drawing.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, ARGB(255,127,0,110))
		end
		if wReady and Menu.drawing.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, wRange, ARGB(255,95,159,159))
		end
		if eReady and Menu.drawing.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, ARGB(255,204,50,50))
		end
		if rReady and Menu.drawing.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, ARGB(255,69,139,0))
		  end
		end

	-- Drawing Texts --
	if Menu.drawing.cDraw then
		for i=1, heroManager.iCount do
			local Unit = heroManager:GetHero(i)
			if ValidTarget(Unit) then
				if waittxt[i] == 1 and (KillText[i] ~= nil or 0 or 1) then
					PrintFloatText(Unit, 0, TextList[KillText[i]])
				end
			end
			if waittxt[i] == 1 then
				waittxt[i] = 30
			else
				waittxt[i] = waittxt[i]-1
			end
		end
	end
end

-- Lagfree Circles by barasia, vadash and viseversa
function DrawCircleNextLvl(x, y, z, radius, width, color, chordlength)
    radius = radius or 300
		quality = math.max(8,round(180/math.deg((math.asin((chordlength/(2*radius)))))))
		quality = 2 * math.pi / quality
		radius = radius*.92
    local points = {}
    for theta = 0, 2 * math.pi + quality, quality do
        local c = WorldToScreen(D3DXVECTOR3(x + radius * math.cos(theta), y, z - radius * math.sin(theta)))
        points[#points + 1] = D3DXVECTOR2(c.x, c.y)
    end
    DrawLines2(points, width or 1, color or 4294967295)
end

function round(num) 
	if num >= 0 then return math.floor(num+.5) else return math.ceil(num-.5) end
end

function DrawCircle2(x, y, z, radius, color)
    local vPos1 = Vector(x, y, z)
    local vPos2 = Vector(cameraPos.x, cameraPos.y, cameraPos.z)
    local tPos = vPos1 - (vPos1 - vPos2):normalized() * radius
    local sPos = WorldToScreen(D3DXVECTOR3(tPos.x, tPos.y, tPos.z))
    if OnScreen({ x = sPos.x, y = sPos.y }, { x = sPos.x, y = sPos.y }) then
        DrawCircleNextLvl(x, y, z, radius, 1, color, 75)	
    end
end

--Based on Manciuzz Orbwalker http://pastebin.com/jufCeE0e
function OrbWalking(Target)
	if TimeToAttack() and GetDistance(Target) <= myHero.range + GetDistance(myHero.minBBox) then
		myHero:Attack(Target)
    elseif heroCanMove() then
        moveToCursor()
    end
end

function TimeToAttack()
    return (GetTickCount() + GetLatency()/2 > lastAttack + lastAttackCD)
end

function heroCanMove()
	return (GetTickCount() + GetLatency()/2 > lastAttack + lastWindUpTime + 20)
end

function moveToCursor()
	if GetDistance(mousePos) then
		local moveToPos = myHero + (Vector(mousePos) - myHero):normalized()*300
		myHero:MoveTo(moveToPos.x, moveToPos.z)
    end        
end

function OnProcessSpell(object,spell)
	if object == myHero then
		if spell and lastSpell ~= spell.name then lastSpell = spell.name end
		if spell.name:lower():find("attack") then
			lastAttack = GetTickCount() - GetLatency()/2
			lastWindUpTime = spell.windUpTime*1000
			lastAttackCD = spell.animationTime*1000
        end
    end
end

function OnAnimation(unit, animationName)
    if unit.isMe and lastAnimation ~= animationName then lastAnimation = animationName end
end

-- Spells and Items Checks --
function Checks()
	-- Target Update --
	TargetSelector:update()
	Target = TargetSelector.target

	-- Ignite Slot --
	if myHero:GetSpellData(SUMMONER_1).name:find("SummonerDot") then ignite = SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name:find("SummonerDot") then ignite = SUMMONER_2
	end

	-- Slots for Items / Pots / Wards --
	rstSlot, ssSlot, swSlot, vwSlot =    GetInventorySlotItem(2045),
									     GetInventorySlotItem(2049),
									     GetInventorySlotItem(2044),
									     GetInventorySlotItem(2043)
	dfgSlot, hxgSlot, bwcSlot, brkSlot = GetInventorySlotItem(3128),
										 GetInventorySlotItem(3146),
										 GetInventorySlotItem(3144),
										 GetInventorySlotItem(3153)
	hpSlot, mpSlot, fskSlot =            GetInventorySlotItem(2003),
							             GetInventorySlotItem(2004),
							             GetInventorySlotItem(2041)
	znaSlot, wgtSlot =                   GetInventorySlotItem(3157),
	                                     GetInventorySlotItem(3090)
	tmtSlot, hdrSlot = 					 GetInventorySlotItem(3077)
										 GetInventorySlotItem(3074)
	
	-- Spells --									 
	qReady = (myHero:CanUseSpell(_Q) == READY)
	wReady = (myHero:CanUseSpell(_W) == READY)
	eReady = (myHero:CanUseSpell(_E) == READY)
	rReady = (myHero:CanUseSpell(_R) == READY)
	iReady = (ignite ~= nil and myHero:CanUseSpell(ignite) == READY)
	
	-- Items --
	dfgReady = (dfgSlot ~= nil and myHero:CanUseSpell(dfgSlot) == READY)
	hxgReady = (hxgSlot ~= nil and myHero:CanUseSpell(hxgSlot) == READY)
	bwcReady = (bwcSlot ~= nil and myHero:CanUseSpell(bwcSlot) == READY)
	brkReady = (brkSlot ~= nil and myHero:CanUseSpell(brkSlot) == READY)
	znaReady = (znaSlot ~= nil and myHero:CanUseSpell(znaSlot) == READY)
	wgtReady = (wgtSlot ~= nil and myHero:CanUseSpell(wgtSlot) == READY)
	tmtReady = (tmtSlot ~= nil and myHero:CanUseSpell(tmtSlot) == READY)
	hdrReady = (hdrSlot ~= nil and myHero:CanUseSpell(hdrSlot) == READY)
	
	-- Pots --
	hpReady = (hpSlot ~= nil and myHero:CanUseSpell(hpSlot) == READY)
	mpReady = (mpSlot ~= nil and myHero:CanUseSpell(mpSlot) == READY)
	fskReady = (fskSlot ~= nil and myHero:CanUseSpell(fskSlot) == READY)

	-- Updates Minions --
	enemyMinions:update()
	
	if ValidTarget(Target) then
	ePos = ProdictE:GetPrediction(Target)
	rPos = ProdictR:GetPrediction(Target)
	end
	
	-- Lagfree Circles --
	if Menu.drawing.LfcDraw then
		_G.DrawCircle = DrawCircle2
	end
end	

PrintChat("<font color='#825E68'> >> JustShyvana by Galaxix v1.0 Loaded ! <<</font>")

--------------------------------------- END OF SCRIPT ----------------------------------------------------------                

--[[ 
        AoE_Skillshot_Position 2.0 by monogato
        
        GetAoESpellPosition(radius, main_target, [delay]) returns best position in order to catch as many enemies as possible with your AoE skillshot, making sure you get the main target.
        Note: You can optionally add delay in ms for prediction (VIP if avaliable, normal else).
]]

function GetCenter(points)
        local sum_x = 0
        local sum_z = 0
        
        for i = 1, #points do
                sum_x = sum_x + points[i].x
                sum_z = sum_z + points[i].z
        end
        
        local center = {x = sum_x / #points, y = 0, z = sum_z / #points}
        
        return center
end

function ContainsThemAll(circle, points)
        local radius_sqr = circle.radius*circle.radius
        local contains_them_all = true
        local i = 1
        
        while contains_them_all and i <= #points do
                contains_them_all = GetDistanceSqr(points[i], circle.center) <= radius_sqr
                i = i + 1
        end
        
        return contains_them_all
end


function FarthestFromPositionIndex(points, position)
        local index = 2
        local actual_dist_sqr
        local max_dist_sqr = GetDistanceSqr(points[index], position)
        
        for i = 3, #points do
                actual_dist_sqr = GetDistanceSqr(points[i], position)
                if actual_dist_sqr > max_dist_sqr then
                        index = i
                        max_dist_sqr = actual_dist_sqr
                end
        end
        
        return index
end

function RemoveWorst(targets, position)
        local worst_target = FarthestFromPositionIndex(targets, position)
        
        table.remove(targets, worst_target)
        
        return targets
end

function GetInitialTargets(radius, main_target)
        local targets = {main_target}
        local diameter_sqr = 4 * radius * radius
        
        for i=1, heroManager.iCount do
                target = heroManager:GetHero(i)
                if target.networkID ~= main_target.networkID and ValidTarget(target) and GetDistanceSqr(main_target, target) < diameter_sqr then table.insert(targets, target) end
        end
        
        return targets
end

function GetPredictedInitialTargets(radius, main_target, delay)
        if VIP_USER and not vip_target_predictor then vip_target_predictor = TargetPredictionVIP(nil, nil, delay/1000) end
        local predicted_main_target = VIP_USER and vip_target_predictor:GetPrediction(main_target) or GetPredictionPos(main_target, delay)
        local predicted_targets = {predicted_main_target}
        local diameter_sqr = 4 * radius * radius
        
        for i=1, heroManager.iCount do
                target = heroManager:GetHero(i)
                if ValidTarget(target) then
                        predicted_target = VIP_USER and vip_target_predictor:GetPrediction(target) or GetPredictionPos(target, delay)
                        if target.networkID ~= main_target.networkID and GetDistanceSqr(predicted_main_target, predicted_target) < diameter_sqr then table.insert(predicted_targets, predicted_target) end
                end
        end
        
        return predicted_targets
end


function GetAoESpellPosition(radius, main_target, delay)
        local targets = delay and GetPredictedInitialTargets(radius, main_target, delay) or GetInitialTargets(radius, main_target)
        local position = GetCenter(targets)
        local best_pos_found = true
        local circle = Circle(position, radius)
        circle.center = position
        
        if #targets > 2 then best_pos_found = ContainsThemAll(circle, targets) end
        
        while not best_pos_found do
                targets = RemoveWorst(targets, position)
                position = GetCenter(targets)
                circle.center = position
                best_pos_found = ContainsThemAll(circle, targets)
        end
        
        return position, #targets
end 
--END AOE SKILLSHOT--
