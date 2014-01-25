--Shyvana Tiem for free users Credits BotHappy - Trees - Galaxix v1.1--
 
--Changelog :
--1.0 - Initial Release
--1.1 - Fixed bugs


if myHero.charName ~= "Shyvana" then return end


local QRange = 125
local WRange = 325
local ERange = 925
local RRange = 1000
local QAble, WAble, EAble, RAble = false, false, false, false
local SkillE = {spellKey = _E, range = ERange, speed = 1.50, delay = 125, width = 80}
local Cast = AutoCarry.CastSkillshot

function PluginOnLoad() 
	AutoCarry.SkillsCrosshair.range = 1100
	PrintChat(" JustShyvana For NonVIPS v1.1 ")
end

function PluginOnTick()
	Checks()
	Menu()
	if Target then
		if AutoCarry.MainMenu.AutoCarry then
			ComboCast()
		end
		if AutoCarry.MainMenu.MixedMode or AutoCarry.PluginMenu.Harrass and EAble then
			Cast(SkillE, Target)
		end
	end
end    

function Checks()
	QAble = (myHero:CanUseSpell(_Q) == READY)
	WAble = (myHero:CanUseSpell(_W) == READY)
	EAble = (myHero:CanUseSpell(_E) == READY)
	RAble = (myHero:CanUseSpell(_R) == READY)
	Target = AutoCarry.GetAttackTarget()
end

function Menu()
	local HKE = string.byte("G")
	AutoCarry.PluginMenu:addParam("useQ", "Use Q in combo", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useW", "Use W in combo", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useE", "Use E in combo", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("useR", "Use R in combo", SCRIPT_PARAM_ONOFF, false)
	AutoCarry.PluginMenu:addParam("drawW", "Draw W Range", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("drawE", "Draw E Range", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("drawR", "Draw R Range", SCRIPT_PARAM_ONOFF, true)
	AutoCarry.PluginMenu:addParam("Harrass", "Harrass with E", SCRIPT_PARAM_ONKEYDOWN, false, HKE)
	AutoCarry.PluginMenu:permaShow("Harrass")
end

function ComboCast()
	if WAble and AutoCarry.PluginMenu.useW then CastSpell(_W) end
	if EAble and AutoCarry.PluginMenu.useE then Cast(SkillE, Target) end
	if QAble and AutoCarry.PluginMenu.useQ then CastSpell(_Q) end
	if RAble and AutoCarry.PluginMenu.useR then CastSpell(_R) end  
end

function PluginOnDraw()
	if not myHero.dead then
		if (WAble or WActive) and AutoCarry.PluginMenu.drawW then
			DrawCircle(myHero.x, myHero.y, myHero.z, WRange, 0x7CFC00)
		end
		if EAble and AutoCarry.PluginMenu.drawE then 
			DrawCircle(myHero.x, myHero.y, myHero.z, ERange, 0x00FFFF)
		end
		if RAble and AutoCarry.PluginMenu.drawR then
			DrawCircle(myHero.x, myHero.y, myHero.z, RRange, 0xFF0000)
		end
	end
end

