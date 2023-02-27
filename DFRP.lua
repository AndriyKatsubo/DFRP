--[[
	DF reward progress
	Author : Cleeve#2479
]]

-- ===========================================
-- Main code functions
-- ===========================================

-- ==== COMMON CODE AREA ====
DFRP = {};

-- Information on Dragonflight factions
DFRP.factions = {
    -- Dragonscale Expedition
    {
        name = 'Dragonscale Expedition',
        id = 2507,
        items = {
            {id = 200443, weight = 15}, -- Dragon Isles Artifact
            {id = 200285, weight = 50}, -- Dragonscale Expedition Insignia (green)
        },
        iconId = 4687628,
    },
    -- Maruuk Centaur
    {
        name = 'Maruuk Centaur',
        id = 2503,
        items = {
            {id = 200447, weight = 25}, -- Centaur Hunting Trophy
            {id = 200288, weight = 50}, -- Maruuk Centaur Insignia (green)
        },
        iconId = 4687627,
    },
    -- Iskaara Tuskarr
    {
        name = 'Iskaara Tuskarr',
        id = 2511,
        items = {
            {id = 200449, weight = 15}, -- Sacred Tuskarr Totem
            {id = 200287, weight = 50}, -- Iskaara Tuskarr Insignia (green)
        },
        iconId = 4687629,
    },
    -- Valdrakken Accord
    {
        name = 'Valdrakken Accord',
        id = 2510,
        items = {
            {id = 200450, weight = 15}, -- Titan Relic
            {id = 200289, weight = 50}, -- Valdrakken Accord Insignia (green)
        },
        iconId = 4687630,
    }
};

-- Gold coin related information
DFRP.swagCoins = {
    name = 'Gold Coin of the Isles',
    iconId = 4638725,
    items = {
        -- Weights in copper coins
        {id = 199338, weight = 1}, -- Copper Coin of the Isles
        {id = 199339, weight = 15}, -- Silver Coin of the Isles
        {id = 199340, weight = 75} -- Gold Coin of the Isles
    },
};

-- Calculates total weight of items in the bag. Items should contain array of objects with ids and weights.
function DFRP:CalcWeight(items)
    -- Total weight
    local total = 0;
    -- Number of items to look for
    local n = #items;
    -- Looking for count of each item
    for i=1, n do
        -- Next item
        local item = items[i];
        -- Retrieving count of items
        local count = GetItemCount(item.id);
        -- Calculating weight of items
        local weight = count * item.weight;
        -- Adding to the total weight\
        total = total + weight;
    end;
    return total;
end;

-- Returns current reputation value and threshold for faction
function DFRP:GetFactionInfo(factionId)
    local currentValue, threshold, _, _, _ = C_Reputation.GetFactionParagonInfo(factionId);
    local level = math.floor(currentValue/threshold);
    local realValue = currentValue - level*threshold;
    
    return realValue, threshold;
end;

-- Checks whether new reward level with faction can be reached by using related items
function DFRP:CanReachReward(factionId, items)
    -- Calculating total weight of items in the bag
    local repInBag = DFRP:CalcWeight(items);
    -- Calculating how much reputation we need to reach reward
    local currentValue, threshold = DFRP:GetFactionInfo(factionId);
    -- Calculating potential value of reputation if we use items from bags
    local potentialValue = repInBag + currentValue;
    
    return potentialValue >= threshold; 
end;

-- ==== END OF COMMON CODE AREA ====

function DFRP_PrintProgress()
	-- Iterating through factions
	for _, faction in pairs(DFRP.factions) do
		-- Calculating current weight
		local weight = DFRP:CalcWeight(faction.items);
        -- Retrieving information on faction
        local currentValue, rewardValue = DFRP:GetFactionInfo(faction.id);
        -- 
        local possibleReputation = weight + currentValue;
		-- Printing weight
		local s = faction.name .. " - " .. possibleReputation .. " : 7500";
		DEFAULT_CHAT_FRAME:AddMessage(s, 0, 1, 0)
	end;
	-- Gold coin
	local weight = DFRP:CalcWeight(DFRP.swagCoins.items);
	local s = DFRP.swagCoins.name .. " - " .. weight .. " : 75";
	DEFAULT_CHAT_FRAME:AddMessage(s, 1, 1, 0)
end;

-- ===========================================
-- Slash command aliases
-- ===========================================

-- /dfhprint
-- Prints weights for all known factions
SlashCmdList["DFRP"] = DFRP_PrintProgress

-- Command aliases
SLASH_DFRP1 = "/dfrp"
