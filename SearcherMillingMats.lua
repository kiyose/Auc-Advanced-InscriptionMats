--[[
	Auctioneer Advanced - Search UI - Searcher MillingMats
	TODO add revision and ID

	This is a plugin module for the SearchUI that assists in searching by refined paramaters

	License:
		This program is free software; you can redistribute it and/or
		modify it under the terms of the GNU General Public License
		as published by the Free Software Foundation; either version 2
		of the License, or (at your option) any later version.

		This program is distributed in the hope that it will be useful,
		but WITHOUT ANY WARRANTY; without even the implied warranty of
		MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
		GNU General Public License for more details.

		You should have received a copy of the GNU General Public License
		along with this program(see GPL.txt); if not, write to the Free Software
		Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA  02110-1301, USA.

	Note:
		This AddOn's source code is specifically designed to work with
		World of Warcraft's interpreted AddOn system.
		You have an implicit license to use this AddOn with these facilities
		since that is its designated purpose as per:
		http://www.fsf.org/licensing/licenses/gpl-faq.html#InterpreterIncompat
--]]
-- Create a new instance of our lib with our parent
local lib, parent, private = AucSearchUI.NewSearcher("MillingMats")
if not lib then return end
local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "MillingMats"

-- Milling reagents, from Enchantrix EnxConstants.lua
local ALABASTER_PIGMENT = 39151
local DUSKY_PIGMENT = 39334
local GOLDEN_PIGMENT = 39338
local EMERALD_PIGMENT = 39339
local VIOLET_PIGMENT = 39340
local SILVERY_PIGMENT = 39341
local NETHER_PIGMENT = 39342
local AZURE_PIGMENT = 39343

local VERDANT_PIGMENT = 43103
local BURNT_PIGMENT = 43104
local INDIGO_PIGMENT = 43105
local RUBY_PIGMENT = 43106
local SAPPHIRE_PIGMENT = 43107
local EBON_PIGMENT = 43108
local ICY_PIGMENT = 43109

local HERB_PEACEBLOOM = 2447
local HERB_SILVERLEAF = 765
local HERB_EARTHROOT = 2449
local HERB_MAGEROYAL = 785
--local HERB_BLOODTHISTLE = 22710		-- removed during beta

local HERB_BRIARTHORN = 2450
local HERB_SWIFTTHISTLE = 2452
local HERB_BRUISEWEED = 2453
local HERB_STRANGLEKELP = 3820

local HERB_WILDSTEELBLOOM = 3355
local HERB_GRAVEMOSS = 3369
local HERB_KINGSBLOOD = 3356
local HERB_LIFEROOT = 3357

local HERB_FADELEAF = 3818
local HERB_GOLDTHORN = 3821
local HERB_WINTERSBITE = 3819
local HERB_KHADGARSWHISKER = 3358

local HERB_FIREBLOOM = 4625
local HERB_GHOSTMUSHROOM = 8845
local HERB_ARTHASTEARS = 8836
local HERB_GROMSBLOOD = 8846
local HERB_BLINDWEED = 8839
local HERB_SUNGRASS = 8838
local HERB_PURPLELOTUS = 8831

local HERB_ICECAP = 13467
local HERB_GOLDENSANSAM = 13464
local HERB_PLAGUEBLOOM = 13466
local HERB_DREAMFOIL = 13463
local HERB_MOUNTAINSILVERSAGE = 13465

-- all BC herbs
local HERB_TEROCONE = 22789
local HERB_DREAMINGGLORY = 22786
local HERB_FELWEED = 22785
local HERB_RAGVEIL = 22787
local HERB_NIGHTMAREVINE = 22792
local HERB_MANATHISTLE = 22793
local HERB_NETHERBLOOM = 22791
local HERB_ANCIENTLICHEN = 22790

-- all northrend herbs?
local HERB_GOLDCLOVER = 36901
--local HERB_CONSTRICTORGRASS = 36902		-- removed 3.0.8
local HERB_ADDERSTONGUE = 36903
local HERB_TIGERLILY = 36904
local HERB_LICHBLOOM = 36905
local HERB_ICETHORN = 36906
local HERB_TALANDRASROSE = 36907
local HERB_DEADNETTLE = 37921
local HERB_FIRESEED = 39969					-- milling added 3.0.8
local HERB_FIRELEAF = 39970					-- milling added 3.0.8

-- a table we can check for item ids
local validReagents =
	{
--	[VOID] = true,
     [ALABASTER_PIGMENT] = true,
     [DUSKY_PIGMENT] = true,
     [GOLDEN_PIGMENT] = true,
     [EMERALD_PIGMENT] = true,
     [VIOLET_PIGMENT] = true,
     [SILVERY_PIGMENT] = true,
     [NETHER_PIGMENT] = true,
     [AZURE_PIGMENT] = true,

     [VERDANT_PIGMENT] = true,
     [BURNT_PIGMENT] = true,
     [INDIGO_PIGMENT] = true,
     [RUBY_PIGMENT] = true,
     [SAPPHIRE_PIGMENT] = true,
     [EBON_PIGMENT] = true,
     [ICY_PIGMENT] = true,

     [HERB_PEACEBLOOM] = true,
     [HERB_SILVERLEAF] = true,
     [HERB_EARTHROOT] = true,
     [HERB_MAGEROYAL] = true,
--     [HERB_BLOODTHISTLE] = true,		-- removed during beta

     [HERB_BRIARTHORN] = true,
     [HERB_SWIFTTHISTLE] = true,
     [HERB_BRUISEWEED] = true,
     [HERB_STRANGLEKELP] = true,

     [HERB_WILDSTEELBLOOM] = true,
     [HERB_GRAVEMOSS] = true,
     [HERB_KINGSBLOOD] = true,
     [HERB_LIFEROOT] = true,

     [HERB_FADELEAF] = true,
     [HERB_GOLDTHORN] = true,
     [HERB_WINTERSBITE] = true,
     [HERB_KHADGARSWHISKER] = true,

     [HERB_FIREBLOOM] = true,
     [HERB_GHOSTMUSHROOM] = true,
     [HERB_ARTHASTEARS] = true,
     [HERB_GROMSBLOOD] = true,
     [HERB_BLINDWEED] = true,
     [HERB_SUNGRASS] = true,
     [HERB_PURPLELOTUS] = true,

     [HERB_ICECAP] = true,
     [HERB_GOLDENSANSAM] = true,
     [HERB_PLAGUEBLOOM] = true,
     [HERB_DREAMFOIL] = true,
     [HERB_MOUNTAINSILVERSAGE] = true,

-- all BC herbs
     [HERB_TEROCONE] = true,
     [HERB_DREAMINGGLORY] = true,
     [HERB_FELWEED] = true,
     [HERB_RAGVEIL] = true,
     [HERB_NIGHTMAREVINE] = true,
     [HERB_MANATHISTLE] = true,
     [HERB_NETHERBLOOM] = true,
     [HERB_ANCIENTLICHEN] = true,

-- all northrend herbs?
     [HERB_GOLDCLOVER] = true,
--     [HERB_CONSTRICTORGRASS] = true,		-- removed 3.0.8
     [HERB_ADDERSTONGUE] = true,
     [HERB_TIGERLILY] = true,
     [HERB_LICHBLOOM] = true,
     [HERB_ICETHORN] = true,
     [HERB_TALANDRASROSE] = true,
     [HERB_DEADNETTLE] = true,
     [HERB_FIRESEED] = true,					-- milling added 3.0.8
     [HERB_FIRELEAF] = true,					-- milling added 3.0.8
	}

-- Set our defaults
default("millingmats.level.custom", false)
default("millingmats.level.min", 0)
default("millingmats.level.max", 450)
default("millingmats.allow.bid", true)
default("millingmats.allow.buy", true)
default("millingmats.maxprice", 10000000)
default("millingmats.maxprice.enable", false)

--Slider variables
default("millingmats.PriceAdjust."..ALABASTER_PIGMENT, 100)
default("millingmats.PriceAdjust."..DUSKY_PIGMENT, 100)
default("millingmats.PriceAdjust."..GOLDEN_PIGMENT, 100)
default("millingmats.PriceAdjust."..EMERALD_PIGMENT, 100)
default("millingmats.PriceAdjust."..VIOLET_PIGMENT, 100)
default("millingmats.PriceAdjust."..SILVERY_PIGMENT, 100)
default("millingmats.PriceAdjust."..NETHER_PIGMENT, 100)
default("millingmats.PriceAdjust."..AZURE_PIGMENT, 100)

default("millingmats.PriceAdjust."..VERDANT_PIGMENT, 100)
default("millingmats.PriceAdjust."..BURNT_PIGMENT, 100)
default("millingmats.PriceAdjust."..INDIGO_PIGMENT, 100)
default("millingmats.PriceAdjust."..RUBY_PIGMENT, 100)
default("millingmats.PriceAdjust."..SAPPHIRE_PIGMENT, 100)
default("millingmats.PriceAdjust."..EBON_PIGMENT, 100)
default("millingmats.PriceAdjust."..ICY_PIGMENT, 100)

-- This function is automatically called when we need to create our search parameters
function lib:MakeGuiConfig(gui)
	-- Get our tab and populate it with our controls
	local id = gui:AddTab(lib.tabname, "Searchers")
	gui:MakeScrollable(id)

	-- Add the help
	gui:AddSearcher("Milling Mats", "Search for items which will mill for you into given pigments (for levelling)", 100)
	gui:AddHelp(id, "millingmats searcher",
		"What does this searcher do?",
		"This searcher provides the ability to search for items which will mill into the pigments you need to have in order to level your inscription skill. It is not a searcher meant for profit, but rather least cost for leveling.")

	if not (Enchantrix and Enchantrix.Storage) then
		gui:AddControl(id, "Header",     0,   "Enchantrix not detected")
		gui:AddControl(id, "Note",    0.3, 1, 290, 30,    "Enchantrix must be enabled to search with MillingMats")
		return
	end

	gui:AddControl(id, "Header",     0,      "MillingMats search criteria")

	local last = gui:GetLast(id)

	gui:AddControl(id, "Checkbox",          0.42, 1, "millingmats.allow.bid", "Allow Bids")
	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0.56, 1, "millingmats.allow.buy", "Allow Buyouts")
	gui:AddControl(id, "Checkbox",          0.42, 1, "millingmats.maxprice.enable", "Enable individual maximum price:")
	gui:AddTip(id, "Limit the maximum amount you want to spend with the MillingMats searcher")
	gui:AddControl(id, "MoneyFramePinned",  0.42, 2, "millingmats.maxprice", 1, 99999999, "Maximum Price for MillingMats")

	gui:SetLast(id, last)
	gui:AddControl(id, "Checkbox",          0, 1, "millingmats.level.custom", "Use custom inscription skill levels")
	gui:AddControl(id, "Slider",            0, 2, "millingmats.level.min", 0, 450, 25, "Minimum skill: %s")
	gui:AddControl(id, "Slider",            0, 2, "millingmats.level.max", 25, 450, 25, "Maximum skill: %s")

	-- aka "what percentage of market value am I willing to pay for this pigment"?
	gui:AddControl(id, "Subhead",          0,    "Pigment Price Modification")

    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..ALABASTER_PIGMENT, 0, 200, 1, "Alabaster Pigment (Ivory/Moonglow Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..DUSKY_PIGMENT, 0, 200, 1, "Dusky Pigment (Midnight Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..GOLDEN_PIGMENT, 0, 200, 1, "Golden Pigment (Lion's Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..EMERALD_PIGMENT, 0, 200, 1, "Emerald Pigment (Jadefire Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..VIOLET_PIGMENT, 0, 200, 1, "Violet Pigment (Celestial Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..SILVERY_PIGMENT, 0, 200, 1, "Silvery Pigment (Shimmering Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..NETHER_PIGMENT, 0, 200, 1, "Nether Pigment (Ethereal Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..AZURE_PIGMENT, 0, 200, 1, "Azure Pigment (Ink of the Sea) %s%%" )

    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..VERDANT_PIGMENT, 0, 200, 1, "Verdant Pigment (Hunter's Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..BURNT_PIGMENT, 0, 200, 1, "Burnt Pigment (Dawnstar Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..INDIGO_PIGMENT, 0, 200, 1, "Indigo Pigment (Royal Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..RUBY_PIGMENT, 0, 200, 1, "Ruby Pigment (Fiery Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..SAPPHIRE_PIGMENT, 0, 200, 1, "Sapphire Pigment (Ink of the Sky) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..EBON_PIGMENT, 0, 200, 1, "Ebon Pigment (Darkflame Ink) %s%%" )
    gui:AddControl(id, "WideSlider", 0, 1, "millingmats.PriceAdjust."..ICY_PIGMENT, 0, 200, 1, "Icy Pigment (Snowfall Ink) %s%%" )
end

function lib.Search(item)
	local market, seen, _, curModel, pctstring

	-- Can't do anything without Enchantrix
	if not (Enchantrix and Enchantrix.Storage) then
		return false, "Enchantrix not detected"
	end

	local itemLink = item[Const.LINK]
	if (not itemLink) then
		return false, "No item link"
	end

	local bidprice, buyprice = item[Const.PRICE], item[Const.BUYOUT]

	local maxprice = get("millingmats.maxprice.enable") and get("millingmats.maxprice")

	if buyprice <= 0 or not get("millingmats.allow.buy") or (maxprice and buyprice > maxprice) then
		buyprice = nil
	end
	if not get("millingmats.allow.bid") or (maxprice and bidprice > maxprice) then
		bidprice = nil
	end
	if not (bidprice or buyprice) then
		return false, "Does not meet bid/buy requirements"
	end

	-- first, is this an enchanting reagent itself?
	-- if so, just use the value of the reagent
	if validReagents[ Enchantrix.Util.GetItemIdFromLink(itemLink) ] then
		-- be safe and handle nil results
		local adjustment = get("millingmats.PriceAdjust."..Enchantrix.Util.GetItemIdFromLink(itemLink)) or 0

		-- return early if we aren't interested in this pigment
		if (not adjustment or adjustment <= 0) then
		--	return false, "Adjustment equal to 0"
		end

		market, _, _, seen, curModel = AucAdvanced.Modules.Util.Appraiser.GetPrice(itemLink)
		if (not market or market <= 0) then
			return false, "No appraiser price"
		end

		market = (market * item[Const.COUNT]) * (adjustment / 100)
	end

	-- it's not a reagent, figure out what it mill's into
	if (not market or market == 0) then

		local minskill = 0
		local maxskill = 450
		if get("millingmats.level.custom") then
			minskill = get("millingmats.level.min")
			maxskill = get("millingmats.level.max")
		else
			maxskill = Enchantrix.Util.GetUserInscriptionSkill()
		end

		local skillneeded = Enchantrix.Util.InscriptionSkillRequiredForItem(itemLink)
		if (skillneeded < minskill) or (skillneeded > maxskill) then
			return false, "Skill not high enough to Mill"
		end

		-- Give up if it doesn't mill to anything
		local pigments = Enchantrix.Storage.GetItemMilling(itemLink)
		if not pigments then
			return false, "Item not Millable"
		end

		market = 0
		for pigment, yield in pairs(pigments) do

		    -- if we aren't interested in the Pigment, we might as well exit early
			local adjustment = get("millingmats.PriceAdjust."..pigment) or 0

			if ( adjustment <= 0 ) then
				return false, "No Adjustment Found"
			end

			-- make an item out of this pigment string
			local _, pigmentLink = GetItemInfo(pigment)

			-- fetch value of each pigment from Enchantrix
			local pigmentPrice, med, baseline, five = Enchantrix.Util.GetReagentPrice(pigment);

			-- if no Auc4 price, use Auc5 price
			if (not pigmentPrice) then
				pigmentPrice = five
			end

			-- if still no price, get the buy price from Appraiser
			if (not pigmentPrice) then
				local newBuy, newBid, isFalse, seen, curModelText, MatchString, stack, number, duration = AucAdvanced.Modules.Util.Appraiser.GetPrice(pigmentLink) 
				pigmentPrice = newBuy
			end

			-- still nothing, try the baseline (hard coded)
			if (not pigmentPrice) then
				pigmentPrice = baseline
			end

			local millingNum = 5
			local totalYield = (item[Const.COUNT] / millingNum) * yield or 0;
			local totalValue = totalYield * (pigmentPrice or 0)


			-- market is 0 at this point or this mills into two pigments
			market = market + ( totalValue * (adjustment / 100) ) ;

			-- calculate deposit for each pigment
			if includeDeposit then
				local aadvdepcost = GetDepositCost(pigment, depositAucLength, depositFaction, nil) or 0
				deposit = deposit + aadvdepcost * yield * depositRelistTimes
			end
		end
	end

	-- If we don't know what it's worth, then there's not much we can do
	if( not market or market <= 0) then
		return false, "No Price Found"
	end

	if buyprice and buyprice <= market then
		return "buy", market
	elseif bidprice and bidprice <= market then
		return "bid", market
	end
	return false, "Not enough profit"
end

-- TOD0 determine where this will be going
--AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.4/Auc-Util-SearchUI/SearcherMillingMats.lua $", "$Rev: 3953 $")
