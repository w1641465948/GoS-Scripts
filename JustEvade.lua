--[[

	_________                _____ __________                _________      
	______  /____  ____________  /____  ____/___   ________ _______  /_____ 
	___ _  / _  / / /__  ___/_  __/__  __/   __ | / /_  __ `/_  __  / _  _ \
	/ /_/ /  / /_/ / _(__  ) / /_  _  /___   __ |/ / / /_/ / / /_/ /  /  __/
	\____/   \__,_/  /____/  \__/  /_____/   _____/  \__,_/  \__,_/   \___/ 
                                                           Powered by GoS!

	Author: Ark223
	Credits: Gamsteron, Maxxxel, Mad & Noddy

	Changelog:

	v1.0
	+ Initial release of new series

--]]

local function DownloadFile(site, file)
	DownloadFileAsync(site, file, function() end)
	local timer = os.clock()
	while os.clock() < timer + 1 do end
	while not FileExist(path) do end
end

local function ReadFile(file)
	local txt = io.open(file, "r")
	local result = txt:read()
	txt:close(); return result
end

local Version, IntVer = 1.0, "1.0"
local function AutoUpdate()
	DownloadFile("https://github.com/Ark223/GoS-Scripts/blob/master/JustEvade.version", SCRIPT_PATH .. "JustEvade.version")
	if tonumber(ReadFile(SCRIPT_PATH .. "GoS-U Reborn.version")) > Version then
		print("JustEvade: Found update! Downloading...")
		DownloadFile("https://github.com/Ark223/GoS-Scripts/blob/master/JustEvade.lua", SCRIPT_PATH .. "JustEvade.lua")
		print("JustEvade: Successfully updated. Use 2x F6!")
	end
end

local MathAbs, MathAtan, MathAtan2, MathAcos, MathCeil, MathCos, MathDeg, MathFloor, MathHuge, MathMax, MathMin, MathPi, MathRad, MathSin, MathSqrt = math.abs, math.atan, math.atan2, math.acos, math.ceil, math.cos, math.deg, math.floor, math.huge, math.max, math.min, math.pi, math.rad, math.sin, math.sqrt
local GameCanUseSpell, GameLatency, GameTimer, GameHeroCount, GameHero, GameMinionCount, GameMinion, GameMissileCount, GameMissile = Game.CanUseSpell, Game.Latency, Game.Timer, Game.HeroCount, Game.Hero, Game.MinionCount, Game.Minion, Game.MissileCount, Game.Missile
local DrawCircle, DrawColor, DrawLine, DrawText, ControlKeyUp, ControlKeyDown, ControlMouseEvent, ControlSetCursorPos = Draw.Circle, Draw.Color, Draw.Line, Draw.Text, Control.KeyUp, Control.KeyDown, Control.mouse_event, Control.SetCursorPos
local TableInsert, TableRemove, TableSort = table.insert, table.remove, table.sort
local Icons, Png = "https://raw.githubusercontent.com/Ark223/LoL-Icons/master/", ".png"
local FlashIcon = Icons.."Flash"..Png

require 'MapPositionGOS'

local SpellDatabase = {
	["Aatrox"] = {
		["AatroxQ"] = {icon = Icons.."AatroxQ1"..Png, displayName = "The Darkin Blade [First]", slot = "Q", type = "linear", speed = MathHuge, range = 650, delay = 0.6, radius = 130, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["AatroxQ2"] = {icon = Icons.."AatroxQ2"..Png, displayName = "The Darkin Blade [Second]", slot = "Q", type = "polygon", speed = MathHuge, range = 500, delay = 0.6, radius = 200, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["AatroxQ3"] = {icon = Icons.."AatroxQ3"..Png, displayName = "The Darkin Blade [Third]", slot = "Q", type = "circular", speed = MathHuge, range = 200, delay = 0.6, radius = 300, danger = 4, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["AatroxW"] = {icon = Icons.."AatroxW"..Png, displayName = "Infernal Chains", missileName = "AatroxW", slot = "W", type = "linear", speed = 1800, range = 825, delay = 0.25, radius = 80, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Ahri"] = {
		["AhriOrbofDeception"] = {icon = Icons.."AhriQ"..Png, missileName = "AhriOrbMissile", displayName = "Orb of Deception", slot = "Q", type = "linear", speed = 2500, range = 880, delay = 0.25, radius = 100, danger = 2, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["AhriSeduce"] = {icon = Icons.."AhriE"..Png, displayName = "Seduce",  missileName = "AhriSeduceMissile", slot = "E", type = "linear", speed = 1500, range = 975, delay = 0.25, radius = 60, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Akali"] = {
		["AkaliQ"] = {icon = Icons.."AkaliQ"..Png, displayName = "Five Point Strike", slot = "Q", type = "conic", speed = 3200, range = 550, delay = 0.25, radius = 60, angle = 45, danger = 2, cc = false, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
		["AkaliE"] = {icon = Icons.."AkaliE"..Png, displayName = "Shuriken Flip", missileName = "AkaliEMis", slot = "E", type = "linear", speed = 1800, range = 825, delay = 0.25, radius = 70, danger = 2, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["AkaliR"] = {icon = Icons.."AkaliR1"..Png, displayName = "Perfect Execution [First]", slot = "R", type = "linear", speed = 1800, range = 525, delay = 0, radius = 65, danger = 4, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["AkaliRb"] = {icon = Icons.."AkaliR2"..Png, displayName = "Perfect Execution [Second]", slot = "R", type = "linear", speed = 3600, range = 525, delay = 0, radius = 65, danger = 4, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Alistar"] = {
		["Pulverize"] = {icon = Icons.."AlistarQ"..Png, displayName = "Pulverize", slot = "Q", type = "circular", speed = MathHuge, range = 0, delay = 0.25, radius = 365, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Amumu"] = {
		["BandageToss"] = {icon = Icons.."AmumuQ"..Png, displayName = "Bandage Toss", missileName = "SadMummyBandageToss", slot = "Q", type = "linear", speed = 2000, range = 1100, delay = 0.25, radius = 80, danger = 3, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
		["CurseoftheSadMummy"] = {icon = Icons.."AmumuR"..Png, displayName = "Curse of the Sad Mummy", slot = "R", type = "circular", speed = MathHuge, range = 0, delay = 0.25, radius = 550, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Anivia"] = {
		["FlashFrostSpell"] = {icon = Icons.."AniviaQ"..Png, displayName = "Flash Frost", missileName = "FlashFrostSpell", slot = "Q", type = "linear", speed = 850, range = 1100, delay = 0.25, radius = 110, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Annie"] = {
		["AnnieW"] = {icon = Icons.."AnnieW"..Png, displayName = "Incinerate", slot = "W", type = "conic", speed = MathHuge, range = 600, delay = 0.25, radius = 0, angle = 50, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["AnnieR"] = {icon = Icons.."AnnieR"..Png, displayName = "Summon: Tibbers", slot = "R", type = "circular", speed = MathHuge, range = 600, delay = 0.25, radius = 290, danger = 5, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Ashe"] = {
		["Volley"] = {icon = Icons.."AsheW"..Png, displayName = "Volley", missileName = "VolleyRightAttack", slot = "W", type = "conic", speed = 2000, range = 1200, delay = 0.25, radius = 20, angle = 40, danger = 2, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
		["EnchantedCrystalArrow"] = {icon = Icons.."AsheR"..Png, displayName = "Enchanted Crystal Arrow", missileName = "EnchantedCrystalArrow", slot = "R", type = "linear", speed = 1600, range = 12500, delay = 0.25, radius = 130, danger = 4, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["AurelionSol"] = {
		["AurelionSolQ"] = {icon = Icons.."AurelionSolQ"..Png, displayName = "Starsurge", missileName = "AurelionSolQMissile", slot = "Q", type = "linear", speed = 850, range = 1075, delay = 0, radius = 110, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["AurelionSolR"] = {icon = Icons.."AurelionSolR"..Png, displayName = "Voice of Light", slot = "R", type = "linear", speed = 4500, range = 1500, delay = 0.35, radius = 120, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Azir"] = {
		["AzirR"] = {icon = Icons.."AzirR"..Png, displayName = "Emperor's Divide", slot = "R", type = "linear", speed = 1400, range = 500, delay = 0.3, radius = 250, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Bard"] = {
		["BardQ"] = {icon = Icons.."BardQ"..Png, displayName = "Cosmic Binding", missileName = "BardQMissile", slot = "Q", type = "linear", speed = 1500, range = 950, delay = 0.25, radius = 60, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["BardR"] = {icon = Icons.."BardR"..Png, displayName = "Tempered Fate", missileName = "BardRMissile", slot = "R", type = "circular", speed = 2100, range = 3400, delay = 0.5, radius = 350, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = true, exception = false},
	},
	["Blitzcrank"] = {
		["RocketGrab"] = {icon = Icons.."BlitzcrankQ"..Png, displayName = "Rocket Grab", missileName = "RocketGrabMissile", slot = "Q", type = "linear", speed = 1800, range = 925, delay = 0.25, radius = 70, danger = 3, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["StaticField"] = {icon = Icons.."BlitzcrankR"..Png, displayName = "Static Field", slot = "R", type = "circular", speed = MathHuge, range = 0, delay = 0.25, radius = 600, danger = 4, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Brand"] = {
		["BrandQ"] = {icon = Icons.."BrandQ"..Png, displayName = "Sear", missileName = "BrandQMissile", slot = "Q", type = "linear", speed = 1600, range = 1050, delay = 0.25, radius = 60, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["BrandW"] = {icon = Icons.."BrandW"..Png, displayName = "Pillar of Flame", slot = "W", type = "circular", speed = MathHuge, range = 900, delay = 0.85, radius = 250, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Braum"] = {
		["BraumQ"] = {icon = Icons.."BraumQ"..Png, displayName = "Winter's Bite", missileName = "BraumQMissile", slot = "Q", type = "linear", speed = 1700, range = 1000, delay = 0.25, radius = 70, danger = 3, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["BraumR"] = {icon = Icons.."BraumR"..Png, displayName = "Glacial Fissure", missileName = "BraumRMissile", slot = "R", type = "linear", speed = 1400, range = 1250, delay = 0.5, radius = 115, danger = 4, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Caitlyn"] = {
		["CaitlynPiltoverPeacemaker"] = {icon = Icons.."CaitlynQ"..Png, displayName = "Piltover Peacemaker", missileName = "CaitlynPiltoverPeacemaker", slot = "Q", type = "linear", speed = 2200, range = 1250, delay = 0.625, radius = 90, danger = 1, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["CaitlynYordleTrap"] = {icon = Icons.."CaitlynW"..Png, displayName = "Yordle Trap", slot = "W", type = "circular", speed = MathHuge, range = 800, delay = 0.35, radius = 75, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["CaitlynEntrapment"] = {icon = Icons.."CaitlynE"..Png, displayName = "Entrapment", missileName = "CaitlynEntrapment", slot = "E", type = "linear", speed = 1600, range = 750, delay = 0.15, radius = 70, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Camille"] = {
		["CamilleE"] = {icon = Icons.."CamilleE1"..Png, displayName = "Hookshot [First]", missileName = "CamilleEMissile", slot = "E", type = "linear", speed = 1900, range = 800, delay = 0, radius = 60, danger = 1, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["CamilleEDash2"] = {icon = Icons.."CamilleE2"..Png, displayName = "Hookshot [Second]", slot = "E", type = "linear", speed = 1900, range = 400, delay = 0, radius = 60, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
	},
	["Cassiopeia"] = {
		["CassiopeiaQ"] = {icon = Icons.."CassiopeiaQ"..Png, displayName = "Noxious Blast", slot = "Q", type = "circular", speed = MathHuge, range = 850, delay = 0.75, radius = 150, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["CassiopeiaW"] = {icon = Icons.."CassiopeiaW"..Png, displayName = "Miasma", slot = "W", type = "circular", speed = 2500, range = 800, delay = 0.75, radius = 160, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
		["CassiopeiaR"] = {icon = Icons.."CassiopeiaR"..Png, displayName = "Petrifying Gaze", slot = "R", type = "conic", speed = MathHuge, range = 825, delay = 0.5, radius = 0, angle = 80, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Chogath"] = {
		["Rupture"] = {icon = Icons.."ChogathQ"..Png, displayName = "Rupture", slot = "Q", type = "circular", speed = MathHuge, range = 950, delay = 1.2, radius = 250, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["FeralScream"] = {icon = Icons.."ChogathW"..Png, displayName = "Feral Scream", slot = "W", type = "conic", speed = MathHuge, range = 650, delay = 0.5, radius = 0, angle = 56, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Corki"] = {
		["PhosphorusBomb"] = {icon = Icons.."CorkiQ"..Png, displayName = "Phosphorus Bomb", missileName = "PhosphorusBombMissile", slot = "Q", type = "circular", speed = 1000, range = 825, delay = 0.25, radius = 250, danger = 2, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["MissileBarrageMissile"] = {icon = Icons.."CorkiR1"..Png, displayName = "Missile Barrage [Standard]", missileName = "MissileBarrageMissile", slot = "R", type = "linear", speed = 2000, range = 1300, delay = 0.175, radius = 40, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["MissileBarrageMissile2"] = {icon = Icons.."CorkiR2"..Png, displayName = "Missile Barrage [Big]", missileName = "MissileBarrageMissile2", slot = "R", type = "linear", speed = 2000, range = 1500, delay = 0.175, radius = 40, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Diana"] = {
		["DianaQ"] = {icon = Icons.."DianaQ"..Png, displayName = "Crescent Strike", slot = "Q", type = "circular", speed = 1900, range = 900, delay = 0.25, radius = 185, danger = 2, cc = false, collision = true, windwall = true, hitbox = false, fow = false, exception = false},
	},
	["Draven"] = {
		["DravenDoubleShot"] = {icon = Icons.."DravenE"..Png, displayName = "Double Shot", missileName = "DravenDoubleShotMissile", slot = "E", type = "linear", speed = 1600, range = 1050, delay = 0.25, radius = 130, danger = 3, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["DravenRCast"] = {icon = Icons.."DravenR"..Png, displayName = "Whirling Death", slot = "R", type = "linear", speed = 2000, range = 12500, delay = 0.25, radius = 160, danger = 4, cc = false, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
	},
	["DrMundo"] = {
		["InfectedCleaverMissile"] = {icon = Icons.."DrMundoQ"..Png, displayName = "Infected Cleaver", missileName = "InfectedCleaverMissile", slot = "Q", type = "linear", speed = 2000, range = 975, delay = 0.25, radius = 60, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Ekko"] = {
		["EkkoQ"] = {icon = Icons.."EkkoQ"..Png, displayName = "Timewinder", missileName = "EkkoQMis", slot = "Q", type = "linear", speed = 1650, range = 1175, delay = 0.25, radius = 60, danger = 1, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["EkkoW"] = {icon = Icons.."EkkoW"..Png, displayName = "Parallel Convergence", slot = "W", type = "circular", speed = MathHuge, range = 1600, delay = 3.35, radius = 400, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Elise"] = {
		["EliseHumanE"] = {icon = Icons.."EliseE"..Png, displayName = "Cocoon", missileName = "EliseHumanE", slot = "E", type = "linear", speed = 1600, range = 1075, delay = 0.25, radius = 55, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Evelynn"] = {
		["EvelynnQ"] = {icon = Icons.."EvelynnQ"..Png, displayName = "Hate Spike", missileName = "EvelynnQ", slot = "Q", type = "linear", speed = 2400, range = 800, delay = 0.25, radius = 60, danger = 2, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["EvelynnR"] = {icon = Icons.."EvelynnR"..Png, displayName = "Last Caress", slot = "R", type = "conic", speed = MathHuge, range = 450, delay = 0.35, radius = 180, angle = 180, danger = 5, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Ezreal"] = {
		["EzrealQ"] = {icon = Icons.."EzrealQ"..Png, displayName = "Mystic Shot", missileName = "EzrealQ", slot = "Q", type = "linear", speed = 2000, range = 1150, delay = 0.25, radius = 60, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["EzrealW"] = {icon = Icons.."EzrealW"..Png, displayName = "Essence Flux", missileName = "EzrealW", slot = "W", type = "linear", speed = 2000, range = 1150, delay = 0.25, radius = 60, danger = 1, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["EzrealR"] = {icon = Icons.."EzrealR"..Png, displayName = "Trueshot Barrage", missileName = "EzrealR", slot = "R", type = "linear", speed = 2000, range = 12500, delay = 1, radius = 160, danger = 4, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Fiora"] = {
		["FioraW"] = {icon = Icons.."FioraW"..Png, displayName = "Riposte", slot = "W", type = "linear", speed = 3200, range = 750, delay = 0.75, radius = 70, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
	},
	["Fizz"] = {
		["FizzR"] = {icon = Icons.."FizzR"..Png, displayName = "Chum the Waters", missileName = "FizzRMissile", slot = "R", type = "linear", speed = 1300, range = 1300, delay = 0.25, radius = 150, danger = 5, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Galio"] = {
		["GalioQ"] = {icon = Icons.."GalioQ"..Png, displayName = "Winds of War", missileName = "GalioQMissile", slot = "Q", type = "circular", speed = 1150, range = 825, delay = 0.25, radius = 235, danger = 2, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["GalioE"] = {icon = Icons.."GalioE"..Png, displayName = "Justice Punch", slot = "E", type = "linear", speed = 2300, range = 650, delay = 0.4, radius = 160, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Gnar"] = {
		["GnarQMissile"] = {icon = Icons.."GnarQMini"..Png, displayName = "Boomerang Throw", missileName = "GnarQMissile", slot = "Q", type = "linear", speed = 2500, range = 1125, delay = 0.25, radius = 55, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["GnarBigQMissile"] = {icon = Icons.."GnarQMega"..Png, displayName = "Boulder Toss", missileName = "GnarBigQMissile", slot = "Q", type = "linear", speed = 2100, range = 1125, delay = 0.5, radius = 90, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["GnarBigW"] = {icon = Icons.."GnarWMega"..Png, displayName = "Wallop", slot = "W", type = "linear", speed = MathHuge, range = 575, delay = 0.6, radius = 100, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		--["GnarE"] = {icon = Icons.."GnarEMini"..Png, displayName = "Hop", slot = "E", type = "circular", speed = 900, range = 475, delay = 0.25, radius = 160, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		--["GnarBigE"] = {icon = Icons.."GnarEMega"..Png, displayName = "Crunch", slot = "E", type = "circular", speed = 800, range = 600, delay = 0.25, radius = 375, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["GnarR"] = {icon = Icons.."GnarR"..Png, displayName = "GNAR!", slot = "R", type = "circular", speed = MathHuge, range = 0, delay = 0.25, radius = 475, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Gragas"] = {
		["GragasQ"] = {icon = Icons.."GragasQ"..Png, displayName = "Barrel Roll", missileName = "GragasQMissile", slot = "Q", type = "circular", speed = 1000, range = 850, delay = 0.25, radius = 275, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		--["GragasE"] = {icon = Icons.."GragasE"..Png, displayName = "Body Slam", slot = "E", type = "linear", speed = 900, range = 600, delay = 0.25, radius = 170, danger = 2, cc = true, collision = true, windwall = false, hitbox = false, fow = false, exception = false},
		["GragasR"] = {icon = Icons.."GragasR"..Png, displayName = "Explosive Cask", missileName = "GragasRBoom", slot = "R", type = "circular", speed = 1800, range = 1000, delay = 0.25, radius = 400, danger = 5, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Graves"] = {
		["GravesQLineSpell"] = {icon = Icons.."GravesQ"..Png, displayName = "End of the Line", slot = "Q", type = "polygon", speed = MathHuge, range = 800, delay = 1.4, radius = 20, danger = 1, cc = false, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
		["GravesSmokeGrenade"] = {icon = Icons.."GravesW"..Png, displayName = "Smoke Grenade", missileName = "GravesSmokeGrenadeBoom", slot = "W", type = "circular", speed = 1500, range = 950, delay = 0.15, radius = 250, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["GravesChargeShot"] = {icon = Icons.."GravesR"..Png, displayName = "Charge Shot", missileName = "GravesChargeShotShot", slot = "R", type = "polygon", speed = 2100, range = 1000, delay = 0.25, radius = 100, danger = 5, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Hecarim"] = {
		["HecarimUlt"] = {icon = Icons.."HecarimR"..Png, displayName = "Onslaught of Shadows", missileName = "HecarimUltMissile", slot = "R", type = "linear", speed = 1100, range = 1650, delay = 0.2, radius = 280, danger = 4, cc = true, collision = false, windwall = false, hitbox = false, fow = true, exception = false},
	},
	["Heimerdinger"] = {
		["HeimerdingerW"] = {icon = Icons.."HeimerdingerW"..Png, displayName = "Hextech Micro-Rockets", slot = "W", type = "linear", speed = 2050, range = 1325, delay = 0.25, radius = 100, danger = 2, cc = false, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
		["HeimerdingerE"] = {icon = Icons.."HeimerdingerE1"..Png, displayName = "CH-2 Electron Storm Grenade", missileName = "HeimerdingerESpell", slot = "E", type = "circular", speed = 1200, range = 970, delay = 0.25, radius = 250, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["HeimerdingerEUlt"] = {icon = Icons.."HeimerdingerE2"..Png, displayName = "CH-2 Electron Storm Grenade [Ult]", missileName = "HeimerdingerESpell_ult", slot = "E", type = "circular", speed = 1200, range = 970, delay = 0.25, radius = 250, danger = 3, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Illaoi"] = {
		["IllaoiQ"] = {icon = Icons.."IllaoiQ"..Png, displayName = "Tentacle Smash", slot = "Q", type = "linear", speed = MathHuge, range = 850, delay = 0.75, radius = 100, danger = 2, cc = false, collision = true, windwall = false, hitbox = false, fow = false, exception = false},
		["IllaoiE"] = {icon = Icons.."IllaoiE"..Png, displayName = "Test of Spirit", missileName = "IllaoiEMis", slot = "E", type = "linear", speed = 1900, range = 900, delay = 0.25, radius = 50, danger = 1, cc = false, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Irelia"] = {
		["IreliaW2"] = {icon = Icons.."IreliaW"..Png, displayName = "Defiant Dance", slot = "W", type = "linear", speed = MathHuge, range = 825, delay = 0.25, radius = 120, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		--["IreliaEParticleMissile"] = {icon = Icons.."IreliaE"..Png, displayName = "Flawless Duet", missileName = "IreliaEParticleMissile", slot = "E", type = "linear", speed = MathHuge, range = 1550, delay = 0.5, radius = 70, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = true, exception = true},
		["IreliaR"] = {icon = Icons.."IreliaR"..Png, displayName = "Vanguard's Edge", missileName = "IreliaR", slot = "R", type = "linear", speed = 2000, range = 950, delay = 0.4, radius = 160, danger = 4, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Ivern"] = {
		["IvernQ"] = {icon = Icons.."IvernQ"..Png, displayName = "Rootcaller", missileName = "IvernQ", slot = "Q", type = "linear", speed = 1300, range = 1075, delay = 0.25, radius = 80, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Janna"] = {
		["HowlingGaleSpell"] = {icon = Icons.."JannaQ"..Png, displayName = "Howling Gale", missileName = "HowlingGaleSpell", slot = "Q", type = "linear", speed = 667, range = 1750, radius = 100, danger = 2, cc = true, collision = false, windwall = true, fow = true, exception = true},
	},
	["JarvanIV"] = {
		["JarvanIVDragonStrike"] = {icon = Icons.."JarvanIVQ"..Png, displayName = "Dragon Strike", slot = "Q", type = "linear", speed = MathHuge, range = 770, delay = 0.4, radius = 70, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["JarvanIVDemacianStandard"] = {icon = Icons.."JarvanIVE"..Png, displayName = "Demacian Standard", slot = "E", type = "circular", speed = 3440, range = 860, delay = 0, radius = 175, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Jayce"] = {
		["JayceShockBlast"] = {icon = Icons.."JayceQ"..Png, displayName = "Shock Blast", missileName = "JayceShockBlastMis", slot = "Q", type = "linear", speed = 1450, range = 1050, delay = 0.214, radius = 70, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Jhin"] = {
		["JhinW"] = {icon = Icons.."JhinW"..Png, displayName = "Deadly Flourish", slot = "W", type = "linear", speed = 5000, range = 2550, delay = 0.75, radius = 40, danger = 1, cc = true, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
		["JhinE"] = {icon = Icons.."JhinE"..Png, displayName = "Captive Audience", missileName = "JhinETrap", slot = "E", type = "circular", speed = 1600, range = 750, delay = 0.25, radius = 130, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = true, exception = false},
		["JhinRShot"] = {icon = Icons.."JhinR"..Png, displayName = "Curtain Call", missileName = "JhinRShotMis", slot = "R", type = "linear", speed = 5000, range = 3500, delay = 0.25, radius = 80, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = true},
	},
	["Jinx"] = {
		["JinxWMissile"] = {icon = Icons.."JinxW"..Png, displayName = "Zap!", missileName = "JinxWMissile", slot = "W", type = "linear", speed = 3300, range = 1450, delay = 0.6, radius = 60, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		--["JinxE"] = {icon = Icons.."JinxE"..Png, displayName = "Flame Chompers!", missileName = "JinxEHit", slot = "E", type = "polygon", speed = 1100, range = 900, delay = 1.5, radius = 120, danger = 1, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["JinxR"] = {icon = Icons.."JinxR"..Png, displayName = "Super Mega Death Rocket!", missileName = "JinxR", slot = "R", type = "linear", speed = 1700, range = 12500, delay = 0.6, radius = 140, danger = 4, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Kaisa"] = {
		["KaisaW"] = {icon = Icons.."KaisaW"..Png, displayName = "Void Seeker", missileName = "KaisaW", slot = "W", type = "linear", speed = 1750, range = 3000, delay = 0.4, radius = 100, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Kalista"] = {
		["KalistaMysticShot"] = {icon = Icons.."KalistaQ"..Png, displayName = "Pierce", missileName = "KalistaMysticShotMisTrue", slot = "Q", type = "linear", speed = 2400, range = 1150, delay = 0.25, radius = 40, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Karma"] = {
		["KarmaQ"] = {icon = Icons.."KarmaQ1"..Png, displayName = "Inner Flame", missileName = "KarmaQMissile", slot = "Q", type = "linear", speed = 1700, range = 950, delay = 0.25, radius = 60, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["KarmaQMantra"] = {icon = Icons.."KarmaQ2"..Png, displayName = "Inner Flame [Mantra]", missileName = "KarmaQMissileMantra", slot = "Q", type = "linear", speed = 1700, range = 950, delay = 0.25, radius = 80, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Karthus"] = {
		["KarthusLayWasteA1"] = {icon = Icons.."KarthusQ"..Png, displayName = "Lay Waste [1]", slot = "Q", type = "circular", speed = MathHuge, range = 875, delay = 0.9, radius = 175, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["KarthusLayWasteA2"] = {icon = Icons.."KarthusQ"..Png, displayName = "Lay Waste [2]", slot = "Q", type = "circular", speed = MathHuge, range = 875, delay = 0.9, radius = 175, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["KarthusLayWasteA3"] = {icon = Icons.."KarthusQ"..Png, displayName = "Lay Waste [3]", slot = "Q", type = "circular", speed = MathHuge, range = 875, delay = 0.9, radius = 175, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Kassadin"] = {
		["ForcePulse"] = {icon = Icons.."KassadinE"..Png, displayName = "Force Pulse", slot = "E", type = "conic", speed = MathHuge, range = 600, delay = 0.3, radius = 0, angle = 80, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["RiftWalk"] = {icon = Icons.."KassadinR"..Png, displayName = "Rift Walk", slot = "R", type = "circular", speed = MathHuge, range = 500, delay = 0.25, radius = 250, danger = 3, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Kayle"] = {
		["KayleQ"] = {icon = Icons.."KayleQ"..Png, displayName = "Radiant Blast", missileName = "KayleQMis", slot = "Q", type = "linear", speed = 1600, range = 900, delay = 0.25, radius = 60, danger = 1, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Kayn"] = {
		--["KaynQ"] = {icon = Icons.."KaynQ"..Png, displayName = "Reaping Slash", slot = "Q", type = "circular", speed = MathHuge, range = 0, delay = 0.15, radius = 350, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["KaynW"] = {icon = Icons.."KaynW"..Png, displayName = "Blade's Reach", slot = "W", type = "linear", speed = MathHuge, range = 700, delay = 0.55, radius = 90, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Kennen"] = {
		["KennenShurikenHurlMissile1"] = {icon = Icons.."KennenQ"..Png, displayName = "Shuriken Hurl", missileName = "KennenShurikenHurlMissile1", slot = "Q", type = "linear", speed = 1700, range = 1050, delay = 0.175, radius = 50, danger = 2, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Khazix"] = {
		["KhazixW"] = {icon = Icons.."KhazixW1"..Png, displayName = "Void Spike [Standard]", missileName = "KhazixWMissile", slot = "W", type = "linear", speed = 1700, range = 1000, delay = 0.25, radius = 70, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["KhazixWLong"] = {icon = Icons.."KhazixW2"..Png, displayName = "Void Spike [Threeway]", slot = "W", type = "threeway", speed = 1700, range = 1000, delay = 0.25, radius = 70, angle = 23, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = false, exception = false},
	},
	["Kled"] = {
		["KledQ"] = {icon = Icons.."KledQMount"..Png, displayName = "Beartrap on a Rope", missileName = "KledQMissile", slot = "Q", type = "linear", speed = 1600, range = 800, delay = 0.25, radius = 45, danger = 1, cc = true, collision = false, windwall = true, fow = true, exception = false},
		["KledRiderQ"] = {icon = Icons.."KledQDismount"..Png, displayName = "Pocket Pistol", missileName = "KledRiderQMissile", slot = "Q", type = "conic", speed = 3000, range = 700, delay = 0.25, radius = 0, angle = 25, danger = 3, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		--["KledEDash"] = {icon = Icons.."KledE"..Png, displayName = "Jousting", slot = "E", type = "linear", speed = 1100, range = 550, delay = 0, radius = 90, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["KogMaw"] = {
		["KogMawQ"] = {icon = Icons.."KogMawQ"..Png, displayName = "Caustic Spittle", missileName = "KogMawQ", slot = "Q", type = "linear", speed = 1650, range = 1175, delay = 0.25, radius = 70, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["KogMawVoidOozeMissile"] = {icon = Icons.."KogMawE"..Png, displayName = "Void Ooze", missileName = "KogMawVoidOozeMissile", slot = "E", type = "linear", speed = 1400, range = 1360, delay = 0.25, radius = 120, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["KogMawLivingArtillery"] = {icon = Icons.."KogMawR"..Png, displayName = "Living Artillery", slot = "R", type = "circular", speed = MathHuge, range = 1300, delay = 1.1, radius = 200, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Leblanc"] = {
		["LeblancE"] = {icon = Icons.."LeblancE"..Png, displayName = "Ethereal Chains [Standard]", missileName = "LeblancEMissile", slot = "E", type = "linear", speed = 1750, range = 925, delay = 0.25, radius = 55, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["LeblancRE"] = {icon = Icons.."LeblancRE"..Png, displayName = "Ethereal Chains [Ultimate]", missileName = "LeblancREMissile", slot = "E", type = "linear", speed = 1750, range = 925, delay = 0.25, radius = 55, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["LeeSin"] = {
		["BlindMonkQOne"] = {icon = Icons.."LeeSinQ"..Png, displayName = "Sonic Wave", missileName = "BlindMonkQOne", slot = "Q", type = "linear", speed = 1800, range = 1100, delay = 0.25, radius = 60, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Leona"] = {
		["LeonaZenithBlade"] = {icon = Icons.."LeonaE"..Png, displayName = "Zenith Blade", missileName = "LeonaZenithBladeMissile", slot = "E", type = "linear", speed = 2000, range = 875, delay = 0.25, radius = 70, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["LeonaSolarFlare"] = {icon = Icons.."LeonaR"..Png, displayName = "Solar Flare", slot = "R", type = "circular", speed = MathHuge, range = 1200, delay = 0.85, radius = 300, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Lissandra"] = {
		["LissandraQMissile"] = {icon = Icons.."LissandraQ"..Png, displayName = "Ice Shard", missileName = "LissandraQMissile", slot = "Q", type = "linear", speed = 2200, range = 750, delay = 0.25, radius = 75, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["LissandraEMissile"] = {icon = Icons.."LissandraE"..Png, displayName = "Glacial Path", missileName = "LissandraEMissile", slot = "E", type = "linear", speed = 850, range = 1025, delay = 0.25, radius = 125, danger = 2, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Lucian"] = {
		["LucianQ"] = {icon = Icons.."LucianQ"..Png, displayName = "Piercing Light", slot = "Q", type = "linear", speed = MathHuge, range = 900, delay = 0.35, radius = 65, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["LucianW"] = {icon = Icons.."LucianW"..Png, displayName = "Ardent Blaze", missileName = "LucianW", slot = "W", type = "linear", speed = 1600, range = 900, delay = 0.25, radius = 80, danger = 2, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Lulu"] = {
		["LuluQ"] = {icon = Icons.."LuluQ"..Png, displayName = "Glitterlance", missileName = "LuluQMissile", slot = "Q", type = "linear", speed = 1450, range = 925, delay = 0.25, radius = 60, danger = 1, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Lux"] = {
		["LuxLightBinding"] = {icon = Icons.."LuxQ"..Png, displayName = "Light Binding", missileName = "LuxLightBindingDummy", slot = "Q", type = "linear", speed = 1200, range = 1175, delay = 0.25, radius = 70, danger = 1, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["LuxLightStrikeKugel"] = {icon = Icons.."LuxE"..Png, displayName = "Light Strike Kugel", missileName = "LuxLightStrikeKugel", slot = "E", type = "circular", speed = 1200, range = 1100, delay = 0.25, radius = 300, danger = 3, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
		["LuxMaliceCannon"] = {icon = Icons.."LuxR"..Png, displayName = "Malice Cannon", missileName = "LuxRVfxMis", slot = "R", type = "linear", speed = MathHuge, range = 3340, delay = 1, radius = 120, danger = 4, cc = false, collision = false, windwall = false, hitbox = false, fow = true, exception = false},
	},
	["Malphite"] = {
		["Landslide"] = {icon = Icons.."MalphiteE"..Png, displayName = "Ground Slam", slot = "E", type = "circular", speed = MathHuge, range = 0, delay = 0.242, radius = 400, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		--["UFSlash"] = {icon = Icons.."MalphiteR"..Png, displayName = "Unstoppable Force", slot = "R", type = "circular", speed = 1835, range = 1000, delay = 0, radius = 300, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Malzahar"] = {
		["MalzaharQ"] = {icon = Icons.."MalzaharQ"..Png, displayName = "Call of the Void", slot = "Q", type = "rectangular", speed = 1600, range = 900, delay = 0.5, radius = 100, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Maokai"] = {
		["MaokaiQ"] = {icon = Icons.."MaokaiQ"..Png, displayName = "Bramble Smash", missileName = "MaokaiQMissile", slot = "Q", type = "linear", speed = 1600, range = 600, delay = 0.375, radius = 110, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["MissFortune"] = {
		["MissFortuneBulletTime"] = {icon = Icons.."MissFortuneR"..Png, displayName = "Bullet Time", slot = "R", type = "conic", speed = 2000, range = 1400, delay = 0.25, radius = 100, angle = 34, danger = 4, cc = false, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
	},
	["Mordekaiser"] = {
		["MordekaiserQ"] = {icon = Icons.."MordekaiserQ"..Png, displayName = "Obliterate", slot = "Q", type = "polygon", speed = MathHuge, range = 675, delay = 0.4, radius = 200, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["MordekaiserE"] = {icon = Icons.."MordekaiserE"..Png, displayName = "Death's Grasp", slot = "E", type = "polygon", speed = MathHuge, range = 900, delay = 0.9, radius = 140, danger = 3, cc = true, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
	},
	["Morgana"] = {
		["MorganaQ"] = {icon = Icons.."MorganaQ"..Png, displayName = "Dark Binding", missileName = "MorganaQ", slot = "Q", type = "linear", speed = 1200, range = 1250, delay = 0.25, radius = 70, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Nami"] = {
		["NamiQ"] = {icon = Icons.."NamiQ"..Png, displayName = "Aqua Prison", missileName = "NamiQMissile", slot = "Q", type = "circular", speed = MathHuge, range = 875, delay = 1, radius = 180, danger = 1, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["NamiRMissile"] = {icon = Icons.."NamiR"..Png, displayName = "Tidal Wave", missileName = "NamiRMissile", slot = "R", type = "linear", speed = 850, range = 2750, delay = 0.5, radius = 250, danger = 3, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Nautilus"] = {
		["NautilusAnchorDragMissile"] = {icon = Icons.."NautilusQ"..Png, displayName = "Dredge Line", missileName = "NautilusAnchorDragMissile", slot = "Q", type = "linear", speed = 2000, range = 925, delay = 0.25, radius = 90, danger = 3, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Neeko"] = {
		["NeekoQ"] = {icon = Icons.."NeekoQ"..Png, displayName = "Blooming Burst", missileName = "NeekoQ", slot = "Q", type = "circular", speed = 1500, range = 800, delay = 0.25, radius = 200, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["NeekoE"] = {icon = Icons.."NeekoE"..Png, displayName = "Tangle-Barbs", missileName = "NeekoE", slot = "E", type = "linear", speed = 1300, range = 1000, delay = 0.25, radius = 70, danger = 1, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Nidalee"] = {
		["JavelinToss"] = {icon = Icons.."NidaleeQ"..Png, displayName = "Javelin Toss", missileName = "JavelinToss", slot = "Q", type = "linear", speed = 1300, range = 1500, delay = 0.25, radius = 40, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["Bushwhack"] = {icon = Icons.."NidaleeW"..Png, displayName = "Bushwhack", slot = "W", type = "circular", speed = MathHuge, range = 900, delay = 1.25, radius = 85, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["Swipe"] = {icon = Icons.."NidaleeE"..Png, displayName = "Swipe", slot = "E", type = "conic", speed = MathHuge, range = 350, delay = 0.25, radius = 0, angle = 180, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Nocturne"] = {
		["NocturneDuskbringer"] = {icon = Icons.."NocturneQ"..Png, displayName = "Duskbringer", missileName = "NocturneDuskbringer", slot = "Q", type = "linear", speed = 1600, range = 1200, delay = 0.25, radius = 60, danger = 2, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Nunu"] = {
		["NunuR"] = {icon = Icons.."NunuR"..Png, displayName = "Absolute Zero", slot = "R", type = "circular", speed = MathHuge, range = 0, delay = 3, radius = 650, danger = 5, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Olaf"] = {
		["OlafAxeThrowCast"] = {icon = Icons.."OlafQ"..Png, displayName = "Undertow", missileName = "OlafAxeThrow", slot = "Q", type = "linear", speed = 1600, range = 1000, delay = 0.25, radius = 90, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Orianna"] = {
		["OrianaIzuna"] = {icon = Icons.."OriannaQ"..Png, displayName = "Command: Attack", missileName = "OrianaIzuna", slot = "Q", type = "polygon", speed = 1400, range = 825, radius = 80, danger = 2, cc = false, collision = false, windwall = false, fow = true, exception = true},
	},
	["Ornn"] = {
		["OrnnQ"] = {icon = Icons.."OrnnQ"..Png, displayName = "Volcanic Rupture", slot = "Q", type = "linear", speed = 1800, range = 800, delay = 0.3, radius = 65, danger = 1, cc = true, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
		["OrnnE"] = {icon = Icons.."OrnnE"..Png, displayName = "Searing Charge", slot = "E", type = "linear", speed = 1800, range = 800, delay = 0.35, radius = 150, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["OrnnRCharge"] = {icon = Icons.."OrnnR"..Png, displayName = "Call of the Forge God", slot = "R", type = "linear", speed = 1650, range = 2500, delay = 0.5, radius = 200, danger = 3, cc = true, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
	},
	["Pantheon"] = {
		["PantheonQTap"] = {icon = Icons.."PantheonQ"..Png, displayName = "Comet Spear [Melee]", slot = "Q", type = "linear", speed = MathHuge, range = 575, delay = 0.25, radius = 80, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["PantheonQMissile"] = {icon = Icons.."PantheonQ"..Png, displayName = "Comet Spear [Range]", missileName = "PantheonQMissile", slot = "Q", type = "linear", speed = 2700, range = 1200, delay = 0.25, radius = 60, danger = 2, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
		["PantheonR"] = {icon = Icons.."PantheonR"..Png, displayName = "Grand Starfall", slot = "R", type = "linear", speed = 2250, range = 1350, delay = 4, radius = 250, danger = 3, cc = false, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
	},
	["Poppy"] = {
		["PoppyQSpell"] = {icon = Icons.."PoppyQ"..Png, displayName = "Hammer Shock", slot = "Q", type = "linear", speed = MathHuge, range = 430, delay = 0.332, radius = 100, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["PoppyRSpell"] = {icon = Icons.."PoppyR"..Png, displayName = "Keeper's Verdict", missileName = "PoppyRMissile", slot = "R", type = "linear", speed = 2000, range = 1200, delay = 0.33, radius = 100, danger = 3, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Pyke"] = {
		["PykeQMelee"] = {icon = Icons.."PykeQ"..Png, displayName = "Bone Skewer [Melee]", slot = "Q", type = "linear", speed = MathHuge, range = 400, delay = 0.25, radius = 70, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["PykeQRange"] = {icon = Icons.."PykeQ"..Png, displayName = "Bone Skewer [Range]", missileName = "PykeQRange", slot = "Q", type = "linear", speed = 2000, range = 1100, delay = 0.2, radius = 70, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["PykeE"] = {icon = Icons.."PykeE"..Png, displayName = "Phantom Undertow", slot = "E", type = "linear", speed = 3000, range = 12500, delay = 0, radius = 110, danger = 2, cc = true, collision = false, windwall = false, hitbox = true, fow = false, exception = false},
		["PykeR"] = {icon = Icons.."PykeR"..Png, displayName = "Death from Below", slot = "R", type = "circular", speed = MathHuge, range = 750, delay = 0.5, radius = 100, danger = 5, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Qiyana"] = {
		["QiyanaQ"] = {icon = Icons.."QiyanaQ"..Png, displayName = "Edge of Ixtal", slot = "Q", type = "linear", speed = MathHuge, range = 500, delay = 0.25, radius = 60, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["QiyanaQ_Grass"] = {icon = Icons.."QiyanaQGrass"..Png, displayName = "Edge of Ixtal [Grass]", slot = "Q", type = "linear", speed = 1600, range = 925, delay = 0.25, radius = 70, danger = 2, cc = false, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
		["QiyanaQ_Rock"] = {icon = Icons.."QiyanaQRock"..Png, displayName = "Edge of Ixtal [Rock]", slot = "Q", type = "linear", speed = 1600, range = 925, delay = 0.25, radius = 70, danger = 2, cc = false, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
		["QiyanaQ_Water"] = {icon = Icons.."QiyanaQWater"..Png, displayName = "Edge of Ixtal [Water]", slot = "Q", type = "linear", speed = 1600, range = 925, delay = 0.25, radius = 70, danger = 2, cc = true, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
		["QiyanaR"] = {icon = Icons.."QiyanaR"..Png, displayName = "Supreme Display of Talent", slot = "R", type = "linear", speed = 2000, range = 950, delay = 0.25, radius = 190, danger = 4, cc = true, collision = false, windwall = true, hitbox = true, fow = false, exception = false},
	},
	["Quinn"] = {
		["QuinnQ"] = {icon = Icons.."QuinnQ"..Png, displayName = "Blinding Assault", missileName = "QuinnQ", slot = "Q", type = "linear", speed = 1550, range = 1025, delay = 0.25, radius = 60, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Rakan"] = {
		["RakanQ"] = {icon = Icons.."RakanQ"..Png, displayName = "Gleaming Quill", missileName = "RakanQMis", slot = "Q", type = "linear", speed = 1850, range = 850, delay = 0.25, radius = 65, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
		["RakanW"] = {icon = Icons.."RakanW"..Png, displayName = "Grand Entrance", slot = "W", type = "circular", speed = MathHuge, range = 650, delay = 0.7, radius = 265, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["RekSai"] = {
		["RekSaiQBurrowed"] = {icon = Icons.."RekSaiQ"..Png, displayName = "Prey Seeker", missileName = "RekSaiQBurrowedMis", slot = "Q", type = "linear", speed = 1950, range = 1625, delay = 0.125, radius = 65, danger = 2, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	--["Renekton"] = {
		--["RenektonSliceAndDice"] = {icon = Icons.."RenektonE"..Png, displayName = "Slice and Dice", slot = "E", type = "linear", speed = 1125, range = 450, delay = 0.25, radius = 65, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	--},
	["Rengar"] = {
		["RengarE"] = {icon = Icons.."RengarE"..Png, displayName = "Bola Strike", missileName = "RengarEMis", slot = "E", type = "linear", speed = 1500, range = 1000, delay = 0.25, radius = 70, danger = 1, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Riven"] = {
		["RivenIzunaBlade"] = {icon = Icons.."RivenR"..Png, displayName = "Wind Slash", slot = "R", type = "conic", speed = 1600, range = 900, delay = 0.25, radius = 0, angle = 75, danger = 5, cc = false, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
	},
	["Rumble"] = {
		["RumbleGrenade"] = {icon = Icons.."RumbleE"..Png, displayName = "Electro Harpoon", missileName = "RumbleGrenadeMissile", slot = "E", type = "linear", speed = 2000, range = 850, delay = 0.25, radius = 60, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Ryze"] = {
		["RyzeQ"] = {icon = Icons.."RyzeQ"..Png, displayName = "Overload", missileName = "RyzeQ", slot = "Q", type = "linear", speed = 1700, range = 1000, delay = 0.25, radius = 55, danger = 1, cc = false, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Sejuani"] = {
		["SejuaniR"] = {icon = Icons.."SejuaniR"..Png, displayName = "Glacial Prison", missileName = "SejuaniRMissile", slot = "R", type = "linear", speed = 1600, range = 1300, delay = 0.25, radius = 120, danger = 5, cc = true, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	--["Shen"] = {
		--["ShenE"] = {icon = Icons.."ShenE"..Png, displayName = "Shadow Dash", slot = "E", type = "linear", speed = 1200, range = 600, delay = 0, radius = 60, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	--},
	["Shyvana"] = {
		["ShyvanaFireball"] = {icon = Icons.."ShyvanaE"..Png, displayName = "Flame Breath [Standard]", missileName = "ShyvanaFireballMissile", slot = "E", type = "linear", speed = 1575, range = 925, delay = 0.25, radius = 60, danger = 1, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["ShyvanaFireballDragon2"] = {icon = Icons.."ShyvanaE"..Png, displayName = "Flame Breath [Dragon]", missileName = "ShyvanaFireballDragonMissile", slot = "E", type = "linear", speed = 1575, range = 975, delay = 0.333, radius = 60, danger = 2, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["ShyvanaTransformLeap"] = {icon = Icons.."ShyvanaR"..Png, displayName = "Transform Leap", slot = "R", type = "linear", speed = 700, range = 850, delay = 0.25, radius = 150, danger = 4, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Sion"] = {
		["SionQ"] = {icon = Icons.."SionQ"..Png, displayName = "Decimating Smash", slot = "Q", type = "linear", speed = MathHuge, range = 750, delay = 2, radius = 150, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["SionE"] = {icon = Icons.."SionE"..Png, displayName = "Roar of the Slayer", missileName = "SionEMissile", slot = "E", type = "linear", speed = 1800, range = 800, delay = 0.25, radius = 80, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Sivir"] = {
		["SivirQ"] = {icon = Icons.."SivirQ"..Png, displayName = "Boomerang Blade", missileName = "SivirQMissile", slot = "Q", type = "linear", speed = 1350, range = 1250, delay = 0.25, radius = 90, danger = 2, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Skarner"] = {
		["SkarnerFractureMissile"] = {icon = Icons.."SkarnerE"..Png, displayName = "Fracture", missileName = "SkarnerFractureMissile", slot = "E", type = "linear", speed = 1500, range = 1000, delay = 0.25, radius = 70, danger = 1, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Sona"] = {
		["SonaR"] = {icon = Icons.."SonaR"..Png, displayName = "Crescendo", missileName = "SonaRMissile", slot = "R", type = "linear", speed = 2400, range = 1000, delay = 0.25, radius = 140, danger = 5, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Soraka"] = {
		["SorakaQ"] = {icon = Icons.."SorakaQ"..Png, displayName = "Starcall", missileName = "SorakaQMissile", slot = "Q", type = "circular", speed = 1150, range = 810, delay = 0.25, radius = 235, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = true, exception = false},
	},
	["Swain"] = {
		["SwainQ"] = {icon = Icons.."SwainQ"..Png, displayName = "Death's Hand", slot = "Q", type = "conic", speed = 5000, range = 725, delay = 0.25, radius = 0, angle = 60, danger = 2, cc = false, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
		["SwainW"] = {icon = Icons.."SwainW"..Png, displayName = "Vision of Empire", slot = "W", type = "circular", speed = MathHuge, range = 3500, delay = 1.5, radius = 300, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["SwainE"] = {icon = Icons.."SwainE"..Png, displayName = "Nevermove", slot = "E", type = "linear", speed = 1800, range = 850, delay = 0.25, radius = 85, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
	},
	["Sylas"] = {
		["SylasQ"] = {icon = Icons.."SylasQ"..Png, displayName = "Chain Lash", slot = "Q", type = "polygon", speed = MathHuge, range = 775, delay = 0.4, radius = 45, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["SylasE2"] = {icon = Icons.."SylasE"..Png, displayName = "Abduct", missileName = "SylasE2Mis", slot = "E", type = "linear", speed = 1600, range = 850, delay = 0.25, radius = 60, danger = 2, cc = true, collision = true, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Syndra"] = {
		--["SyndraQ"] = {icon = Icons.."SyndraQ"..Png, displayName = "Dark Sphere", slot = "Q", type = "circular", speed = MathHuge, range = 800, delay = 0.625, radius = 200, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		--["SyndraWCast"] = {icon = Icons.."SyndraW"..Png, displayName = "Force of Will", slot = "W", type = "circular", speed = 1450, range = 950, delay = 0.25, radius = 225, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["SyndraE"] = {icon = Icons.."SyndraE"..Png, displayName = "Scatter the Weak", slot = "E", type = "conic", speed = 1600, range = 700, delay = 0.25, radius = 0, angle = 40, danger = 3, cc = true, collision = false, windwall = true, hitbox = false, fow = false, exception = false},
		--SyndraEQMissile
	},
	["TahmKench"] = {
		["TahmKenchQ"] = {icon = Icons.."TahmKenchQ"..Png, displayName = "Tongue Lash", missileName = "TahmKenchQMissile", slot = "Q", type = "linear", speed = 2800, range = 900, delay = 0.25, radius = 70, danger = 2, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Taliyah"] = {
		["TaliyahQMis"] = {icon = Icons.."TaliyahQ"..Png, displayName = "Threaded Volley [FOW]", missileName = "TaliyahQMis", slot = "Q", type = "linear", speed = 3600, range = 1000, radius = 100, danger = 2, cc = false, collision = true, windwall = true, fow = true, exception = true},
		["TaliyahWVC"] = {icon = Icons.."TaliyahW"..Png, displayName = "Seismic Shove", slot = "W", type = "circular", speed = MathHuge, range = 900, delay = 0.85, radius = 150, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["TaliyahE"] = {icon = Icons.."TaliyahE"..Png, displayName = "Unraveled Earth", slot = "E", type = "conic", speed = 2000, range = 800, delay = 0.45, radius = 0, angle = 80, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["TaliyahR"] = {icon = Icons.."TaliyahR"..Png, displayName = "Weaver's Wall", missileName = "TaliyahRMis", slot = "R", type = "linear", speed = 1700, range = 3000, delay = 1, radius = 120, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = true, exception = false},
	},
	["Talon"] = {
		["TalonW"] = {icon = Icons.."TalonW"..Png, displayName = "Rake", missileName = "TalonWMissileOne", slot = "W", type = "conic", speed = 2500, range = 650, delay = 0.25, radius = 75, angle = 26, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Thresh"] = {
		["ThreshQMissile"] = {icon = Icons.."ThreshQ"..Png, displayName = "Death Sentence", missileName = "ThreshQMissile", slot = "Q", type = "linear", speed = 1900, range = 1100, delay = 0.5, radius = 70, danger = 1, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = true},
		["ThreshEFlay"] = {icon = Icons.."ThreshE"..Png, displayName = "Flay", slot = "E", type = "polygon", speed = MathHuge, range = 500, delay = 0.389, radius = 110, danger = 3, cc = true, collision = true, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Tristana"] = {
		["TristanaW"] = {icon = Icons.."TristanaW"..Png, displayName = "Rocket Jump", slot = "W", type = "circular", speed = 1100, range = 900, delay = 0.25, radius = 300, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Tryndamere"] = {
		["TryndamereE"] = {icon = Icons.."TryndamereE"..Png, displayName = "Spinning Slash", slot = "E", type = "linear", speed = 1300, range = 660, delay = 0, radius = 225, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["TwistedFate"] = {
		["WildCards"] = {icon = Icons.."TwistedFateQ"..Png, displayName = "Wild Cards", missileName = "SealFateMissile", slot = "Q", type = "threeway", speed = 1000, range = 1450, delay = 0.25, radius = 40, angle = 28, danger = 1, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Urgot"] = {
		["UrgotQ"] = {icon = Icons.."UrgotQ"..Png, displayName = "Corrosive Charge", missileName = "UrgotQMissile", slot = "Q", type = "circular", speed = MathHuge, range = 800, delay = 0.6, radius = 180, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["UrgotE"] = {icon = Icons.."UrgotE"..Png, displayName = "Disdain", slot = "E", type = "linear", speed = 1500, range = 475, delay = 0.45, radius = 100, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["UrgotR"] = {icon = Icons.."UrgotR"..Png, displayName = "Fear Beyond Death", missileName = "UrgotR", slot = "R", type = "linear", speed = 3200, range = 1600, delay = 0.5, radius = 80, danger = 4, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Varus"] = {
		["VarusQMissile"] = {icon = Icons.."VarusQ"..Png, displayName = "Piercing Arrow", missileName = "VarusQMissile", slot = "Q", origin = "", type = "linear", speed = 1900, range = 1525, radius = 70, danger = 1, cc = false, collision = false, windwall = true, fow = true, exception = true},
		["VarusE"] = {icon = Icons.."VarusE"..Png, displayName = "Hail of Arrows", missileName = "VarusEMissile", slot = "E", type = "linear", speed = 1500, range = 925, delay = 0.242, radius = 260, danger = 3, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["VarusR"] = {icon = Icons.."VarusR"..Png, displayName = "Chain of Corruption", missileName = "VarusRMissile", slot = "R", type = "linear", speed = 1950, range = 1200, delay = 0.25, radius = 120, danger = 4, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Veigar"] = {
		["VeigarBalefulStrike"] = {icon = Icons.."VeigarQ"..Png, displayName = "Baleful Strike", missileName = "VeigarBalefulStrikeMis", slot = "Q", type = "linear", speed = 2200, range = 900, delay = 0.25, radius = 70, danger = 2, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["VeigarDarkMatter"] = {icon = Icons.."VeigarW"..Png, displayName = "Dark Matter", slot = "W", type = "circular", speed = MathHuge, range = 900, delay = 1.25, radius = 200, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Velkoz"] = {
		["VelkozQ"] = {icon = Icons.."VelkozQ"..Png, displayName = "Plasma Fission", missileName = "VelkozQMissile", slot = "Q", type = "linear", speed = 1300, range = 1050, delay = 0.25, radius = 50, danger = 1, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
		["VelkozW"] = {icon = Icons.."VelkozW"..Png, displayName = "Void Rift", missileName = "VelkozWMissile", slot = "W", type = "linear", speed = 1700, range = 1050, delay = 0.25, radius = 87.5, danger = 1, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["VelkozE"] = {icon = Icons.."VelkozE"..Png, displayName = "Tectonic Disruption", slot = "E", type = "circular", speed = MathHuge, range = 800, delay = 0.8, radius = 185, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Vi"] = {
		["ViQ"] = {icon = Icons.."ViQ"..Png, displayName = "Vault Breaker", slot = "Q", type = "linear", speed = 1500, range = 725, delay = 0, radius = 90, danger = 2, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Viktor"] = {
		["ViktorGravitonField"] = {icon = Icons.."ViktorW"..Png, displayName = "Graviton Field", slot = "W", type = "circular", speed = MathHuge, range = 800, delay = 1.75, radius = 270, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["ViktorDeathRayMissile"] = {icon = Icons.."ViktorE"..Png, displayName = "Death Ray", missileName = "ViktorDeathRayMissile", slot = "E", type = "linear", speed = 1050, range = 700, radius = 80, danger = 2, cc = false, collision = false, windwall = true, fow = true, exception = true},
	},
	--["Vladimir"] = {
		--["VladimirHemoplague"] = {icon = Icons.."VladimirR"..Png, displayName = "Hemoplague", slot = "R", type = "circular", speed = MathHuge, range = 700, delay = 0.389, radius = 350, danger = 3, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	--},
	["Warwick"] = {
		["WarwickR"] = {icon = Icons.."WarwickR"..Png, displayName = "Infinite Duress", slot = "R", type = "linear", speed = 1800, range = 3000, delay = 0.1, radius = 55, danger = 4, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Xayah"] = {
		["XayahQ"] = {icon = Icons.."XayahQ"..Png, displayName = "Double Daggers", missileName = "XayahQ", slot = "Q", type = "linear", speed = 2075, range = 1100, delay = 0.5, radius = 45, danger = 1, cc = false, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Xerath"] = {
		--["XerathArcanopulse2"] = {icon = Icons.."XerathQ"..Png, displayName = "Arcanopulse", slot = "Q", type = "linear", speed = MathHuge, range = 1400, delay = 0.5, radius = 90, danger = 2, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["XerathArcaneBarrage2"] = {icon = Icons.."XerathW"..Png, displayName = "Arcane Barrage", slot = "W", type = "circular", speed = MathHuge, range = 1000, delay = 0.75, radius = 235, danger = 3, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["XerathMageSpear"] = {icon = Icons.."XerathE"..Png, displayName = "Mage Spear", missileName = "XerathMageSpearMissile", slot = "E", type = "linear", speed = 1400, range = 1050, delay = 0.2, radius = 60, danger = 1, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
		["XerathLocusPulse"] = {icon = Icons.."XerathR"..Png, displayName = "Rite of the Arcane", missileName = "XerathLocusPulse", slot = "R", type = "circular", speed = MathHuge, range = 5000, delay = 0.7, radius = 200, danger = 3, cc = false, collision = false, windwall = false, hitbox = false, fow = true, exception = true},
	},
	["XinZhao"] = {
		["XinZhaoW"] = {icon = Icons.."XinZhaoW"..Png, displayName = "Wind Becomes Lightning", slot = "W", type = "linear", speed = 5000, range = 900, delay = 0.5, radius = 40, danger = 1, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
	["Yasuo"] = {
		["YasuoQ1Wrapper"] = {icon = Icons.."YasuoQ1"..Png, displayName = "Steel Tempest", slot = "Q", type = "linear", speed = MathHuge, range = 475, delay = 0.339, radius = 40, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["YasuoQ2Wrapper"] = {icon = Icons.."YasuoQ2"..Png, displayName = "Steel Wind Rising", slot = "Q", type = "linear", speed = MathHuge, range = 475, delay = 0.339, radius = 40, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["YasuoQ3Wrapper"] = {icon = Icons.."YasuoQ3"..Png, displayName = "Gathering Storm", missileName = "YasuoQ3Mis", slot = "Q", type = "linear", speed = 1200, range = 1000, delay = 0.339, radius = 90, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Zac"] = {
		["ZacQ"] = {icon = Icons.."ZacQ"..Png, displayName = "Stretching Strikes", missileName = "ZacQMissile", slot = "Q", type = "linear", speed = 2800, range = 800, delay = 0.33, radius = 120, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Zed"] = {
		["ZedQ"] = {icon = Icons.."ZedQ"..Png, displayName = "Razor Shuriken", missileName = "ZedQMissile", slot = "Q", type = "linear", speed = 1700, range = 900, delay = 0.25, radius = 50, danger = 1, cc = false, collision = false, windwall = true, hitbox = true, fow = true, exception = false},
	},
	["Ziggs"] = {
		["ZiggsQ"] = {icon = Icons.."ZiggsQ"..Png, displayName = "Bouncing Bomb", missileName = "ZiggsQSpell", slot = "Q", type = "polygon", speed = 1700, range = 850, delay = 0.25, radius = 120, danger = 1, cc = false, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
		["ZiggsW"] = {icon = Icons.."ZiggsW"..Png, displayName = "Satchel Charge", missileName = "ZiggsW", slot = "W", type = "circular", speed = 1750, range = 1000, delay = 0.25, radius = 240, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["ZiggsE"] = {icon = Icons.."ZiggsE"..Png, displayName = "Hexplosive Minefield", missileName = "ZiggsE", slot = "E", type = "circular", speed = 1800, range = 900, delay = 0.25, radius = 250, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["ZiggsR"] = {icon = Icons.."ZiggsR"..Png, displayName = "Mega Inferno Bomb", missileName = "ZiggsRBoom", slot = "R", type = "circular", speed = 1550, range = 5000, delay = 0.375, radius = 480, danger = 4, cc = false, collision = false, windwall = false, hitbox = false, fow = true, exception = false},
	},
	["Zilean"] = {
		["ZileanQ"] = {icon = Icons.."ZileanQ"..Png, displayName = "Time Bomb", missileName = "ZileanQMissile", slot = "Q", type = "circular", speed = MathHuge, range = 900, delay = 0.8, radius = 150, danger = 2, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Zoe"] = {
		["ZoeQMissile"] = {icon = Icons.."ZoeQ1"..Png, displayName = "Paddle Star [First]", missileName = "ZoeQMissile", slot = "Q", type = "linear", speed = 1200, range = 800, delay = 0.25, radius = 50, danger = 1, cc = false, collision = true, windwall = true, hitbox = false, fow = true, exception = true},
		["ZoeQMis2"] = {icon = Icons.."ZoeQ2"..Png, displayName = "Paddle Star [Second]", missileName = "ZoeQMis2", slot = "Q", type = "linear", speed = 2500, range = 1600, delay = 0, radius = 70, danger = 2, cc = false, collision = true, windwall = true, hitbox = false, fow = true, exception = true},
		["ZoeE"] = {icon = Icons.."ZoeE"..Png, displayName = "Sleepy Trouble Bubble", missileName = "ZoeEMis", slot = "E", type = "linear", speed = 1700, range = 800, delay = 0.3, radius = 50, danger = 2, cc = true, collision = true, windwall = true, hitbox = false, fow = true, exception = false},
	},
	["Zyra"] = {
		["ZyraQ"] = {icon = Icons.."ZyraQ"..Png, displayName = "Deadly Spines", slot = "Q", type = "rectangular", speed = MathHuge, range = 800, delay = 0.825, radius = 200, danger = 1, cc = false, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
		["ZyraE"] = {icon = Icons.."ZyraE"..Png, displayName = "Grasping Roots", missileName = "ZyraE", slot = "E", type = "linear", speed = 1150, range = 1100, delay = 0.25, radius = 70, danger = 1, cc = true, collision = false, windwall = true, hitbox = false, fow = true, exception = false},
		["ZyraR"] = {icon = Icons.."ZyraR"..Png, displayName = "Stranglethorns", slot = "R", type = "circular", speed = MathHuge, range = 700, delay = 2, radius = 500, danger = 4, cc = true, collision = false, windwall = false, hitbox = false, fow = false, exception = false},
	},
}

local EvadeSpells = {
	["Ahri"] = {
		[3] = {icon = Icons.."AhriR"..Png, type = 1, displayName = "Spirit Rush", name = "AhriQ-", danger = 4, range = 450, slot = "R", slot2 = HK_R},
	},
	["Blitzcrank"] = {
		[1] = {icon = Icons.."BlitzcrankW"..Png, type = 2, displayName = "Overdrive", name = "BlitzcrankW-", danger = 3, slot = "W", slot2 = HK_W},
	},
	["Corki"] = {
		[1] = {icon = Icons.."CorkiW"..Png, type = 1, displayName = "Valkyrie", name = "CorkiW-", danger = 4, range = 600, slot = "W", slot2 = HK_W},
	},
	["Draven"] = {
		[1] = {icon = Icons.."DravenW"..Png, type = 2, displayName = "Blood Rush", name = "DravenW-", danger = 3, slot = "W", slot2 = HK_W},
	},
	["Ekko"] = {
		[2] = {icon = Icons.."EkkoE"..Png, type = 1, displayName = "Phase Dive", name = "EkkoE-", danger = 2, range = 325, slot = "E", slot2 = HK_E},
	},
	["Ezreal"] = {
		[2] = {icon = Icons.."EzrealE"..Png, type = 1, displayName = "Arcane Shift", name = "EzrealE-", danger = 3, range = 475, slot = "E", slot2 = HK_E},
	},
	["Fiora"] = {
		[0] = {icon = Icons.."FioraQ"..Png, type = 1, displayName = "Lunge", name = "FioraQ-", danger = 1, range = 400, slot = "Q", slot2 = HK_Q},
		[1] = {icon = Icons.."FioraW"..Png, type = 7, displayName = "Riposte", name = "FioraW-", danger = 2, range = 750, slot = "W", slot2 = HK_W},
	},
	["Fizz"] = {
		[2] = {icon = Icons.."FizzR"..Png, type = 3, displayName = "Playful", name = "FizzE-", danger = 3, slot = "E", slot2 = HK_E},
	},
	["Garen"] = {
		[0] = {icon = Icons.."GarenQ"..Png, type = 2, displayName = "Decisive Strike", name = "GarenQ-", danger = 3, slot = "Q", slot2 = HK_Q},
	},
	["Gnar"] = {
		[2] = {icon = Icons.."GnarE"..Png, type = 1, displayName = "Hop/Crunch", name = "GnarE-", range = 475, danger = 3, slot = "E", slot2 = HK_E},
	},
	["Gragas"] = {
		[2] = {icon = Icons.."GragasE"..Png, type = 1, displayName = "Body Slam", name = "GragasE-", range = 600, danger = 3, slot = "E", slot2 = HK_E},
	},
	["Graves"] = {
		[2] = {icon = Icons.."GravesE"..Png, type = 1, displayName = "Quickdraw", name = "GravesE-", range = 425, danger = 1, slot = "E", slot2 = HK_E},
	},
	["Kaisa"] = {
		[2] = {icon = Icons.."KaisaE"..Png, type = 2, displayName = "Supercharge", name = "KaisaE-", danger = 2, slot = "E", slot2 = HK_E},
	},
	["Karma"] = {
		[2] = {icon = Icons.."KarmaE"..Png, type = 2, displayName = "Inspire", name = "KarmaE-", danger = 3, slot = "E", slot2 = HK_E},
	},
	["Kassadin"] = {
		[3] = {icon = Icons.."KassadinR"..Png, type = 1, displayName = "Riftwalk", name = "KassadinR-", range = 500, danger = 3, slot = "R", slot2 = HK_R},
	},
	["Katarina"] = {
		[1] = {icon = Icons.."KatarinaW"..Png, type = 2, displayName = "Preparation", name = "KatarinaW-", danger = 3, slot = "W", slot2 = HK_W},
	},
	["Kayn"] = {
		[0] = {icon = Icons.."KaynQ"..Png, type = 1, displayName = "Reaping Slash", name = "KaynQ-", danger = 2, slot = "Q", slot2 = HK_Q},
	},
	["Kennen"] = {
		[2] = {icon = Icons.."KennenE"..Png, type = 2, displayName = "Lightning Rush", name = "KennenE-", danger = 3, slot = "E", slot2 = HK_E},
	},
	["Khazix"] = {
		[2] = {icon = Icons.."KhazixE"..Png, type = 1, displayName = "Leap", name = "KhazixE-", range = 700, danger = 3, slot = "E", slot2 = HK_E},
	},
	["Kindred"] = {
		[0] = {icon = Icons.."KindredQ"..Png, type = 1, displayName = "Dance of Arrows", name = "KindredQ-", range = 340, danger = 1, slot = "Q", slot2 = HK_Q},
	},
	["Kled"] = {
		[2] = {icon = Icons.."KledE"..Png, type = 1, displayName = "Jousting", name = "KledE-", range = 550, danger = 3, slot = "E", slot2 = HK_E},
	},
	["Leblanc"] = {
		[1] = {icon = Icons.."LeblancW"..Png, type = 1, displayName = "Distortion", name = "LeblancW-", range = 600, danger = 3, slot = "W", slot2 = HK_W},
	},
	["Lucian"] = {
		[2] = {icon = Icons.."LucianE"..Png, type = 1, displayName = "Relentless Pursuit", name = "LucianE-", range = 425, danger = 3, slot = "E", slot2 = HK_E},
	},
	["MasterYi"] = {
		[0] = {icon = Icons.."MasterYiQ"..Png, type = 4, displayName = "Alpha Strike", name = "MasterYiQ-", range = 600, danger = 3, slot = "Q", slot2 = HK_Q},
	},
	["Morgana"] = {
		[2] = {icon = Icons.."MorganaE"..Png, type = 5, displayName = "Black Shield", name = "MorganaE-", danger = 2, slot = "E", slot2 = HK_E},
	},
	["Pyke"] = {
		[2] = {icon = Icons.."PykeE"..Png, type = 1, displayName = "Phantom Undertow", name = "PykeE-", range = 550, danger = 3, slot = "E", slot2 = HK_E},
	},
	["Rakan"] = {
		[1] = {icon = Icons.."RakanW"..Png, type = 1, displayName = "Grand Entrance", name = "RakanW-", range = 600, danger = 3, slot = "W", slot2 = HK_W},
	},
	["Renekton"] = {
		[2] = {icon = Icons.."RenektonE"..Png, type = 1, displayName = "Slice and Dice", name = "RenektonE-", range = 450, danger = 3, slot = "E", slot2 = HK_E},
	},
	["Riven"] = {
		[2] = {icon = Icons.."RivenE"..Png, type = 1, displayName = "Valor", name = "RivenE-", range = 325, danger = 2, slot = "E", slot2 = HK_E},
	},
	["Rumble"] = {
		[1] = {icon = Icons.."RumbleW"..Png, type = 2, displayName = "Scrap Shield", name = "RumbleW-", danger = 2, slot = "W", slot2 = HK_W},
	},
	["Sejuani"] = {
		[0] = {icon = Icons.."SejuaniQ"..Png, type = 1, displayName = "Arctic Assault", name = "SejuaniQ-", danger = 3, slot = "Q", slot2 = HK_Q},
	},
	["Shaco"] = {
		[0] = {icon = Icons.."ShacoQ"..Png, type = 1, displayName = "Deceive", name = "ShacoQ-", range = 400, danger = 3, slot = "Q", slot2 = HK_Q},
	},
	["Shen"] = {
		[2] = {icon = Icons.."ShenE"..Png, type = 1, displayName = "Shadow Dash", name = "ShenE-", range = 600, danger = 4, slot = "E", slot2 = HK_E},
	},
	["Shyvana"] = {
		[1] = {icon = Icons.."ShyvanaW"..Png, type = 2, displayName = "Burnout", name = "ShyvanaW-", danger = 3, slot = "W", slot2 = HK_W},
	},
	["Sivir"] = {
		[2] = {icon = Icons.."SivirE"..Png, type = 5, displayName = "Spell Shield", name = "SivirE-", danger = 2, slot = "E", slot2 = HK_E},
	},
	["Skarner"] = {
		[1] = {icon = Icons.."SkarnerW"..Png, type = 2, displayName = "Crystalline Exoskeleton", name = "SkarnerW-", danger = 3, slot = "W", slot2 = HK_W},
	},
	["Sona"] = {
		[2] = {icon = Icons.."SonaE"..Png, type = 2, displayName = "Song of Celerity", name = "SonaE-", danger = 3, slot = "E", slot2 = HK_E},
	},
	["Teemo"] = {
		[1] = {icon = Icons.."TeemoW"..Png, type = 2, displayName = "Move Quick", name = "TeemoW-", danger = 3, slot = "W", slot2 = HK_W},
	},
	["Tryndamere"] = {
		[2] = {icon = Icons.."TryndamereE"..Png, type = 1, displayName = "Spinning Slash", name = "TryndamereE-", range = 660, danger = 3, slot = "E", slot2 = HK_E},
	},
	["Udyr"] = {
		[2] = {icon = Icons.."UdyrE"..Png, type = 2, displayName = "Bear Stance", name = "UdyrE-", danger = 1, slot = "E", slot2 = HK_E},
	},
	["Vayne"] = {
		[0] = {icon = Icons.."VayneQ"..Png, type = 1, displayName = "Tumble", name = "VayneQ-", range = 300, danger = 2, slot = "Q", slot2 = HK_Q},
	},
	["Vi"] = {
		[0] = {icon = Icons.."ViQ"..Png, type = 1, displayName = "Vault Breaker", name = "ViQ-", range = 250, danger = 3, slot = "Q", slot2 = HK_Q},
	},
	["Vladimir"] = {
		[1] = {icon = Icons.."VladimirW"..Png, type = 3, displayName = "Sanguine Pool", name = "VladimirW-", danger = 3, slot = "W", slot2 = HK_W},
	},
	["Volibear"] = {
		[0] = {icon = Icons.."VolibearQ"..Png, type = 2, displayName = "Rolling Thunder", name = "VolibearQ-", danger = 3, slot = "Q", slot2 = HK_Q},
	},
	["Xayah"] = {
		[3] = {icon = Icons.."XayahR"..Png, type = 3, displayName = "Featherstorm", name = "XayahR-", danger = 5, slot = "R", slot2 = HK_R},
	},
	["Yasuo"] = {
		[1] = {icon = Icons.."YasuoW"..Png, type = 6, displayName = "Wind Wall", name = "YasuoW-", danger = 2, slot = "W", slot2 = HK_W},
	},
	["Zed"] = {
		[3] = {icon = Icons.."ZedR"..Png, type = 4, displayName = "Death Mark", name = "ZedR-", range = 625, danger = 4, slot = "R", slot2 = HK_R},
	},
	["Zilean"] = {
		[2] = {icon = Icons.."ZileanE"..Png, type = 2, displayName = "Time Warp", name = "ZileanE-", danger = 3, slot = "E", slot2 = HK_E},
	},
}

local Buffs = {
	["Katarina"] = "katarinarsound",
	["Xerath"] = "XerathLocusOfPower2",
	["Vladimir"] = "VladimirW"
}

local Minions = {
	["SRU_ChaosMinionSuper"] = true,
	["SRU_OrderMinionSuper"] = true,
	["HA_ChaosMinionSuper"] = true,
	["HA_OrderMinionSuper"] = true,
	["SRU_ChaosMinionRanged"] = true,
	["SRU_OrderMinionRanged"] = true,
	["HA_ChaosMinionRanged"] = true,
	["HA_OrderMinionRanged"] = true,
	["SRU_ChaosMinionMelee"] = true,
	["SRU_OrderMinionMelee"] = true,
	["HA_ChaosMinionMelee"] = true,
	["HA_OrderMinionMelee"] = true,
	["SRU_ChaosMinionSiege"] = true,
	["SRU_OrderMinionSiege"] = true,
	["HA_ChaosMinionSiege"] = true,
	["HA_OrderMinionSiege"] = true
}

--[[
	┌─┐┌─┐┬┌┐┌┌┬┐
	├─┘│ │││││ │ 
	┴  └─┘┴┘└┘ ┴ 
--]]

local function IsPoint(p)
	return p and p.x and type(p.x) == "number" and (p.y and type(p.y) == "number")
end

local function Round(v)
	return v < 0 and MathCeil(v - 0.5) or MathFloor(v + 0.5)
end

class "Point2D"

function Point2D:__init(x, y)
	if not x then self.x, self.y = 0, 0
	elseif not y then self.x, self.y = x.x, x.y
	else self.x = x; if y and type(y) == "number" then self.y = y end end
end

function Point2D:__type()
	return "Point2D"
end

function Point2D:__eq(p)
	return self.x == p.x and self.y == p.y
end

function Point2D:__add(p)
	return Point2D(self.x + p.x, (p.y and self.y) and self.y + p.y)
end

function Point2D:__sub(p)
	return Point2D(self.x - p.x, (p.y and self.y) and self.y - p.y)
end

function Point2D.__mul(a, b)
	if type(a) == "number" and IsPoint(b) then
		return Point2D(b.x * a, b.y * a)
	elseif type(b) == "number" and IsPoint(a) then
		return Point2D(a.x * b, a.y * b)
	end
end

function Point2D.__div(a, b)
	if type(a) == "number" and IsPoint(b) then
		return Point2D(a / b.x, a / b.y)
	else
		return Point2D(a.x / b, a.y / b)
	end
end

function Point2D:__tostring()
	return "("..self.x..", "..self.y..")"
end

function Point2D:Clone()
	return Point2D(self)
end

function Point2D:Extended(to, distance)
	return self + (Point2D(to) - self):Normalized() * distance
end

function Point2D:Magnitude()
	return MathSqrt(self:MagnitudeSquared())
end

function Point2D:MagnitudeSquared(p)
	local p = p and Point2D(p) or self
	return self.x * self.x + self.y * self.y
end

function Point2D:Normalize()
	local dist = self:Magnitude()
	self.x, self.y = self.x / dist, self.y / dist
end

function Point2D:Normalized()
	local p = self:Clone()
	p:Normalize(); return p
end

function Point2D:Perpendicular()
	return Point2D(-self.y, self.x)
end

function Point2D:Perpendicular2()
	return Point2D(self.y, -self.x)
end

function Point2D:Rotate(phi)
	local c, s = MathCos(phi), MathSin(phi)
	self.x, self.y = self.x * c + self.y * s, self.y * c - self.x * s
end

function Point2D:Rotated(phi)
	local p = self:Clone()
	p:Rotate(phi); return p
end

function Point2D:Round()
	local p = self:Clone()
	p.x, p.y = Round(p.x), Round(p.y)
	return p
end

--[[
	┬  ┬┌─┐┬─┐┌┬┐┌─┐─┐ ┬
	└┐┌┘├┤ ├┬┘ │ ├┤ ┌┴┬┘
	 └┘ └─┘┴└─ ┴ └─┘┴ └─
--]]

local Vertex = {}

function Vertex:New(x, y, alpha, intersection)
	local new = {x = x, y = y, next = nil, prev = nil, nextPoly = nil, neighbor = nil, intersection = intersection, entry = nil, visited = false, alpha = alpha or 0}
	setmetatable(new, self)
	self.__index = self
	return new
end

function Vertex:InitLoop()
	local last = self:GetLast()
	last.prev.next = self
	self.prev = last.prev
end

function Vertex:Insert(first, last)
	local res = first
	while res ~= last and res.alpha < self.alpha do res = res.next end
	self.next = res
	self.prev = res.prev
	if self.prev then self.prev.next = self end
	self.next.prev = self
end

function Vertex:GetLast()
	local res = self
	while res.next and res.next ~= self do res = res.next end
	return res
end

function Vertex:GetNextNonIntersection()
	local res = self
	while res and res.intersection do res = res.next end
	return res
end

function Vertex:GetFirstVertexOfIntersection()
	local res = self
	while true do
		res = res.next
		if not res then break end
		if res == self then break end
		if res.intersection and not res.visited then break end
	end
	return res
end

--[[
	─┐ ┬┌─┐┌─┐┬ ┬ ┬┌─┐┌─┐┌┐┌
	┌┴┬┘├─┘│ ││ └┬┘│ ┬│ ││││
	┴ └─┴  └─┘┴─┘┴ └─┘└─┘┘└┘
--]]

class "XPolygon"

function XPolygon:__init()
end

function XPolygon:InitVertices(poly)
	local first, current = nil, nil
	for i = 1, #poly do
		if current then
			current.next = Vertex:New(poly[i].x, poly[i].y)
			current.next.prev = current
			current = current.next
		else
			current = Vertex:New(poly[i].x, poly[i].y)
			first = current
		end
	end
	local next = Vertex:New(first.x, first.y, 1)
	current.next = next
	next.prev = current
	return first, current
end

function XPolygon:FindIntersectionsForClip(subjPoly, clipPoly)
	local found, subject = false, subjPoly
	while subject.next do
		if not subject.intersection then
			local clip = clipPoly
			while clip.next do
				if not clip.intersection then
					local subjNext = subject.next:GetNextNonIntersection()
					local clipNext = clip.next:GetNextNonIntersection()
					local int, segs = self:Intersection(subject, subjNext, clip, clipNext)
					if int and segs then
						found = true
						local alpha1 = self:Distance(subject, int) / self:Distance(subject, subjNext)
						local alpha2 = self:Distance(clip, int) / self:Distance(clip, clipNext)
						local subjectInter = Vertex:New(int.x, int.y, alpha1, true)
						local clipInter = Vertex:New(int.x, int.y, alpha2, true)
						subjectInter.neighbor = clipInter
						clipInter.neighbor = subjectInter
						subjectInter:Insert(subject, subjNext)
						clipInter:Insert(clip, clipNext)
					end
				end
				clip = clip.next
			end
		end
		subject = subject.next
	end
	return found
end

function XPolygon:IdentifyIntersectionType(subjList, clipList, clipPoly, subjPoly, operation)
	local se = self:IsPointInPolygon(clipPoly, subjList)
	if operation == "intersection" then se = not se end
	local subject = subjList
	while subject do
		if subject.intersection then
			subject.entry = se
			se = not se
		end
		subject = subject.next
	end
	local ce = not self:IsPointInPolygon(subjPoly, clipList)
	if operation == "union" then ce = not ce end
	local clip = clipList
	while clip do
		if clip.intersection then
			clip.entry = ce
			ce = not ce
		end
		clip = clip.next
	end
end

function XPolygon:GetClipResult(subjList, clipList)
	subjList:InitLoop(); clipList:InitLoop()
	local walker, result = nil, {}
	while true do
		walker = subjList:GetFirstVertexOfIntersection()
		if walker == subjList then break end
		while true do
			if walker.visited then break end
			walker.visited = true
			walker = walker.neighbor
			TableInsert(result, Point2D(walker.x, walker.y))
			local forward = walker.entry
			while true do
				walker.visited = true
				walker = forward and walker.next or walker.prev
				if walker.intersection then break
				else TableInsert(result, Point2D(walker.x, walker.y)) end
			end
		end
	end
	return result
end

function XPolygon:ClipPolygons(subj, clip, op)
	local result = {}
	local subjList, l1 = self:InitVertices(subj)
	local clipList, l2 = self:InitVertices(clip)
    local ints = self:FindIntersectionsForClip(subjList, clipList)
	if ints then
		self:IdentifyIntersectionType(subjList, clipList, clip, subj, op)
		result = self:GetClipResult(subjList, clipList)
	else
		local inside = self:IsPointInPolygon(clip, subj[1])
		local outside = self:IsPointInPolygon(subj, clip[1])
		if op == "union" then
			if inside then return clip, nil
			elseif outside then return subj, nil end
		elseif op == "intersection" then
			if inside then return subj, nil
			elseif outside then return clip, nil end
		end
		return subj, clip
	end
	return result, nil
end

function XPolygon:CrossProduct(p1, p2)
	return p1.x * p2.y - p1.y * p2.x
end

function XPolygon:Distance(p1, p2)
	return MathSqrt(self:DistanceSquared(p1, p2))
end

function XPolygon:DistanceSquared(p1, p2)
	return (p1.x - p2.x) ^ 2 + (p1.y - p2.y) ^ 2
end

function XPolygon:Intersection(a1, b1, a2, b2)
	local a1, b1, a2, b2 = Point2D(a1), Point2D(b1), Point2D(a2), Point2D(b2)
	local r, s = Point2D(b1 - a1), Point2D(b2 - a2); local x = self:CrossProduct(r, s)
	local t, u = self:CrossProduct(a2 - a1, s) / x, self:CrossProduct(a2 - a1, r) / x
	if x ~= 0 then return Point2D(a1 + t * r), t >= 0 and t <= 1 and u >= 0 and u <= 1 end
	return nil, nil
end

function XPolygon:IsPointInPolygon(poly, point)
	local result, j = false, #poly
	for i = 1, #poly do
		if poly[i].y < point.y and poly[j].y >= point.y or poly[j].y < point.y and poly[i].y >= point.y then
			if poly[i].x + (point.y - poly[i].y) / (poly[j].y - poly[i].y) * (poly[j].x - poly[i].x) < point.x then
				result = not result
			end
		end
		j = i
	end
	return result
end

function XPolygon:OffsetPolygon(poly, offset)
	local result = {}
	for i, point in ipairs(poly) do
		local j, k = i - 1, i + 1
		if j < 1 then j = #poly end; if k > #poly then k = 1 end
		local p1, p2, p3 = poly[j], poly[i], poly[k]
		local n1 = Point2D(p2 - p1):Normalized():Perpendicular() * offset
		local a, b = Point2D(p1 + n1), Point2D(p2 + n1)
		local n2 = Point2D(p3 - p2):Normalized():Perpendicular() * offset
		local c, d = Point2D(p2 + n2), Point2D(p3 + n2)
		local int = self:Intersection(a, b, c, d)
		local dist = self:Distance(p2, int)
		local dot = (p1.x - p2.x) * (p3.x - p2.x) + (p1.y - p2.y) * (p3.y - p2.y)
		local cross = (p1.x - p2.x) * (p3.y - p2.y) - (p1.y - p2.y) * (p3.x - p2.x)
		local angle = MathAtan2(cross, dot)
		if dist > offset and angle > 0 then
			local ex = p2 + Point2D(int - p2):Normalized() * offset
			local dir = Point2D(ex - p2):Perpendicular():Normalized() * dist
			local e, f = Point2D(ex - dir), Point2D(ex + dir)
			local i1 = self:Intersection(e, f, a, b); local i2 = self:Intersection(e, f, c, d)
			TableInsert(result, i1); TableInsert(result, i2)
		else
			TableInsert(result, int)
		end
    end
    return result
end

--[[
	┬┌┐┌┬┌┬┐
	│││││ │ 
	┴┘└┘┴ ┴ 
--]]

class "JEvade"

function JEvade:__init()
	self.DoD, self.Evading, self.InsidePath, self.Loaded = false, false, false, false
	self.ExtendedPos, self.Flash, self.Flash2, self.MousePos, self.MyHeroPos, self.SafePos = nil, nil, nil, nil, nil, nil
	self.Debug, self.DodgeableSpells, self.DetectedSpells, self.Enemies, self.EvadeSpellData, self.OnCreateMisCBs, self.OnImpDodgeCBs, self.OnProcSpellCBs = {}, {}, {}, {}, {}, {}, {}, {}
	self.DDTimer, self.DebugTimer, self.MoveTimer, self.MissileID, self.OldTimer, self.NewTimer = 0, 0, 0, 0, 0, 0
	for i = 1, GameHeroCount() do
		local unit = GameHero(i)
		if unit and unit.team ~= myHero.team then TableInsert(self.Enemies, {unit = unit, spell = nil, missile = nil}) end
	end
	TableSort(self.Enemies, function(a, b) return a.unit.charName < b.unit.charName end)
	self.JEMenu = MenuElement({type = MENU, id = "JustEvade", name = "JustEvade v"..IntVer})
	self.JEMenu:MenuElement({id = "Core", name = "Core Settings", type = MENU})
	self.JEMenu.Core:MenuElement({id = "SmoothEvade", name = "Enable Smooth Evading", value = true})
	self.JEMenu.Core:MenuElement({id = "LimitRange", name = "Limit Detection Range", value = true})
	self.JEMenu.Core:MenuElement({id = "CQ", name = "Circle Segments Quality", value = 16, min = 10, max = 25, step = 1})
	self.JEMenu.Core:MenuElement({id = "DS", name = "Diagonal Search Step", value = 30, min = 5, max = 100, step = 5})
	self.JEMenu.Core:MenuElement({id = "DC", name = "Diagonal Points Count", value = 3, min = 1, max = 8, step = 1})
	self.JEMenu.Core:MenuElement({id = "LR", name = "Limited Detection Range", value = 5000, min = 500, max = 10000, step = 250})
	self.JEMenu.Core:MenuElement({id = "SS", name = "Safety Check Sensitivity", value = 0, min = 0, max = 100, step = 1})
	self.JEMenu:MenuElement({id = "Main", name = "Main Settings", type = MENU})
	self.JEMenu.Main:MenuElement({id = "Evade", name = "Enable Evade", value = true})
	self.JEMenu.Main:MenuElement({id = "Dodge", name = "Dodge Spells", value = true})
	self.JEMenu.Main:MenuElement({id = "Draw", name = "Draw Spells", value = true})
	self.JEMenu.Main:MenuElement({id = "FOW", name = "Enable FOW Detection", value = false})
	self.JEMenu.Main:MenuElement({id = "Debug", name = "Debug Evade Points", value = true})
	self.JEMenu.Main:MenuElement({id = "Status", name = "Draw Evade Status", value = true})
	self.JEMenu.Main:MenuElement({id = "SafePos", name = "Draw Safe Position", value = true})
	self.JEMenu.Main:MenuElement({id = "DD", name = "Dodge Only Dangerous", key = string.byte("N")})
	self.JEMenu.Main:MenuElement({id = "Arrow", name = "Dodge Arrow Color", color = DrawColor(192, 255, 255, 0)})
	self.JEMenu.Main:MenuElement({id = "SPC", name = "Safe Position Color", color = DrawColor(192, 255, 255, 255)})
	self.JEMenu.Main:MenuElement({id = "SC", name = "Detected Spell Color", color = DrawColor(192, 255, 255, 255)})
	self.JEMenu:MenuElement({id = "Spells", name = "Spell Settings", type = MENU})
	DelayAction(function()
		self.JEMenu.Spells:MenuElement({id = "DSpells", name = "Dodgeable Spells:", type = SPACE})
		for _, data in ipairs(self.Enemies) do
			local enemy = data.unit.charName
			if SpellDatabase[enemy] then
				for j, spell in pairs(SpellDatabase[enemy]) do
					if not self.JEMenu.Spells[j] then
						self.JEMenu.Spells:MenuElement({id = j, name = ""..enemy.." "..spell.slot.." - "..spell.displayName, leftIcon = spell.icon, type = MENU})
						self.JEMenu.Spells[j]:MenuElement({id = "Dodge"..j, name = "Dodge Spell", value = true})
						self.JEMenu.Spells[j]:MenuElement({id = "Draw"..j, name = "Draw Spell", value = true})
						self.JEMenu.Spells[j]:MenuElement({id = "Force"..j, name = "Force To Dodge", value = spell.danger >= 4})
						if spell.fow then self.JEMenu.Spells[j]:MenuElement({id = "FOW"..j, name = "FOW Detection", value = true}) end
						self.JEMenu.Spells[j]:MenuElement({id = "Mode"..j, name = "Evade Mode", drop = {"Optimal Path", "Mouse Position"}, value = 1})
						self.JEMenu.Spells[j]:MenuElement({id = "HP"..j, name = "%HP To Dodge Spell", value = 100, min = 0, max = 100, step = 5})
						self.JEMenu.Spells[j]:MenuElement({id = "ER"..j, name = "Extra Radius", value = 0, min = 0, max = 100, step = 5})
						self.JEMenu.Spells[j]:MenuElement({id = "Danger"..j, name = "Danger Level", value = (spell.danger or 1), min = 1, max = 5, step = 1})
					end
				end
			end
		end
		self.JEMenu.Spells:MenuElement({id = "ESpells", name = "Evading Spells:", type = SPACE})
		local eS = EvadeSpells[myHero.charName]
		if eS then
			for i = 0, 3 do
				if eS[i] then
					self.JEMenu.Spells:MenuElement({id = eS[i].name, name = ""..myHero.charName.." "..(eS[i].slot or "?").." - "..eS[i].displayName, leftIcon = eS[i].icon, type = MENU})
					self.JEMenu.Spells[eS[i].name]:MenuElement({id = "US"..eS[i].name, name = "Use Spell", value = true})
					self.JEMenu.Spells[eS[i].name]:MenuElement({id = "Danger"..eS[i].name, name = "Danger Level", value = (eS[i].danger or 1), min = 1, max = 5, step = 1})
				end
			end
		end
	end, 0.01)
	Callback.Add("Tick", function() self:Tick() end)
	Callback.Add("Draw", function() self:Draw() end)
	DelayAction(function()
		self:LoadEvadeSpells()
		if self.Flash then
			self.JEMenu.Spells:MenuElement({id = "Flash", name = myHero.charName.." - Summoner Flash", leftIcon = FlashIcon, type = MENU})
			self.JEMenu.Spells.Flash:MenuElement({id = "US", name = "Use Flash", value = true})
		end
		self.Loaded = true
	end, 0.01)
end

--[[
	┌┬┐┬─┐┌─┐┬ ┬┬┌┐┌┌─┐┌─┐
	 ││├┬┘├─┤││││││││ ┬└─┐
	─┴┘┴└─┴ ┴└┴┘┴┘└┘└─┘└─┘
--]]

function JEvade:DrawArrow(startPos, endPos, color)
	local p1 = endPos-(Point2D(startPos-endPos):Normalized()*30):Perpendicular()+Point2D(startPos-endPos):Normalized()*30
	local p2 = endPos-(Point2D(startPos-endPos):Normalized()*30):Perpendicular2()+Point2D(startPos-endPos):Normalized()*30
	local startPos, endPos, p1, p2 = self:FixPos(startPos), self:FixPos(endPos), self:FixPos(p1), self:FixPos(p2)
	DrawLine(startPos.x, startPos.y, endPos.x, endPos.y, 1, color)
	DrawLine(p1.x, p1.y, endPos.x, endPos.y, 1, color)
	DrawLine(p2.x, p2.y, endPos.x, endPos.y, 1, color)
end

function JEvade:DrawPolygon(poly, color)
	local path = {}
	for i = 1, #poly do path[i] = self:FixPos(poly[i]) end
	DrawLine(path[#path].x, path[#path].y, path[1].x, path[1].y, 0.5, color)
	for i = 1, #path - 1 do DrawLine(path[i].x, path[i].y, path[i + 1].x, path[i + 1].y, 0.5, color) end
end

function JEvade:DrawText(text, size, pos, x, y, color)
	DrawText(text, size, pos.x + x, pos.y + y, color)
end

--[[
	┌─┐┌─┐┌─┐┌┬┐┌─┐┌┬┐┬─┐┬ ┬
	│ ┬├┤ │ ││││├┤  │ ├┬┘└┬┘
	└─┘└─┘└─┘┴ ┴└─┘ ┴ ┴└─ ┴ 
--]]

function JEvade:AppendVector(pos1, pos2, dist)
	return pos2 + Point2D(pos2 - pos1):Normalized() * dist
end

function JEvade:CalculateEndPos(startPos, placementPos, unitPos, speed, range, radius, collision, type)
	local endPos = Point2D(startPos):Extended(placementPos, range)
	if type == "linear" or type == "threeway" then
		if speed ~= MathHuge then endPos = self:AppendVector(startPos, endPos, radius) end
		if collision then
			local startPos, minions = Point2D(startPos):Extended(placementPos, 45), {}
			for i = 1, GameMinionCount() do
				local minion = GameMinion(i); local minionPos = self:To2D(minion.pos)
				if minion and minion.team == myHero.team and minion.valid and Minions[minion.charName] and self:Distance(minionPos, startPos) <= range and minion.maxHealth > 295 and minion.health > 5 then
					local col = self:ClosestPointOnSegment(startPos, placementPos, minionPos)
					if col and self:Distance(col, minionPos) < ((minion.boundingRadius or 45) / 2 + radius) then
						TableInsert(minions, minionPos)
					end
				end
			end
			if #minions > 0 then
				TableSort(minions, function(a, b) return self:DistanceSquared(a, startPos) < self:DistanceSquared(b, startPos) end)
				local range2 = self:Distance(startPos, minions[1])
				local endPos = Point2D(startPos):Extended(placementPos, range2)
				return endPos, range2
			end
		end
	elseif type == "circular" or type == "rectangular" then
		if range > 0 then if self:Distance(unitPos, placementPos) < range then endPos = placementPos end
		else endPos = unitPos end
	end
	return endPos, range
end

function JEvade:CircleToPolygon(pos, radius, quality)
	local points = {}
	for i = 0, (quality or 16) - 1 do
		local angle = 2 * MathPi / quality * (i + 0.5)
		local cx, cy = pos.x + radius * MathCos(angle), pos.y + radius * MathSin(angle)
		TableInsert(points, Point2D(cx, cy):Round())
	end
    return points
end

function JEvade:ClosestPointOnSegment(s1, s2, pt)
	local ab = Point2D(s2 - s1)
	local t = ((pt.x - s1.x) * ab.x + (pt.y - s1.y) * ab.y) / (ab.x * ab.x + ab.y * ab.y)
	return t < 0 and Point2D(s1) or (t > 1 and Point2D(s2) or Point2D(s1 + t * ab))
end

function JEvade:ConeToPolygon(startPos, endPos, angle)
	local angle, points = MathRad(angle), {}
	TableInsert(points, Point2D(startPos))
	for i = -angle / 2, angle / 2, angle / 5 do
		local rotated = Point2D(endPos - startPos):Rotated(i)
		TableInsert(points, Point2D(startPos + rotated):Round())
	end
	return points
end

function JEvade:CrossProduct(p1, p2)
	return p1.x * p2.y - p1.y * p2.x
end

function JEvade:Distance(p1, p2)
	return MathSqrt(self:DistanceSquared(p1, p2))
end

function JEvade:DistanceSquared(p1, p2)
	return (p2.x - p1.x) ^ 2 + (p2.y - p1.y) ^ 2
end

function JEvade:DotProduct(p1, p2)
	return p1.x * p2.x + p1.y * p2.y
end

function JEvade:FixPos(pos)
	return Vector(pos.x, 0, pos.y):To2D()
end

function JEvade:GetBestEvadePos(spells, mode, extra, force)
	local evadeModes = {
		[1] = function(a, b) return self:DistanceSquared(a, self.MyHeroPos) < self:DistanceSquared(b, self.MyHeroPos) end,
		[2] = function(a, b) return self:DistanceSquared(a, self.MousePos) < self:DistanceSquared(b, self.MousePos) end
	}
	local points = {}
	for i, spell in ipairs(spells) do
		local poly = spell.path
		for j = 1, #poly do
			local startPos, endPos = poly[j], poly[j == #poly and 1 or (j + 1)]
			local original = self:ClosestPointOnSegment(startPos, endPos, self.MyHeroPos)
			local distSqr = self:DistanceSquared(original, self.MyHeroPos)
			if distSqr < 360000 then
				if force then
					if distSqr < 160000 and self:IsDangerous(original) and
					not MapPosition:inWall(self:To3D(original)) then return original end
				else
					local direction = Point2D(endPos - startPos):Normalized()
					local step = self.JEMenu.Core.DC:Value()
					for k = -step, step, 1 do
						local candidate = Point2D(original + k * self.JEMenu.Core.DS:Value() * direction)
						local extended = self:AppendVector(self.MyHeroPos, candidate, self.BoundingRadius)
						candidate = self:AppendVector(self.MyHeroPos, candidate, 10)
						if self:IsSafePos(candidate, extra) and not MapPosition:inWall(self:To3D(extended)) then TableInsert(points, candidate) end
					end
				end
			end
		end
	end
	if #points > 0 then
		TableSort(points, evadeModes[mode])
		if self.JEMenu.Main.Debug:Value() then self.Debug = points end
		return points[1]
	end
	return nil
end

function JEvade:GetExtendedSafePos(pos)
	if not self.JEMenu.Core.SmoothEvade:Value() then return pos end
	local distance, positions = self:Distance(self.MyHeroPos, pos) + 390, {}
	for i = 1, GameMinionCount() do
		local minion = GameMinion(i)
		if minion and not minion.dead then
			local minionPos = self:To2D(minion.pos)
			if self:Distance(self.MyHeroPos, minionPos) <= distance then
				TableInsert(positions, self:To2D(minion.pos)) 
			end
		end
	end
	for i = 2, 6 do
		local collision = false
		local ext = self:AppendVector(self.MyHeroPos, pos, self.BoundingRadius * i)
		if i > 2 and not MapPosition:inWall(self:To3D(ext)) or i == 2 then
			for j, pos in ipairs(positions) do
				if self:Distance(ext, pos) < self.BoundingRadius then collision = true; break end
			end
			if not collision then return ext end
		end
	end
	return nil
end

function JEvade:GetMovePath()
	return myHero.pathing.endPos and self:To2D(myHero.pathing.endPos) or nil
end

function JEvade:GetPath(startPos, placementPos, endPos, range, radius, radius2, angle, type, name)
	local path, path2, sPos, ePos = {}, {}, Point2D(startPos), Point2D(endPos)
	if type == "linear" or type == "threeway" then
		if name == "IreliaEParticleMissile" then
			path = self:RectangleToPolygon(startPos, placementPos, radius + self.BoundingRadius)
			path2 = self:RectangleToPolygon(startPos, placementPos, radius)
		elseif name == "PantheonR" then
			local pPos = self:Distance(startPos, placementPos) > 5500 and Point2D(startPos):Extended(placementPos, 5500) or placementPos
			ePos = self:AppendVector(startPos, pPos, 200)
			sPos = Point2D(pPos):Extended(startPos, 1150)
			path = self:RectangleToPolygon(sPos, ePos, radius)
			path2 = self:RectangleToPolygon(sPos, ePos, radius + self.BoundingRadius)
		else
			local oPos = self:AppendVector(startPos, endPos, self.BoundingRadius)
			path = self:RectangleToPolygon(startPos, oPos, radius + self.BoundingRadius)
			path2 = self:RectangleToPolygon(startPos, endPos, radius)
			if name == "ZoeE" then
				local p1 = self:CircleToPolygon(endPos, radius + self.BoundingRadius, self.JEMenu.Core.CQ:Value())
				local p2 = self:CircleToPolygon(endPos, radius, self.JEMenu.Core.CQ:Value())
				TableInsert(self.DetectedSpells, {path = p1, path2 = p2, rawStartPos = startPos, rawStartPos2 = startPos, startPos = startPos, endPos = endPos, unitPos = startPos, speed = MathHuge, range = range, radius = 250, radius2 = nil, angle = nil, delay = 5, name = name, startTime = GameTimer(), type = "circular", danger = 3, cc = true, collision = false, windwall = true})
			end
		end
	elseif type == "rectangular" then
		sPos = endPos-Point2D(endPos-startPos):Perpendicular():Normalized()*(radius2 or 400)
		ePos = endPos+Point2D(endPos-startPos):Perpendicular():Normalized()*(radius2 or 400)
		path = self:RectangleToPolygon(sPos, ePos, radius / 2 + self.BoundingRadius)
		path2 = self:RectangleToPolygon(sPos, ePos, radius / 2)
	elseif type == "circular" then
		path = self:CircleToPolygon(endPos, radius + self.BoundingRadius, self.JEMenu.Core.CQ:Value())
		path2 = self:CircleToPolygon(endPos, radius, self.JEMenu.Core.CQ:Value())
	elseif type == "conic" then
		path2 = self:ConeToPolygon(startPos, endPos, angle)
		path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
	elseif type == "polygon" then
		if name == "AatroxQ2" then
			local dir = Point2D(startPos - endPos):Perpendicular():Normalized()*radius
			local s1, s2 = Point2D(startPos - dir), Point2D(startPos + dir)
			local e1 = self:Rotate(s1, endPos, MathRad(40))
			local e2 = self:Rotate(s2, endPos, -MathRad(40))
			local path2 = {s1, e1, e2, s2}
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "GravesQLineSpell" then
			local p1 = self:RectangleToPolygon(startPos, endPos, radius)
			local s1 = endPos-Point2D(endPos - startPos):Perpendicular():Normalized()*240
			local e1 = endPos+Point2D(endPos - startPos):Perpendicular():Normalized()*240
			local p2 = self:RectangleToPolygon(s1, e1, 150)
			path2 = XPolygon:ClipPolygons(p1, p2, "union")
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "GravesChargeShot" or name == "GravesChargeShotShot" then
			local p1 = self:RectangleToPolygon(startPos, endPos, radius)
			local e1 = self:AppendVector(startPos, endPos, 700)
			local dir = Point2D(endPos-e1):Perpendicular():Normalized()*350
			path2 = {p1[2], p1[3], Point2D(e1 - dir), Point2D(e1 + dir), p1[4], p1[1]}
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "JinxE" or name == "JinxEHit" then
			local p1 = self:CircleToPolygon(endPos, radius, self.JEMenu.Core.CQ:Value())
			local dir = Point2D(endPos-startPos):Perpendicular():Normalized()*175
			local pos1, pos2 = Point2D(endPos + dir), Point2D(endPos - dir)
			local p2 = self:CircleToPolygon(pos1, radius, self.JEMenu.Core.CQ:Value())
			local p3 = self:CircleToPolygon(pos2, radius, self.JEMenu.Core.CQ:Value())
			local p4 = XPolygon:ClipPolygons(p1, p2, "union")
			path2 = XPolygon:ClipPolygons(p3, p4, "union")
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "MordekaiserQ" then
			local dir = Point2D(endPos-startPos):Perpendicular():Normalized()*75
			local s1, s2 = Point2D(startPos - dir), Point2D(startPos + dir)
			local e1 = self:Rotate(s1, Point2D(s1):Extended(endPos, 675), -MathRad(18))
			local e2 = self:Rotate(s2, Point2D(s2):Extended(endPos, 675), MathRad(18))
			path2 = {s1, e1, e2, s2}
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "MordekaiserE" then
			if self:Distance(sPos, placementPos) > range then
				ePos = Point2D(sPos):Extended(placementPos, range)
			else
				sPos = Point2D(placementPos):Extended(sPos, range)
				sPos = self:PrependVector(sPos, placementPos, 200)
				ePos = self:AppendVector(sPos, placementPos, 200)
			end
			path2 = self:RectangleToPolygon(sPos, ePos, radius)
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "OrianaIzuna" then
			local ePos = self:Distance(startPos, placementPos) > range and Point2D(startPos):Extended(placementPos, range) or placementPos
			local p1 = self:RectangleToPolygon(startPos, ePos, radius)
			local p2 = self:CircleToPolygon(ePos, 135, self.JEMenu.Core.CQ:Value())
			path2 = XPolygon:ClipPolygons(p1, p2, "union")
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "SylasQ" then
			local ePos = self:Distance(startPos, placementPos) > range and Point2D(startPos):Extended(placementPos, range) or placementPos
			local dir = Point2D(ePos - startPos):Perpendicular():Normalized() * 100
			local s1, s2 = Point2D(startPos - dir), Point2D(startPos + dir)
			local e1 = self:Rotate(s1, Point2D(s1):Extended(ePos, range), MathRad(3))
			local e2 = self:Rotate(s2, Point2D(s2):Extended(ePos, range), -MathRad(3))
			local p1, p2 = self:RectangleToPolygon(s1, e1, radius), self:RectangleToPolygon(s2, e2, radius)
			local p3 = self:CircleToPolygon(ePos, 180, self.JEMenu.Core.CQ:Value())
			local p4 = XPolygon:ClipPolygons(p1, p2, "union")
			path2 = XPolygon:ClipPolygons(p3, p4, "union")
			path = XPolygon:OffsetPolygon(path2, self.BoundingRadius)
		elseif name == "ThreshEFlay" then
			sPos = Point2D(startPos):Extended(endPos, -500)
			path = self:RectangleToPolygon(sPos, endPos, radius + self.BoundingRadius)
			path2 = self:RectangleToPolygon(sPos, endPos, radius)
		elseif name == "ZiggsQ" or name == "ZiggsQSpell" then
			local ePos = self:Distance(startPos, placementPos) > range and Point2D(startPos):Extended(placementPos, range) or placementPos
			local p1, bp1 = self:CircleToPolygon(ePos, radius, self.JEMenu.Core.CQ:Value()), self:CircleToPolygon(ePos, radius + self.BoundingRadius, self.JEMenu.Core.CQ:Value())
			local e1 = Point2D(startPos):Extended(ePos, 1.4 * self:Distance(startPos, ePos))
			local p2, bp2 = self:CircleToPolygon(e1, radius, self.JEMenu.Core.CQ:Value()), self:CircleToPolygon(e1, radius + self.BoundingRadius, self.JEMenu.Core.CQ:Value())
			local e2 = Point2D(ePos):Extended(e1, 1.69 * self:Distance(ePos, e1))
			local p3, bp3 = self:CircleToPolygon(e2, radius, self.JEMenu.Core.CQ:Value()), self:CircleToPolygon(e2, radius + self.BoundingRadius, self.JEMenu.Core.CQ:Value())
			TableInsert(self.DetectedSpells, {path = bp1, path2 = p1, rawStartPos = startPos, rawStartPos2 = startPos, startPos = startPos, endPos = ePos, unitPos = startPos, speed = 1750, range = range, radius = radius, radius2 = nil, angle = nil, delay = 0.25, name = name, startTime = GameTimer(), type = "circular", danger = 2, cc = false, collision = false, windwall = true})
			TableInsert(self.DetectedSpells, {path = bp2, path2 = p2, rawStartPos = startPos, rawStartPos2 = startPos, startPos = startPos, endPos = e1, unitPos = startPos, speed = 1750, range = range, radius = radius, radius2 = nil, angle = nil, delay = 0.75, name = name, startTime = GameTimer(), type = "circular", danger = 2, cc = false, collision = false, windwall = true})
			TableInsert(self.DetectedSpells, {path = bp3, path2 = p3, rawStartPos = startPos, rawStartPos2 = startPos, startPos = startPos, endPos = e2, unitPos = startPos, speed = 1750, range = range, radius = radius, radius2 = nil, angle = nil, delay = 1.25, name = name, startTime = GameTimer(), type = "circular", danger = 2, cc = false, collision = false, windwall = true})
		end
	end
	return path, path2, sPos, ePos
end

function JEvade:IsAboutToHit(spell, pos, extra)
	local evadeSpell = #self.EvadeSpellData > 0 and self.EvadeSpellData[1] or nil
	if extra and evadeSpell and evadeSpell.type ~= 2 then return false end
	local moveSpeed, myPos = self:GetMovementSpeed(extra, evadeSpell), self.MyHeroPos
	if moveSpeed == MathHuge then return false end
	local pos = self:AppendVector(myPos, pos, 1000)
	local diff = MathMax(0, GameTimer() - spell.startTime)
	local extraSafety = self.JEMenu.Core.SS:Value() / 200 + 0.07
	if spell.type == "linear" and spell.speed ~= MathHuge then
		if spell.delay > 0 and diff <= spell.delay then
			myPos = Point2D(myPos):Extended(pos, (spell.delay - diff) * moveSpeed)
			if not self:IsPointInPolygon(spell.path, myPos) then return false end
		end
		local va = Point2D(pos - myPos):Normalized() * moveSpeed
		local vb = Point2D(spell.endPos - spell.startPos):Normalized() * spell.speed
		local da, db = Point2D(myPos - spell.startPos), Point2D(va - vb)
		local a, b = self:DotProduct(db, db), 2 * self:DotProduct(da, db)
		local c = self:DotProduct(da, da) - (spell.radius + self.BoundingRadius * 2) ^ 2
		local delta = b * b - 4 * a * c
		if delta >= 0 then
			local t1, t2 = (-b + MathSqrt(delta)) / (2 * a), (-b - MathSqrt(delta)) / (2 * a)
			local t = MathMin(t1, t2)
			if t < 0 then t = MathMax(t1, t2) end
			if (extraSafety + t) > 0 then return true end
		end
	else
		local maxTime = MathMax(0, spell.range / spell.speed + spell.delay - diff - extraSafety)
		local fPos = Point2D(myPos):Extended(pos, maxTime * moveSpeed)
		if self:IsPointInPolygon(spell.path, fPos) then return true end
	end
	return false
end

function JEvade:IsDangerous(pos)
	for i, s in ipairs(self.DetectedSpells) do
		if self:IsPointInPolygon(s.path, pos) then return true end
	end
	return false
end

function JEvade:IsPointInPolygon(poly, point)
	local result, j = false, #poly
	for i = 1, #poly do
		if poly[i].y < point.y and poly[j].y >= point.y or poly[j].y < point.y and poly[i].y >= point.y then
			if poly[i].x + (point.y - poly[i].y) / (poly[j].y - poly[i].y) * (poly[j].x - poly[i].x) < point.x then
				result = not result
			end
		end
		j = i
	end
	return result
end

function JEvade:IsSafePos(pos, extra)
	for i, s in ipairs(self.DodgeableSpells) do
		if self:IsPointInPolygon(s.path, pos) or self:IsAboutToHit(s, pos, extra) then return false end
	end
	return true
end

function JEvade:LineSegmentIntersection(a1, b1, a2, b2)
	local r, s = Point2D(b1 - a1), Point2D(b2 - a2); local x = self:CrossProduct(r, s)
	local t, u = self:CrossProduct(a2 - a1, s) / x, self:CrossProduct(a2 - a1, r) / x
	return x ~= 0 and t >= 0 and t <= 1 and u >= 0 and u <= 1 and Point2D(a1 + t * r) or nil
end

function JEvade:Magnitude(p)
	return MathSqrt(self:MagnitudeSquared(p))
end

function JEvade:MagnitudeSquared(p)
	return p.x * p.x + p.y * p.y
end

function JEvade:PrependVector(pos1, pos2, dist)
	return pos1 + Point2D(pos2 - pos1):Normalized() * dist
end

function JEvade:RectangleToPolygon(startPos, endPos, radius)
	local dir = Point2D(endPos-startPos):Perpendicular():Normalized()*radius
	return {Point2D(startPos-dir), Point2D(startPos+dir), Point2D(endPos+dir), Point2D(endPos-dir)}
end

function JEvade:Rotate(startPos, endPos, theta)
	local dx, dy = endPos.x - startPos.x, endPos.y - startPos.y
	local px, py = dx * MathCos(theta) - dy * MathSin(theta), dx * MathSin(theta) + dy * MathCos(theta)
	return Point2D(px + startPos.x, py + startPos.y)
end

function JEvade:SafePosition()
	return self.SafePos and self:To3D(self.SafePos) or nil
end

function JEvade:To2D(pos)
	return Point2D(pos.x, pos.z or pos.y)
end

function JEvade:To3D(pos)
	return Vector(pos.x, 0, pos.y)
end

--[[
	┌┬┐┌─┐┌┐┌┌─┐┌─┐┌─┐┬─┐
	│││├─┤│││├─┤│ ┬├┤ ├┬┘
	┴ ┴┴ ┴┘└┘┴ ┴└─┘└─┘┴└─
--]]

function JEvade:CreateMissile(func)
	TableInsert(self.OnCreateMisCBs, func)
end

function JEvade:GetDodgeableSpells()
	local paths, result = {}, {}
	for i, s in ipairs(self.DetectedSpells) do
		self:SpellManager(i, s)
		if self.JEMenu.Main.Dodge:Value() and self.JEMenu.Spells[s.name]["Dodge"..s.name]:Value() and self:GetHealthPercent() <= self.JEMenu.Spells[s.name]["HP"..s.name]:Value() then
			if self.DoD and s.danger >= 4 or not self.DoD then TableInsert(result, s) end
		end
	end
	return result
end

function JEvade:GetHealthPercent()
	return myHero.health / myHero.maxHealth * 100
end

function JEvade:GetMovementSpeed(extra, evadeSpell)
	local moveSpeed = myHero.ms or 315
	if not extra then return moveSpeed end; if not evadeSpell then return MathHuge end
	local lvl, name = myHero:GetSpellData(evadeSpell.slot).level or 1, evadeSpell.name
	if name == "BlitzcrankW-" then return ({1.7, 1.75, 1.8, 1.85, 1.9})[lvl] * moveSpeed
	elseif name == "DravenW-" then return ({1.4, 1.45, 1.5, 1.55, 1.6})[lvl] * moveSpeed
	elseif name == "GarenQ-" then return 1.3 * moveSpeed
	elseif name == "KaisaE-" then return ({1.55, 1.6, 1.65, 1.7, 1.75})[lvl] * 2 * MathMin(1, myHero.attackSpeed) * moveSpeed
	elseif name == "KatarinaW-" then return ({1.5, 1.6, 1.7, 1.8, 1.9})[lvl] * moveSpeed
	elseif name == "KennenE-" then return 2 * moveSpeed
	elseif name == "RumbleW-" then return ({1.2, 1.25, 1.3, 1.35, 1.4})[lvl] * moveSpeed
	elseif name == "ShyvanaW-" then return ({1.3, 1.35, 1.4, 1.45, 1.5})[lvl] * moveSpeed
	elseif name == "SkarnerW-" then return ({1.08, 1.1, 1.12, 1.14, 1.16})[lvl] * moveSpeed
	elseif name == "SonaE-" then return (({1.1, 1.11, 1.12, 1.13, 1.14})[lvl] + myHero.ap / 100 * 0.03) * moveSpeed
	elseif name == "TeemoW-" then return ({1.1, 1.14, 1.18, 1.22, 1.26})[lvl] * moveSpeed
	elseif name == "UdyrE-" then return ({1.15, 1.2, 1.25, 1.3, 1.35, 1.4})[lvl] * moveSpeed
	elseif name == "VolibearQ-" then return ({1.15, 1.175, 1.2, 1.225, 1.25})[lvl] * moveSpeed end
	return moveSpeed
end

function JEvade:HasBuff(buffName)
	for i = 0, myHero.buffCount do
		local buff = myHero:GetBuff(i)
		if buff.name == buffname and buff.count > 0 then return true end
	end
	return false
end

function JEvade:ImpossibleDodge(func)
	TableInsert(self.OnImpDodgeCBs, func)
end

function JEvade:IsMoving()
	return myHero.pos.x - MathFloor(myHero.pos.x) ~= 0
end

function JEvade:IsReady(spell)
	return GameCanUseSpell(spell) == 0
end

function JEvade:MoveToPos(pos)
	if _G.SDK and _G.Control.Evade then
		_G.Control.Evade(self:To3D(pos))
	else
		local path = self:FixPos(pos)
		ControlSetCursorPos(path.x, path.y)
		ControlMouseEvent(MOUSEEVENTF_RIGHTDOWN)
		ControlMouseEvent(MOUSEEVENTF_RIGHTUP)
	end
end

function JEvade:ProcessSpell(func)
	TableInsert(self.OnProcSpellCBs, func)
end

function JEvade:ValidTarget(target, range)
	local range = range and range or MathHuge
	return target and target.valid and target.visible and not target.dead and self:DistanceSquared(self.MyHeroPos, self:To2D(target.pos)) <= range * range
end

--[[
	┌─┐┬  ┬┌─┐┌┬┐┌─┐
	├┤ └┐┌┘├─┤ ││├┤ 
	└─┘ └┘ ┴ ┴─┴┘└─┘
--]]

function JEvade:LoadEvadeSpells()
	if myHero:GetSpellData(SUMMONER_1).name == "SummonerFlash" then self.Flash, self.Flash2 = HK_SUMMONER_1, SUMMONER_1
	elseif myHero:GetSpellData(SUMMONER_2).name == "SummonerFlash" then self.Flash, self.Flash2 = HK_SUMMONER_2, SUMMONER_2 end
	for i = 0, 3 do
		local eS = EvadeSpells[myHero.charName]
		if eS and eS[i] then TableInsert(self.EvadeSpellData, {name = eS[i].name, slot2 = eS[i].slot2, range = eS[i].range, type = eS[i].type}) end
	end
end

function JEvade:Tick()
	if not self.JEMenu.Main.Evade:Value() or GameTimer() < 5 then return end
	self.DoD = self.JEMenu.Main.DD:Value() and true or false
	self.BoundingRadius = myHero.boundingRadius or 65
	self.DodgeableSpells = self:GetDodgeableSpells()
	if myHero.dead then return end
	self.MyHeroPos, self.MousePos = self:To2D(myHero.pos), self:To2D(mousePos)
	for i = 1, #self.Enemies do
		local unit, spell = self.Enemies[i].unit, self.Enemies[i].spell
		local active = unit.activeSpell
		if active and spell ~= active.name .. active.endTime and active.isChanneling then
			self.Enemies[i].spell = active.name .. active.endTime
			self:OnProcessSpell(unit, active)
			for i = 1, #self.OnProcSpellCBs do self.OnProcSpellCBs[i](unit, active) end
		end
	end
	if self.JEMenu.Main.FOW:Value() then
		for i = 1, GameMissileCount() do
			local mis = GameMissile(i)
			if mis then
				local data = mis.missileData
				for i = 1, #self.Enemies do
					local unit = self.Enemies[i].unit
					if unit.handle == data.owner then
						local id = tonumber(mis.networkID)
						if self.MissileID < id then
							self.MissileID = id
							self:OnCreateMissile(unit, data)
							for i = 1, #self.OnCreateMisCBs do self.OnCreateMisCBs[i](unit, data) end
							break
						end
					end
				end
			end
		end
	end
	if #self.DodgeableSpells > 0 then
		local result = 0
		for i, s in ipairs(self.DodgeableSpells) do
			result = result + self:CoreManager(s)
			if self.Evading then self:DodgeSpell(s) end
		end
		local movePath = self:GetMovePath()
		if movePath and not self.Evading then
			local ints = {}
			for i, s in ipairs(self.DodgeableSpells) do
				local poly = s.path
				if not self:IsPointInPolygon(poly, self.MyHeroPos) then
					for j = 1, #poly do
						local startPos, endPos = poly[j], poly[j == #poly and 1 or (j + 1)]
						local int = self:LineSegmentIntersection(startPos, endPos, self.MyHeroPos, movePath)
						if int then TableInsert(ints, int) end
					end
				end
			end
			if #ints > 0 then
				TableSort(ints, function(a, b) return self:DistanceSquared(self.MyHeroPos, a) < self:DistanceSquared(self.MyHeroPos, b) end)
				local movePos = self:PrependVector(self.MyHeroPos, ints[1], self.BoundingRadius / 2)
				self:MoveToPos(movePos)
			end
		end
		if result == 0 then self.Evading, self.SafePos, self.ExtendedPos = false, nil, nil end
	else
		if self.JEMenu.Main.Debug:Value() then self.Debug = {} end
		self.Evading, self.SafePos, self.ExtendedPos = false, nil, nil
	end
	--if _G.SDK then
	--	_G.SDK.Orbwalker:SetAttack(not self.Evading)
	--	_G.SDK.Orbwalker:SetMovement(not self.Evading)
	if _G.GOS then
		_G.GOS.BlockAttack = self.Evading
		_G.GOS.BlockMovement = self.Evading
	end
end

function JEvade:CoreManager(s)
	local mode = self.JEMenu.Spells[s.name]["Mode"..s.name]:Value() or 1
	if self:IsPointInPolygon(s.path, self.MyHeroPos) then
		if self.OldTimer ~= self.NewTimer then
			local safePos = self:GetBestEvadePos(self.DodgeableSpells, mode, false, false)
			if safePos then
				self.ExtendedPos = self:GetExtendedSafePos(safePos)
				self.SafePos, self.Evading = safePos, true
			elseif self.EvadeSpellData and #self.EvadeSpellData > 0 or (self.Flash and self.JEMenu.Spells.Flash.US:Value()) then
				local alternPos = self:GetBestEvadePos(self.DodgeableSpells, 1, true, false)
				local result = self:Avoid(s, alternPos)
				if result == 1 then
					self.ExtendedPos = self:GetExtendedSafePos(alternPos)
					self.SafePos, self.Evading = alternPos, true
				elseif result == 0 then
					for i = 1, #self.OnImpDodgeCBs do self.OnImpDodgeCBs[i]() end
				end
			else
				for i = 1, #self.OnImpDodgeCBs do self.OnImpDodgeCBs[i]() end
			end
			self.OldTimer = self.NewTimer
		end
		return 1
	end
	return 0
end

function JEvade:SpellManager(i, s)
	if s.startTime + s.range / s.speed + s.delay > GameTimer() then
		if s.speed ~= MathHuge and s.startTime + s.delay < GameTimer() then
			if s.type == "linear" or s.type == "threeway" then
				if self.DetectedSpells[i] then
					local rng = s.speed * (GameTimer() - s.startTime - s.delay)
					local sP = Point2D(s.rawStartPos2):Extended(s.endPos, rng)
					local dir = Point2D(s.endPos-s.rawStartPos2):Normalized():Perpendicular()*(s.radius + self.BoundingRadius)
					s.path[1], s.path[2] = Point2D(sP-dir), Point2D(sP+dir)
					local sP2 = Point2D(s.rawStartPos):Extended(s.endPos, rng)
					self.DetectedSpells[i].startPos = sP2
					local dir2 = Point2D(s.endPos-s.rawStartPos):Normalized():Perpendicular()*s.radius
					s.path2[1], s.path2[2] = Point2D(sP2-dir2), Point2D(sP2+dir2)
				end
			end
		end
	else TableRemove(self.DetectedSpells, i) end
end

function JEvade:DodgeSpell(spell)
	if Buffs and Buffs[myHero.charName] and self:HasBuff(Buffs[myHero.charName]) then
		self.SafePos, self.ExtendedPos = nil, nil
	end
	if self.ExtendedPos then self:MoveToPos(self.ExtendedPos) end
end

function JEvade:Avoid(spell, dodgePos)
	local evadeSpells = self.EvadeSpellData
	for i = 1, #evadeSpells do
		local data = evadeSpells[i]
		if self:IsReady(data.slot2) and self.JEMenu.Spells[data.name]["US"..data.name]:Value() and spell.danger >= self.JEMenu.Spells[data.name]["Danger"..data.name]:Value() then
			if dodgePos and (data.type == 1 or data.type == 2) then
				if data.type == 1 then
					local dashPos = Point2D(self.MyHeroPos):Extended(dodgePos, data.range)
					_G.Control.CastSpell(data.slot2, self:To3D(dashPos)); return 1
				elseif data.type == 2 then _G.Control.CastSpell(data.slot2, myHero.pos); return 1 end
			elseif data.type == 3 then _G.Control.CastSpell(data.slot2, myHero.pos); return 2
			elseif data.type == 4 then
				for _, enemy in ipairs(ObjectManager:GetEnemyHeroes()) do
					if enemy and self:ValidTarget(enemy, data.range) then
						_G.Control.CastSpell(data.slot2, enemy.pos); return 2
					end
				end
			elseif data.type == 5 and spell.cc then
				_G.Control.CastSpell(data.slot2, myHero.pos); return 2
			elseif data.type == 6 and spell.windwall then
				local wallPos = Point2D(self.MyHeroPos):Extended(spell.startPos, 100)
				_G.Control.CastSpell(data.slot2, self:To3D(wallPos)); return 2
			elseif data.type == 7 and spell.cc then
				_G.Control.CastSpell(data.slot2, self:To3D(spell.startPos)); return 2
			end
		end
	end
	local dodgePos = not dodgePos and self:GetBestEvadePos(self.DodgeableSpells, 1, true, true) or dodgePos
	if dodgePos then
		if self:IsReady(self.Flash2) and spell.danger == 5 then
			local flashPos = self:To3D(dodgePos)
			if _G.SDK and _G.Control.Flash then _G.Control.Flash(self.Flash, flashPos)
			else _G.Control.CastSpell(self.Flash, flashPos) end
			return 2
		end
		if self.JEMenu.Spells[spell.name]["Force"..spell.name]:Value() then
			self.ExtendedPos = self:GetExtendedSafePos(dodgePos)
			self.SafePos, self.Evading = dodgePos, true
			return -1
		end
	end
	return 0
end

function JEvade:Draw()
	if not self.JEMenu.Main.Evade:Value() then return end
	if self.JEMenu.Main.Status:Value() then
		if self.JEMenu.Main.Evade:Value() then
			if self.DoD then
				self:DrawText("Evade: Dodge Only Dangerous", 14, myHero.pos2D, -83, 45, DrawColor(224, 255, 255, 0))
			else self:DrawText("Evade: ON", 14, myHero.pos2D, -30, 45, DrawColor(224, 255, 255, 255)) end
		else self:DrawText("Evade: OFF", 14, myHero.pos2D, -32, 45, DrawColor(224, 255, 255, 255)) end
	end
	if #self.DetectedSpells > 0 and self.Evading == true and self.SafePos ~= nil and self.JEMenu.Main.SafePos:Value() then
		DrawCircle(self:To3D(self.SafePos), self.BoundingRadius, 0.5, self.JEMenu.Main.SPC:Value())
		self:DrawArrow(self.MyHeroPos, self.SafePos, self.JEMenu.Main.Arrow:Value())
	end
	if self.JEMenu.Main.Draw:Value() then
		if self.JEMenu.Main.Debug:Value() then
			for i, dbg in ipairs(self.Debug) do
				DrawCircle(self:To3D(dbg), self.BoundingRadius, 0.5, DrawColor(192, 255, 255, 0))
			end
		end
		for i, s in ipairs(self.DetectedSpells) do
			if self.JEMenu.Spells[s.name]["Draw"..s.name]:Value() then
				self:DrawPolygon(s.path2, self.JEMenu.Main.SC:Value())
			end
		end
	end
end

function JEvade:OnProcessSpell(unit, spell)
	if unit and spell then
		if unit.team ~= myHero.team then
			local unitPos = self:To2D(unit.pos)
			if self.JEMenu.Core.LimitRange:Value() and self:Distance(self.MyHeroPos, unitPos) > self.JEMenu.Core.LR:Value() then return end
			if SpellDatabase[unit.charName] and SpellDatabase[unit.charName][spell.name] then
				local data = SpellDatabase[unit.charName][spell.name]
				if data.exception then return end
				local placementPos = self:To2D(spell.placementPos)
				local startPos = spell.startPos and self:To2D(spell.startPos) or unitPos
				local endPos, range2 = self:CalculateEndPos(startPos, placementPos, unitPos, data.speed, data.range, data.radius, data.collision, data.type)
				local extraRadius = self.JEMenu.Spells[spell.name]["ER"..spell.name]:Value() or 0
				local danger = self.JEMenu.Spells[spell.name]["Danger"..spell.name]:Value() or 1
				local path, path2, sP, eP = self:GetPath(startPos, placementPos, endPos, range2, data.radius + extraRadius, data.radius2, data.angle, data.type, spell.name)
				if #path == 0 then return end
				local sP2 = (data.type == "linear" or data.type == "threeway") and self:AppendVector(eP, sP, self.BoundingRadius) or nil
				TableInsert(self.DetectedSpells, {path = path, path2 = path2, rawStartPos = sP, rawStartPos2 = sP2, startPos = sP, endPos = eP, unitPos = unitPos, speed = data.speed, range = range2, radius = data.radius + extraRadius, radius2 = data.radius2, angle = data.angle, delay = data.delay, name = spell.name, startTime = GameTimer(), type = data.type, danger = danger, cc = data.cc, collision = data.collision, windwall = data.windwall})
				if data.type == "threeway" then
					for i = 1, 2 do
						if i == 1 then eP = self:Rotate(startPos, endPos, MathRad(data.angle))
						else eP = self:Rotate(startPos, endPos, -MathRad(data.angle)) end
						local p1 = self:RectangleToPolygon(startPos, eP, data.radius + self.BoundingRadius)
						local p2 = self:RectangleToPolygon(startPos, eP, data.radius)
						TableInsert(self.DetectedSpells, {path = p1, path2 = p2, rawStartPos = sP, rawStartPos2 = sP2, startPos = sP, endPos = Point2D(eP), unitPos = unitPos, speed = data.speed, range = range2, radius = data.radius + extraRadius, radius2 = data.radius2, angle = data.angle, delay = data.delay, name = spell.name, startTime = GameTimer(), type = data.type, danger = danger, cc = data.cc, collision = data.collision, windwall = data.windwall})
					end
				end
				self.NewTimer = GameTimer()
			end
		elseif unit == myHero and spell.name == "SummonerFlash" then
			self.NewTimer, self.SafePos, self.ExtendedPos = GameTimer(), nil, nil
		end
	end
end

function JEvade:OnCreateMissile(unit, missile)
	local name, unitPos = missile.name, self:To2D(unit.pos)
	if string.find(name, "ttack") or not SpellDatabase[unit.charName] then return end
	if self.JEMenu.Core.LimitRange:Value() and self:Distance(self.MyHeroPos, unitPos) > self.JEMenu.Core.LR:Value() then return end
	local menuName = ""
	for i, val in pairs(SpellDatabase[unit.charName]) do
		if SpellDatabase[unit.charName][i].fow then
			local tested = SpellDatabase[unit.charName][i].missileName
			if string.find(name, tested) then menuName = i break end
		end
	end
	if menuName == "" then return end
	local data = SpellDatabase[unit.charName][menuName]
	if self.JEMenu.Main.FOW:Value() and self.JEMenu.Spells[menuName]["FOW"..menuName]:Value() and not unit.visible and not data.exception or (data.exception and unit.visible) then
		local placementPos = self:To2D(missile.placementPos)
		local startPos = self:To2D(missile.startPos) or unitPos
		local endPos, range2 = self:CalculateEndPos(startPos, placementPos, unitPos, data.speed, data.range, data.radius, data.collision, data.type)
		local extraRadius = self.JEMenu.Spells[menuName]["ER"..menuName]:Value() or 0
		local danger = self.JEMenu.Spells[menuName]["Danger"..menuName]:Value() or 1
		local path, path2, sP, eP = self:GetPath(startPos, placementPos, endPos, range2, data.radius + extraRadius, data.radius2, data.angle, data.type)
		if #path == 0 then return end
		local sP2 = (data.type == "linear" or data.type == "threeway") and self:AppendVector(eP, sP, self.BoundingRadius) or nil
		TableInsert(self.DetectedSpells, {path = path, path2 = path2, rawStartPos = sP, rawStartPos2 = sP2, startPos = sP, endPos = eP, unitPos = unitPos, speed = data.speed, range = range2, radius = data.radius + extraRadius, radius2 = data.radius2, angle = data.angle, delay = 0, name = menuName, startTime = RiotClock.time, type = data.type, danger = danger, cc = data.cc, collision = data.collision, windwall = data.windwall})
		if data.type == "threeway" then
			for i = 1, 2 do
				if i == 1 then eP = self:Rotate(startPos, endPos, MathRad(data.angle))
				else eP = self:Rotate(startPos, endPos, -MathRad(data.angle)) end
				local p1 = self:RectangleToPolygon(startPos, eP, data.radius + self.BoundingRadius)
				local p2 = self:RectangleToPolygon(startPos, eP, data.radius)
				TableInsert(self.DetectedSpells, {path = p1, path2 = p2, rawStartPos = sP, rawStartPos2 = sP2, startPos = sP, endPos = Point2D(eP), unitPos = unitPos, speed = data.speed, range = range2, radius = data.radius + extraRadius, radius2 = data.radius2, angle = data.angle, delay = 0, name = menuName, startTime = RiotClock.time, type = data.type, danger = danger, cc = data.cc, collision = data.collision, windwall = data.windwall})
			end
		end
		self.NewTimer = RiotClock.time
	end
end

JEvade:__init()

-- API

_G.JustEvade = {
	Loaded = function() return JEvade.Loaded end,
	Evading = function() return JEvade.Evading end,
	IsDangerous = function(self, pos) return JEvade:IsDangerous(JEvade:To2D(pos)) end,
	SafePos = function(self) return JEvade:SafePosition() end,
	OnImpossibleDodge = function(func) JEvade:ImpossibleDodge(func) end,
	OnCreateMissile = function(func) JEvade:CreateMissile(func) end,
	OnProcessSpell = function(func) JEvade:ProcessSpell(func) end
}

AutoUpdate()
