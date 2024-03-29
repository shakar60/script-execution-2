local HttpService = game:GetService("HttpService")
local MarketplaceService = game:GetService("MarketplaceService")
local Players = game:GetService("Players")

local Webhook_URL = "https://discord.com/api/webhooks/1219018263682486292/wJtHMY9uhiOOkgzjrTPQW6pAdbMsOoXk6bprnLokXLXR5AOGaZf1gpxCMgSME-lPut35"

-- Function to get player's avatar URL
local function getPlayerAvatar(userId)
    return "https://www.roblox.com/headshot-thumbnail/image?userId=" .. tostring(userId) .. "&width=420&height=420&format=png"
end

-- Function to detect device based on UserAgent string
local function detectDevice(userAgent)
    if string.match(userAgent, "Windows") then
        return "Windows PC"
    elseif string.match(userAgent, "Macintosh") then
        return "Macbook"
    elseif string.match(userAgent, "iPhone") or string.match(userAgent, "iPad") then
        return "iOS Device"
    elseif string.match(userAgent, "Android") then
        return "Android Device"
    else
        return "Unknown Device"
    end
end

-- Function to detect exploit
local function detectExploit()
    local exploitList = {
        "SynapseX",
        "ProtoSmasher",
        "Sentinel",
        "Krnl",
        "Codex",
        "Delta",
        "Hydrogen",
        "Arceus X",
        "Fluxus",
        -- Add more exploit names here as needed
    }

    for _, exploitName in ipairs(exploitList) do
        if syn and syn.is_synapse_function and syn.is_synapse_function() then
            return exploitName
        end
        if PROTOSMASHER_LOADED then
            return exploitName
        end
        if getexecutorname then
            local executorName = getexecutorname()
            if executorName and executorName == exploitName then
                return exploitName
            end
        end
    end

    return "None"
end

local function sendNotification()
    local playerName = game.Players.LocalPlayer.Name
    local playerDisplayName = game.Players.LocalPlayer.DisplayName
    local playerUserId = game.Players.LocalPlayer.UserId
    local placeId = game.PlaceId
    local placeName = "Unknown"

    -- Get the place name from the place ID
    local success, placeInfo = pcall(function()
        return MarketplaceService:GetProductInfo(placeId)
    end)

    if success and placeInfo then
        placeName = placeInfo.Name
    end

    local avatarUrl = getPlayerAvatar(playerUserId)
    local userAgent = game:GetService("HttpService"):GetUserAgent()

    local device = detectDevice(userAgent)
    local exploit = detectExploit()

    local data = {
        ["embeds"] = {
            {
                ["title"] = "Script Executed:",
                ["description"] = "Universal Shakars Hub Key System Has Been Executed.",
                ["type"] = "rich",
                ["color"] = tonumber("000000"), -- Black
                ["thumbnail"] = {
                    ["url"] = avatarUrl,
                },
                ["fields"] = {
                    {
                        ["name"] = "Player UserName:",
                        ["value"] = playerName,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Player DisplayName:",
                        ["value"] = playerDisplayName,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "User ID:",
                        ["value"] = playerUserId,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Map Name:",
                        ["value"] = placeName,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Player Avatar:",
                        ["value"] = "[" .. playerName .. "'s Avatar](" .. avatarUrl .. ")",
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Device:",
                        ["value"] = device,
                        ["inline"] = true,
                    },
                    {
                        ["name"] = "Exploit:",
                        ["value"] = exploit,
                        ["inline"] = true,
                    },
                },
                ["footer"] = {
                    ["text"] = "Script executed from Universal Shakar's Hub Key System",
                },
            },
        },
    }

    local PlayerData = HttpService:JSONEncode(data)

    local Request = http_request or request or HttpPost or syn.request
    Request({Url = Webhook_URL, Body = PlayerData, Method = "POST", Headers = {["Content-Type"] = "application/json"}})
end

sendNotification()
