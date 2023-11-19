--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local Hooks = {}

local HANDSHAKE_ARGS = nil
local RANDOM_PUSH = math.random(1e3, 1e5)

local Remote = ReplicatedStorage:WaitForChild("Remotes").CharacterSoundEvent

--// Functions
local function IsHandshakeArgs(Args)
    return (rawequal(Args[1], "AC\226\154\156\239\184\143")
    and rawequal(type(Args[2]), "table")
    and rawequal(rawlen(Args[2]), 19))
end

--> Hardware Ban Bypass
Hooks.Clock = hookfunction(os.clock, function(...)
    return Hooks.Clock(...) + RANDOM_PUSH
end)

--> Retrieve Handshake Args
Hooks.Namecall = hookmetamethod(game, "__namecall", function(self, ...)
    local Method = getnamecallmethod()
    local Args = {...}

    if
        not checkcaller()
        and rawequal(self, Remote)
        and rawequal(Method, "fireServer")
        and IsHandshakeArgs(Args)
    then
        if not HANDSHAKE_ARGS then
            HANDSHAKE_ARGS = Args[2]
        else
            return coroutine.yield()
        end
    end

    return Hooks.Namecall(self, ...)
end)

--> Wait for HANDSHAKE_ARGS
while not HANDSHAKE_ARGS do
    task.wait()
end

--> Allow table.clone
getrawmetatable(HANDSHAKE_ARGS).__metatable = nil

task.wait(1)

--> Disable Script Detections
for _, Connection in getconnections(Remote.OnClientEvent) do
    if string.find(debug.getinfo(Connection.Function).source, "PlayerModule.LocalScript") then
        Connection:Disable()
    end
end

--> Replicate Handshake
task.spawn(function()
    while task.wait(0.5) do
        Remote:FireServer("AC\226\154\156\239\184\143", table.clone(HANDSHAKE_ARGS), nil)
    end
end)

print("FF2-AC Bypass V2")
