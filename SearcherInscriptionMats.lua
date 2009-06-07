--[[
Auctioneer Advanced - Search UI - Searcher InscriptionMats
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

TODO: The market valuation and percentage calculations have not been validated. 
use at your own descretion.
--]]
-- Create a new instance of our lib with our parent
local lib, parent, private = AucSearchUI.NewSearcher("InscriptionMats")
if not lib then return end
local print,decode,_,_,replicate,empty,_,_,_,debugPrint,fill = AucAdvanced.GetModuleLocals()
local get,set,default,Const = AucSearchUI.GetSearchLocals()
lib.tabname = "InscriptionMats"

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

local MOONGLOW_INK   = 39469 --moonglow ink
local MIDNIGHT_INK   = 39774 --midnight ink
local HUNTERS_INK    = 43115 --hunter's ink
local LIONS_INK      = 43116 --lion's ink
local DAWNSTAR_INK   = 43117 --dawnstar ink
local JADEFIRE_INK   = 43118 --jadefire ink
local ROYAL_INK      = 43119 --royal ink
local CELESTIAL_INK  = 43120 --celestial ink
local FIERY_INK      = 43121 --fiery ink
local SHIMMERING_INK = 43122 --shimmering ink
local INK_OF_THE_SKY = 43123 --ink of the sky
local ETHEREAL_INK   = 43124 --ethereal ink
local DARKFLAME_INK  = 43125 --darkflame ink
local INK_OF_THE_SEA = 43126 --ink of the sea
local SNOWFALL_INK   = 43127 --snowfall ink

local COMMON_INK = 2 -- two pigments to make this ink
local RARE_INK   = 1 -- one pigment to make this ink

local inksToPigments = {
  [MOONGLOW_INK]   = ALABASTER_PIGMENT, --moonglow ink (alabaster pigment)
  [MIDNIGHT_INK]   = DUSKY_PIGMENT,     --midnight ink (dusky pigment)
  [HUNTERS_INK]    = VERDANT_PIGMENT,   --hunter's ink (verdant pigment)
  [LIONS_INK]      = GOLDEN_PIGMENT,    --lion's ink (golden pigment)
  [DAWNSTAR_INK]   = BURNT_PIGMENT,     --dawnstar ink (burnt pigment)
  [JADEFIRE_INK]   = EMERALD_PIGMENT,   --jadefire ink (emerald pigment)
  [ROYAL_INK]      = INDIGO_PIGMENT,    --royal ink (indigo pigment)
  [CELESTIAL_INK]  = VIOLET_PIGMENT,    --celestial ink (violet pigment)
  [FIERY_INK]      = RUBY_PIGMENT,      --fiery ink (Ruby Pigment)
  [SHIMMERING_INK] = SILVERY_PIGMENT,   --shimmering ink (silvery pigment)
  [INK_OF_THE_SKY] = SAPPHIRE_PIGMENT,  --ink of the sky (Saphire Pigment)
  [ETHEREAL_INK]   = NETHER_PIGMENT,    --ethereal ink (nether pigment)
  [DARKFLAME_INK]  = EBON_PIGMENT,      --darkflame ink (ebon pigment)
  [INK_OF_THE_SEA] = AZURE_PIGMENT,     --ink of the sea (azure pigment)
  [SNOWFALL_INK]   = ICY_PIGMENT,       -- snowfall ink (icy pigment)
}

local pigmentsToInks = {
  [ALABASTER_PIGMENT] = MOONGLOW_INK   , --moonglow ink (alabaster pigment)
  [DUSKY_PIGMENT]     = MIDNIGHT_INK   , --midnight ink (dusky pigment)
  [VERDANT_PIGMENT]   = HUNTERS_INK    , --hunter's ink (verdant pigment)
  [GOLDEN_PIGMENT]    = LIONS_INK      , --lion's ink (golden pigment)
  [BURNT_PIGMENT]     = DAWNSTAR_INK   , --dawnstar ink (burnt pigment)
  [EMERALD_PIGMENT]   = JADEFIRE_INK   , --jadefire ink (emerald pigment)
  [INDIGO_PIGMENT]    = ROYAL_INK      , --royal ink (indigo pigment)
  [VIOLET_PIGMENT]    = CELESTIAL_INK  , --celestial ink (violet pigment)
  [RUBY_PIGMENT]      = FIERY_INK      , --fiery ink (Ruby Pigment)
  [SILVERY_PIGMENT]   = SHIMMERING_INK , --shimmering ink (silvery pigment)
  [SAPPHIRE_PIGMENT]  = INK_OF_THE_SKY , --ink of the sky (Saphire Pigment)
  [NETHER_PIGMENT]    = ETHEREAL_INK   , --ethereal ink (nether pigment)
  [EBON_PIGMENT]      = DARKFLAME_INK  , --darkflame ink (ebon pigment)
  [AZURE_PIGMENT]     = INK_OF_THE_SEA , --ink of the sea (azure pigment)
  [ICY_PIGMENT]       = SNOWFALL_INK   , -- snowfall ink (icy pigment)
}

local pigmentCount = {
  [MOONGLOW_INK]   = COMMON_INK, --moonglow ink (alabaster pigment)
  [MIDNIGHT_INK]   = COMMON_INK, --midnight ink (dusky pigment)
  [HUNTERS_INK]    = RARE_INK, --hunter's ink (verdant pigment)
  [LIONS_INK]      = COMMON_INK, --lion's ink (golden pigment)
  [DAWNSTAR_INK]   = RARE_INK, --dawnstar ink (burnt pigment)
  [JADEFIRE_INK]   = COMMON_INK, --jadefire ink (emerald pigment)
  [ROYAL_INK]      = RARE_INK, --royal ink (indigo pigment)
  [CELESTIAL_INK]  = COMMON_INK, --celestial ink (violet pigment)
  [FIERY_INK]      = RARE_INK, --fiery ink (Ruby Pigment)
  [SHIMMERING_INK] = COMMON_INK, --shimmering ink (silvery pigment)
  [INK_OF_THE_SKY] = RARE_INK, --ink of the sky (Saphire Pigment)
  [ETHEREAL_INK]   = COMMON_INK, --ethereal ink (nether pigment)
  [DARKFLAME_INK]  = RARE_INK, --darkflame ink (ebon pigment)
  [INK_OF_THE_SEA] = COMMON_INK, --ink of the sea (azure pigment)
  [SNOWFALL_INK]   = RARE_INK, -- snowfall ink (icy pigment)
}

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

  [MOONGLOW_INK]   = true,
  [MIDNIGHT_INK]   = true,
  [HUNTERS_INK]    = true,
  [LIONS_INK]      = true,
  [DAWNSTAR_INK]   = true,
  [JADEFIRE_INK]   = true,
  [ROYAL_INK]      = true,
  [CELESTIAL_INK]  = true,
  [FIERY_INK]      = true,
  [SHIMMERING_INK] = true,
  [INK_OF_THE_SKY] = true,
  [ETHEREAL_INK]   = true,
  [DARKFLAME_INK]  = true,
  [INK_OF_THE_SEA] = true,
  [SNOWFALL_INK]   = true,
}

-- Set our defaults
default("inscriptionmats.level.custom", false)
default("inscriptionmats.level.min", 0)
default("inscriptionmats.level.max", 450)
default("inscriptionmats.allow.bid", true)
default("inscriptionmats.allow.buy", true)
default("inscriptionmats.maxprice", 10000000)
default("inscriptionmats.maxprice.enable", false)

--Slider variables
default("inscriptionmats.PriceAdjust."..MOONGLOW_INK, 100)
default("inscriptionmats.PriceAdjust."..MIDNIGHT_INK, 100)
default("inscriptionmats.PriceAdjust."..LIONS_INK, 100)
default("inscriptionmats.PriceAdjust."..JADEFIRE_INK, 100)
default("inscriptionmats.PriceAdjust."..CELESTIAL_INK, 100)
default("inscriptionmats.PriceAdjust."..SHIMMERING_INK, 100)
default("inscriptionmats.PriceAdjust."..ETHEREAL_INK, 100)
default("inscriptionmats.PriceAdjust."..INK_OF_THE_SEA, 100)

-- uncommon inks
default("inscriptionmats.PriceAdjust."..HUNTERS_INK, 0)
default("inscriptionmats.PriceAdjust."..DAWNSTAR_INK, 0)
default("inscriptionmats.PriceAdjust."..ROYAL_INK, 0)
default("inscriptionmats.PriceAdjust."..FIERY_INK, 0)
default("inscriptionmats.PriceAdjust."..INK_OF_THE_SKY, 0)
default("inscriptionmats.PriceAdjust."..DARKFLAME_INK, 0)
default("inscriptionmats.PriceAdjust."..SNOWFALL_INK, 0)

-- This function is automatically called when we need to create our search parameters
function lib:MakeGuiConfig(gui)
  -- Get our tab and populate it with our controls
  local id = gui:AddTab(lib.tabname, "Searchers")
  gui:MakeScrollable(id)

  -- Add the help
  gui:AddSearcher("Inscription Mats", "Search for items which will provide ink (mill/pigment/ink) for levelling", 100)
  gui:AddHelp(id, "inscriptionmats searcher",
  "What does this searcher do?",
  "This searcher provides the ability to search for items which will mill into the pigments you need to have in order to level your inscription skill. It is not a searcher meant for profit, but rather least cost for leveling.")

  if not (Enchantrix and Enchantrix.Storage) then
	gui:AddControl(id, "Header",     0,   "Enchantrix not detected")
	gui:AddControl(id, "Note",    0.3, 1, 290, 30,    "Enchantrix must be enabled to search with InscriptionMats")
	return
  end

  gui:AddControl(id, "Header",     0,      "InscriptionMats search criteria")

  local last = gui:GetLast(id)

  gui:AddControl(id, "Checkbox",          0.42, 1, "inscriptionmats.allow.bid", "Allow Bids")
  gui:SetLast(id, last)
  gui:AddControl(id, "Checkbox",          0.56, 1, "inscriptionmats.allow.buy", "Allow Buyouts")
  gui:AddControl(id, "Checkbox",          0.42, 1, "inscriptionmats.maxprice.enable", "Enable individual maximum price:")
  gui:AddTip(id, "Limit the maximum amount you want to spend with the InscriptionMats searcher")
  gui:AddControl(id, "MoneyFramePinned",  0.42, 2, "inscriptionmats.maxprice", 1, 99999999, "Maximum Price for InscriptionMats")

  gui:SetLast(id, last)
  gui:AddControl(id, "Checkbox",          0, 1, "inscriptionmats.level.custom", "Use custom inscription skill levels")
  gui:AddControl(id, "Slider",            0, 2, "inscriptionmats.level.min", 0, 450, 25, "Minimum skill: %s")
  gui:AddControl(id, "Slider",            0, 2, "inscriptionmats.level.max", 25, 450, 25, "Maximum skill: %s")

  -- aka "what percentage of market value am I willing to pay for this pigment"?
  gui:AddControl(id, "Subhead",          0,    "Pigment Price Modification")

  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..MOONGLOW_INK, 0, 201, 1, "Ivory/Moonglow Ink (Alabaster Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..MIDNIGHT_INK, 0, 201, 1, "Midnight Ink (Dusky Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..LIONS_INK, 0, 201, 1, "Lion's Ink (Golden Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..JADEFIRE_INK, 0, 201, 1, "Jadefire Ink (Emerald Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..CELESTIAL_INK, 0, 201, 1, "Celestial Ink (Violet Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..SHIMMERING_INK, 0, 201, 1, "Shimmering Ink (Silvery Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..ETHEREAL_INK, 0, 201, 1, "Ethereal Ink (Nether Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..INK_OF_THE_SEA, 0, 201, 1, "Ink of the Sea (Azure Pigment) %s%%" )

  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..HUNTERS_INK, 0, 201, 1, "Hunter's Ink (Verdant Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..DAWNSTAR_INK, 0, 201, 1, "Dawnstar Ink (Burnt Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..ROYAL_INK, 0, 201, 1, "Royal Ink (Indigo Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..FIERY_INK, 0, 201, 1, "Fiery Ink (Ruby Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..INK_OF_THE_SKY, 0, 201, 1, "Ink of the Sky (Sapphire Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..DARKFLAME_INK, 0, 201, 1, "Darkflame Ink (Ebon Pigment) %s%%" )
  gui:AddControl(id, "WideSlider", 0, 1, "inscriptionmats.PriceAdjust."..SNOWFALL_INK, 0, 201, 1, "Snowfall Ink (Icy Pigment) %s%%" )
end

function lib.Search(item)
  local market, seen, _, curModel, pctstring, adjMarket

  -- Can't do anything without Enchantrix
  if not (Enchantrix and Enchantrix.Storage) then
	return false, "Enchantrix not detected"
  end

  local itemLink = item[Const.LINK]
  if (not itemLink) then
	return false, "No item link"
  end

  local bidprice, buyprice = item[Const.PRICE], item[Const.BUYOUT]

  local maxprice = get("inscriptionmats.maxprice.enable") and get("inscriptionmats.maxprice")

  if buyprice <= 0 or not get("inscriptionmats.allow.buy") or (maxprice and buyprice > maxprice) then
	buyprice = nil
  end
  if not get("inscriptionmats.allow.bid") or (maxprice and bidprice > maxprice) then
	bidprice = nil
  end
  if not (bidprice or buyprice) then
	return false, "Does not meet bid/buy requirements"
  end

  -- If we have an item we are interested in then we should process it
  if validReagents[ Enchantrix.Util.GetItemIdFromLink(itemLink) ] then

	local itemId = Enchantrix.Util.GetItemIdFromLink(itemLink)

	local inks = {}

	-- are we a herb?
	-- 	convert to pigment 
	-- 	add to ink table
	if  ( Enchantrix.Storage.GetItemMilling(itemLink) ) then
	  local pigments = Enchantrix.Storage.GetItemMilling(itemLink)

	  if pigments then
		for pigment, pigmentYield in pairs(pigments) do
		  local ink = pigmentsToInks[pigment]

		  local _, inkLink = GetItemInfo(ink)
		  local _, pigmentLink = GetItemInfo(pigment)

		  local stackNum = item[Const.COUNT] / 5 

		  local pigmentNum = stackNum * pigmentYield

		  local inkNum   = pigmentNum / pigmentCount[ink]

		  inks[ink] = inkNum

		  --		  inks[ink] = { 
		  --					itemLink,
		  --					'itemCount = ' .. item[Const.COUNT],
		  --					'stackNum  = ' .. stackNum,
		  --		  			pigmentLink,
		  --					'pigmentYield = ' .. pigmentYield,
		  --					'pigmentNum = '   .. pigmentNum,
		  --					'pigmentPerInk = '.. pigmentCount[ink],
		  --					inkLink,
		  --					'inkNum = ' .. inkNum,
		  --				  }
		end
	  end

	-- are we a pigment?
	-- 	add to inks table
	elseif  (pigmentsToInks[itemId]) then
	  local ink = pigmentsToInks[itemId]

	  local _, inkLink = GetItemInfo(ink)
	  local inkNum   = item[Const.COUNT] / pigmentCount[ink]

	  inks[ink] = inkNum
	  --	  inks[ink] = { 
	  --		itemLink,
	  --		'itemCount = ' .. item[Const.COUNT],
	  --		'pigmentPerInk = '.. pigmentCount[ink],
	  --		inkLink,
	  --		'inkNum = ' .. inkNum,
	  --	  }


	-- are we the ink itself?
	--    add to inks table
	elseif (pigmentCount[itemId]) then
	  local ink = itemId
	  inks[ink] = item[Const.COUNT]
	end


	for inkId, num in pairs (inks) do
	  local _, inkLink = GetItemInfo(inkId)
	  --print ( inkLink .. '=>' .. num)
	  -- be safe and handle nil results
	  local adjustment = get("inscriptionmats.PriceAdjust."..inkId) or 0

	  if (not adjustment or adjustment <= 0) then
		--print ("not interested in" .. inkLink)

		-- if we already have a market value for this (common pigment) use it otherwise assign it
	  elseif ( not market ) then
		market, _, _, seen, curModel = AucAdvanced.Modules.Util.Appraiser.GetPrice(inkLink)
		market = (market * num) 
		adjMarket = market * (adjustment / 100)
	  end 

	end

	if (not market or market <= 0) then
	  --print ("No appraiser price")
	  return false, "No appraiser price"
	end

  else
	--print ("Not an ink, pigment or herb")
	return false, "Not an ink, pigment or herb" 
  end

  -- If we don't know what it's worth, then there's not much we can do
  if( not market or market <= 0) then
	print ("No Price Found")
	return false, "No Price Found"
  end

  if buyprice and ( buyprice / adjMarket ) <= 1 then
	print ("returning 1", buyprice, adjMarket)
	return "buy", market
  elseif bidprice and (bidprice / adjMarket) > 1 then
	print ("returning 2", bidprice, adjMarket)
	return "bid", market
  elseif adjustment and adjustment >= 201 then
	print ("returning 3")
	return "bid", market
  end

  return false, "Not enough profit"
end

-- Dump tables
function print_r (t, indent, done)
  done = done or {}
  indent = indent or ''
  local nextIndent -- Storage for next indentation value
  for key, value in pairs (t) do
    if type (value) == "table" and not done [value] then
      nextIndent = nextIndent or
          (indent .. string.rep(' ',string.len(tostring (key))+2))
          -- Shortcut conditional allocation
      done [value] = true
      print (indent .. "[" .. tostring (key) .. "] => Table {");
      print  (nextIndent .. "{");
      print_r (value, nextIndent .. string.rep(' ',2), done)
      print  (nextIndent .. "}");
    else
      print  (indent .. "[" .. tostring (key) .. "] => " .. tostring (value).."")
    end
  end
end

-- TOD0 determine where this will be going
--AucAdvanced.RegisterRevision("$URL: http://svn.norganna.org/auctioneer/branches/5.4/Auc-Util-SearchUI/SearcherInscriptionMats.lua $", "$Rev: 3953 $")
