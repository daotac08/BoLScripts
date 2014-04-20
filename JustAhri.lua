--[[ JustAhri by Galaxix ALPHA Version

	Features:
			-Combo Settings:
				-Full Combo using Q, W, E, R
				-Toggle to use Q
				-Toggle to use W
				-Toggle to use E
				-Toggle to use R
				-Items Toggle 
				-Orbwalking Toggle	
			-Harass Settings:
				-Uses Q and W and E for Harass
				-Toggle to use Q
				-Toggle to use W
				-Toggle to use E
				-Orbwalking Toggle
			-Farming Settings:
				-Toggle to farm with Q
			-Jungle Clear Settings:
				-Toggle to use Q in Jungle
				-Toggle to use W in Jungle
				-Orbwalking Toggle
			-Kill Steal Settings:
				-Smart Killsteal with Overkillcheck
					-Checks for enemy health for different possible Killcombos
					-Autoignite Toggle
			-Drawing Settings:
				-Toggle to draw if Enemy is killable(and the combo which will be used)
				-Toggle to draw Spellranges if available
				-Toggle to use Lagfree Circles by barasia, vadash and viseversa
			-Misc Settings:
				-Toggle for Auto Zhonyas / Wooglets
				-Toggle for Auto Mana / Health Pots
				-Sliders for setting up:
					-Min Mana % to Farm / Jungle Clear
					-Min Health % for Auto Zhonyas / Wooglets
					-Min Health % for Auto HP Pots

		Credits & Mentions: 
			-Skeem - BotHappy - ENTRYWAY 
			-Manciuszz for orbwalking stuff
			-barasia, vadash and viseversa for Lagfree Circles
			- Apple for helping
		
		Changelog:
			1.0 - Initial Release
			1.1 - Fixed eDmg
			1.2 Fixed QPos and Added VPrediction to Skills.
			1.3 Fixed bugs.
			1.7 Fixed errors.

	]]--

-- Hero Name & VIP Check --
if myHero.charName ~= "Ahri" or not VIP_USER then return end

local version = "1.900"

local AUTOUPDATE = true
local UPDATE_HOST = "raw.github.com"
local UPDATE_PATH = "/Galaxix/BoLScripts/master/JustAhri.lua".."?rand="..math.random(1,10000)
local UPDATE_FILE_PATH = LIB_PATH.."JustNocturne.lua"
local UPDATE_URL = "https://"..UPDATE_HOST..UPDATE_PATH

function AutoupdaterMsg(msg) print("<font color=\"#6699ff\"><b>Ahri, The Nine-Tailed Fox:</b></font> <font color=\"#FFFFFF\">"..msg..".</font>") end
if AUTOUPDATE then
	local ServerData = GetWebResult(UPDATE_HOST, UPDATE_PATH)
	if ServerData then
		local ServerVersion = string.match(ServerData, "local version = \"%d+.%d+\"")
		ServerVersion = string.match(ServerVersion and ServerVersion or "", "%d+.%d+")
		if ServerVersion then
			ServerVersion = tonumber(ServerVersion)
			if tonumber(version) < ServerVersion then
				AutoupdaterMsg("New Version Available"..ServerVersion)
				AutoupdaterMsg("Updating, please don't press F9")
				DelayAction(function() DownloadFile(UPDATE_URL, UPDATE_FILE_PATH, function () AutoupdaterMsg("Successfully updated. ("..version.." => "..ServerVersion.."), press F9 twice to load the updated version.") end) end, 3)
			else
				AutoupdaterMsg("You have got the latest version ("..ServerVersion..")")
			end
		end
	else
		AutoupdaterMsg("Error downloading version info, please manually update it.")
	end
end

-- require Prodiction and Collision by Klokje and VPPRED by Honda7 --
require "Prodiction"
require "Collision"
require "VPrediction"

-- OnLoad Function --
function OnLoad()
	Variables()		
	AhriMenu()
	VP = VPrediction()
	PrintChat("<font color='#FF1493'> >> JustAhri by Galaxix v1.9 ALPHA Loaded ! <<</font>")
end

-- OnTick Function --
function OnTick()
	Checks()
	UseConsumables()
	DamageCalcs()

	-- Menu Variables --
	ComboKey = AhriMenu.combo.comboKey
	HarassKey = AhriMenu.harass.harassKey
	FarmingKey = AhriMenu.farming.farmKey
	JungleKey = AhriMenu.jungle.jungleKey

	if ComboKey then Combo() end
	if HarassKey then HarassCombo() end
	if JungleKey then JungleClear() end
	if AhriMenu.ks.killsteal then autoKs() end	
	if AhriMenu.ks.AutoIgnite then AutoIgnite() end
	if FarmingKey and not (ComboKey) then FarmMinions() end
	if AhriMenu.misc.ZWItems and MyHealthLow() and Target and (ZNAREADY or WGTREADY) then CastSpell((wgtSlot or znaSlot)) end
end

-- Variables Function --
function Variables()
	qRange, wRange, eRange, rRange = 880, 750, 975, 450
	qName, wName, eName, rName = "Orb of Deception", "Fox-Fire", "Charm", "Spirit Rush"
	qReady, wReady, eReady, rReady = false, false, false, false
	qSpeed, qDelay, qWidth = 1100, 0.25, 100 
	eSpeed, eDelay, eWidth = 1200, 0.25, 60
	Prodict = ProdictManager.GetInstance()
	ProdictQ = Prodict:AddProdictionObject(_Q, qRange, qSpeed, qDelay, qWidth, myHero)
	ProdictE = Prodict:AddProdictionObject(_E, eRange, eSpeed, eDelay, eWidth, myHero)
	ProdictECol = nil
	VP = nil
	Col = nil
	ProdictECol = Collision(eRange, eSpeed, eDelay, eWidth)
    Col = Collision(eRange, eSpeed, eDelay, eWidth)
	hpReady, mpReady, fskReady, Recalling = false, false, false, false
	usingHPot, usingMPot = false, false
	TextList = {"Harass", "Q Kill", "Q+W Kill", "Q+R Kill", "Q+E Kill", "Q+W+E+R Kill", "Q+W+E+Rx3 Kill"}
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
function AhriMenu()
	AhriMenu = scriptConfig("JustAhri by Galaxix", "Ahri")

	AhriMenu:addSubMenu("["..myHero.charName.." - Combo Settings]", "combo")
		AhriMenu.combo:addParam("comboKey", "Combo Key", SCRIPT_PARAM_ONKEYDOWN, false, 32)
		AhriMenu.combo:addParam("comboQ", "Use "..qName.." (Q) in Combo", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.combo:addParam("comboW", "Use "..wName.." (W) in Combo", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.combo:addParam("comboE", "Use "..eName.." (E) in Combo", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.combo:addParam("accuracyE", "Accuracy Slider", SCRIPT_PARAM_SLICE, 1, 0, 5, 0)
		AhriMenu.combo:addParam("comboR", "Use "..rName.." (R) in Combo", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.combo:addParam("comboItems", "Use Items in Combo", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.combo:addParam("comboOrbwalk", "Orbwalk in Combo", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.combo:addParam("mana2", "Don't combo if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
		AhriMenu.combo:addParam("RequireCharm","Require Charm (J)", SCRIPT_PARAM_ONKEYTOGGLE, true, string.byte("J"))
		AhriMenu.combo:permaShow("RequireCharm")
		AhriMenu.combo:permaShow("comboKey")

	AhriMenu:addSubMenu("["..myHero.charName.." - Harass Settings]", "harass")
		AhriMenu.harass:addParam("harassKey", "Harass Key", SCRIPT_PARAM_ONKEYDOWN, false, 88)
		AhriMenu.harass:addParam("harassQ", "Use "..qName.." (Q) in Harass", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.harass:addParam("harassW", "Use "..wName.." (W) in Harass", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.harass:addParam("harassE", "Use "..eName.." (E) in Harass", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.harass:addParam("mana", "Don't harass if mana < %", SCRIPT_PARAM_SLICE, 0, 0, 100)
		AhriMenu.harass:addParam("harassOrbwalk", "Orbwalk in Harass", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.harass:permaShow("harassKey")

	AhriMenu:addSubMenu("["..myHero.charName.." - Farming Settings]", "farming")
		AhriMenu.farming:addParam("farmKey", "Farming ON/OFF", SCRIPT_PARAM_ONKEYTOGGLE, false, 90)
		AhriMenu.farming:addParam("farmQ", "Farm with "..qName.." (Q)", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.farming:permaShow("farmKey")

	AhriMenu:addSubMenu("["..myHero.charName.." - Jungle Clear Settings]", "jungle")
		AhriMenu.jungle:addParam("jungleKey", "Jungle Clear Key", SCRIPT_PARAM_ONKEYDOWN, false, 67)
		AhriMenu.jungle:addParam("jungleQ", "Clear with "..qName.." (Q)", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.jungle:addParam("jungleW", "Clear with "..wName.." (W)", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.jungle:addParam("jungleOrbwalk", "Orbwalk while Clearing", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.jungle:permaShow("jungleKey")

	AhriMenu:addSubMenu("["..myHero.charName.." - Kill Steal Settings]", "ks")
		AhriMenu.ks:addParam("killsteal", "Use Smart KillSteal", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.ks:addParam("AutoIgnite", "Auto Ignite", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.ks:permaShow("killsteal")

	AhriMenu:addSubMenu("["..myHero.charName.." - Drawing Settings]", "drawing")
		AhriMenu.drawing:addParam("mDraw", "Disable All Ranges Drawing", SCRIPT_PARAM_ONOFF, false)
		AhriMenu.drawing:addParam("cDraw", "Draw Enemy Text", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.drawing:addParam("qDraw", "Draw "..qName.." (Q) Range", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.drawing:addParam("wDraw", "Draw "..wName.." (W) Range", SCRIPT_PARAM_ONOFF, false)
		AhriMenu.drawing:addParam("eDraw", "Draw "..eName.." (E) Range", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.drawing:addParam("rDraw", "Draw "..rName.." (R) Range", SCRIPT_PARAM_ONOFF, false)
		AhriMenu.drawing:addParam("DrawP", "Draw Ppredicted Position", SCRIPT_PARAM_ONOFF, false)
		AhriMenu.drawing:addParam("LfcDraw", "Use Lagfree Circles (Requires Reload!)", SCRIPT_PARAM_ONOFF, true)

	AhriMenu:addSubMenu("["..myHero.charName.." - Misc Settings]", "misc")
		--AhriMenu.misc:addParam("UseProdiction", "Use - Prodiction (Needs Reload)", SCRIPT_PARAM_ONOFF, false)
		AhriMenu.misc:addParam("aMP", "Auto Mana Pots", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.misc:addParam("aHP", "Auto Health Pots", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.misc:addParam("ZWItems", "Auto Zhonyas/Wooglets", SCRIPT_PARAM_ONOFF, true)
		AhriMenu.misc:addParam("ZWHealth", "Min Health % for Zhonyas/Wooglets", SCRIPT_PARAM_SLICE, 15, 0, 100, -1)
		AhriMenu.misc:addParam("Mana", "Min Mana % for Harras/Jungle", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
		AhriMenu.misc:addParam("farmMana", "Min Mana % for Farming/Jungle Clear", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)
		AhriMenu.misc:addParam("HPHealth", "Min % for Health Pots", SCRIPT_PARAM_SLICE, 50, 0, 100, -1)

	TargetSelector = TargetSelector(TARGET_LESS_CAST_PRIORITY, 1000, DAMAGE_MAGIC)
	TargetSelector.name = "Ahri"
	AhriMenu:addTS(TargetSelector)
end

-- Combo Function --
function Combo()
	if not myManaLow2() then
	if AhriMenu.combo.comboOrbwalk then
		if Target ~= nil then
			OrbWalking(Target)
		else
			moveToCursor()
		end
	end
	if Target ~= nil and not Target.dead and ValidTarget(Target, 1200) then
		if AhriMenu.combo.comboE and eReady and GetDistance(Target) <= eRange then CastE(Target) end
		if charmCheck() then return end
		if AhriMenu.combo.comboItems then UseItems(Target) end
		if AhriMenu.combo.comboQ and qReady and GetDistance(Target) <= qRange then CastQ(Target) end
		if AhriMenu.combo.comboW and wReady and GetDistance(Target) <= wRange then CastSpell(_W) end
		if AhriMenu.combo.comboR and rReady and GetDistance(Target) <= rRange then CastR(Target) end
		
		end
	    end
	    end

-- Harass Function --
function HarassCombo()
    if not myManaLow2() then
	if AhriMenu.harass.harassOrbwalk then
		if Target ~= nil then
			OrbWalking(Target)
		else
			moveToCursor()
		end
	end
	    if Target ~= nil and not Target.dead and ValidTarget(Target, 1200) then
		if AhriMenu.harass.harassE and eReady and GetDistance(Target) <= eRange then CastE(Target) end
		if charmCheck() then return end
		if AhriMenu.harass.harassQ and qReady and GetDistance(Target) <= qRange then CastQ(Target) end
		if AhriMenu.harass.harassW and wReady and GetDistance(Target) <= wRange then CastSpell(_W) end
		end
end
end

-- Farming Function --
function FarmMinions()
	if not myManaLow() then 
		for _, minion in pairs(enemyMinions.objects) do
			local qMinionDmg = getDmg("Q", minion, myHero)
			if ValidTarget(minion) then
				if AhriMenu.farming.farmQ and qReady and GetDistance(minion) <= qRange and minion.health <= qMinionDmg then
					CastSpell(_Q, minion.x, minion.z)
				end
			end
		end
	end
end

-- Farming Mana Function by Kain--
function myManaLow()
	if myHero.mana < (myHero.maxMana * (AhriMenu.misc.farmMana / 100)) then
		return true
	else
		return false
	end
end

-- Farming Mana Function by Kain--
function myManaLow2()
	if myHero.mana < (myHero.maxMana * (AhriMenu.misc.Mana / 100)) then
		return true
	else
		return false
	end
end

-- Jungle Farming --
function JungleClear()
	JungleMob = GetJungleMob()
	if AhriMenu.jungle.jungleOrbwalk then 
		if JungleMob ~= nil then 
			OrbWalking(JungleMob)
		else
			moveToCursor()
		end
	end
	if JungleMob ~= nil and not myManaLow() then
		if AhriMenu.jungle.jungleQ and GetDistance(JungleMob) <= qRange then CastSpell(_Q, JungleMob.x, JungleMob.z) end
		if AhriMenu.jungle.jungleW and GetDistance(JungleMob) <= wRange then CastSpell(_W) end
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

function GetHitBoxRadius(Target)
        return GetDistance(Target, Target.minBBox)
end

-- Cast Q  --
function CastQ(Target)
    if (myHero:CanUseSpell(_Q) == READY) then
    for i, target in pairs(GetEnemyHeroes()) do
    CastPosition,  HitChance,  Position = VP:GetLineCastPosition(Target, qDelay, qWidth, qRange, qSpeed, myHero)
	if HitChance >= 2 and GetDistance(CastPosition) <= qRange then
	CastSpell(_Q, CastPosition.x, CastPosition.z)
	
	end
	end
	end
	end
-- Cast E --
function CastE(Target)
       if (myHero:CanUseSpell(_E) == READY) then
		CastPosition,  HitChance, HeroPosition = VP:GetLineCastPosition(Target, eDelay, eWidth, eRange, eSpeed, myHero)
		if HitChance >= AhriMenu.combo.accuracyE and GetDistance(CastPosition) <= eRange  then
			local Mcol = Col:GetMinionCollision(myHero, CastPosition)
			if not Mcol then
				CastSpell(_E, CastPosition.x,  CastPosition.z)
end
end
end
end
	
-- Cast R --
function CastR(Target)
	if rReady and ValidTarget(Target, rRange) then 
		CastSpell(_R, mousePos.x, mousePos.z)
	end
end

-- Using Items --
function UseItems(enemy)
	if not enemy then
		enemy = Target
	end
	if Target ~= nil and not Target.dead and ValidTarget(Target, 750) then
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
	if Target ~= nil and not Target.dead and ValidTarget(Target, 1200) then
		if AhriMenu.ks.killsteal then
		        if qReady and Target.health <= qDmg and GetDistance(Target) <= qRange then 
                        CastQ(Target)
                elseif eReady and Target.health <= eDmg and GetDistance(Target) <= eRange then
                        CastE(Target)
                        if charmCheck() then return end
                elseif wReady and Target.health <= wDmg and GetDistance(Target) <= wRange then
                        CastSpell(_W, Target)
                elseif qReady and eReady and Target.health <= (qDmg + eDmg) and GetDistance(Target) <= eRange then
                        CastE(Target)
                        if charmCheck() then return end
                        CastQ(Target)
                elseif qReady and wReady and Target.health <= (qDmg + wDmg) and GetDistance(Target) <= qRange then
                        CastQ(Target)
                        CastSpell(_W, Target)
                elseif eReady and wReady and Target.health <= (eDmg + wDmg) and GetDistance(Target) <= eRange then
                        CastE(Target)
                        if charmCheck() then return end
                        CastSpell(_W, Target)
                elseif qReady and eReady and wReady and Target.health <= (qDmg + eDmg + wDmg) and GetDistance(Target) <= wRange then
                        CastE(Target)
                        if charmCheck() then return end
                        CastQ(Target)
                        CastSpell(_W, Target)
                elseif qReady and eReady and wReady and rReady and Target.health <= (qDmg + eDmg + wDmg + rDmg) and GetDistance(Target) <= rRange then
                        CastE(Target)
                        if charmCheck() then return end
                        CastR(Target) 
                        CastQ(Target)
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

-- Health Function for Auto Zhonyas/Wooglets --
function MyHealthLow()
	if myHero.health < (myHero.maxHealth * ( AhriMenu.misc.ZWHealth / 100)) then
		return true
	else
		return false
	end
end

-- Using Consumables --
function UseConsumables()
	if not InFountain() and not Recalling and Target ~= nil then
		if AhriMenu.misc.aHP and myHero.health < (myHero.maxHealth * (AhriMenu.misc.HPHealth / 100))
			and not (usingHPot or usingFlask) and (hpReady or fskReady)	then
				CastSpell((hpSlot or fskSlot)) 
		end
		if AhriMenu.misc.aMP and myHero.mana < (myHero.maxMana * (AhriMenu.misc.farmMana / 100))
			and not (usingMPot or usingFlask) and (mpReady or fskReady) then
				CastSpell((mpSlot or fskSlot))
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
                  elseif enemy.health <= (qDmg + wDmg) and enemy.health > qDmg and wDmg then
                          KillText[i] = 3
                  elseif enemy.health <= (qDmg + rDmg) and enemy.health > qDmg and rDmg then
                          KillText[i] = 4
                  elseif enemy.health <= (qDmg + eDmg) and enemy.health > qDmg and eDmg then
                          KillText[i] = 5
                  elseif enemy.health <= (qDmg + wDmg + eDmg + rDmg) and enemy.health > qDmg and eDmg and wDmg and rDmg then
                          KillText[i] = 6
                  elseif enemy.health <= (qDmg + wDmg + eDmg + rDmg*3) and enemy.health > qDmg and wDmg and eDmg and rDmg*3 then
                          KillText[i] = 7        
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

function OnGainBuff(unit, buff)
	if unit.isMe then
		if buff.name == "AhriTumble" then
			AhriTumbleActive = true
		end
	end
end

function OnLoseBuff(unit, buff)
	if unit.isMe then
		if buff.name == "AhriTumble" then
			AhriTumbleActive = false
		end
	end
end

function charmCheck()
	Checks()
	if eReady and AhriMenu.combo.RequireCharm then 
		return true
	else
		return false
	end
end

-- Function Ondraw --
function OnDraw()
	-- Ranges --
	if not AhriMenu.drawing.mDraw and not myHero.dead then
		if qReady and AhriMenu.drawing.qDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, qRange, ARGB(255,127,0,110))
		end
		if wReady and AhriMenu.drawing.wDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, wRange, ARGB(255,95,159,159))
		end
		if eReady and AhriMenu.drawing.eDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, eRange, ARGB(255,204,50,50))
		end
		if rReady and AhriMenu.drawing.rDraw then
			DrawCircle(myHero.x, myHero.y, myHero.z, rRange, ARGB(255,69,139,0))
		end
		end

	-- Drawing Texts --
	if AhriMenu.drawing.cDraw then
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
		QPos = ProdictQ:GetPrediction(Target)
		ePos = ProdictE:GetPrediction(Target)
		end
	
	-- Lagfree Circles --
	if AhriMenu.drawing.LfcDraw then
		_G.DrawCircle = DrawCircle2
	end
end	

PrintChat("<font color='#FF1493'> >> JustAhri by Galaxix v1.9 ALPHA Loaded ! <<</font>")
