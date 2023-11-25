--// Services
local ReplicatedStorage = game:GetService("ReplicatedStorage")

--// Variables
local HANDSHAKE_ARGS = nil
local Hooks = {}
local Instances = {
    ACRemote = ReplicatedStorage:WaitForChild("Remotes").CharacterSoundEvent
}
local DEBUG_MODE = true
local ShuffleFunction = nil

--> Grab HANDSHAKE ARGS!
Hooks.__namecall = hookfunction(getrawmetatable(game).__namecall, newcclosure(function(Self, ...)
    local Method = getnamecallmethod()
    local ARGS = { ... }

    if not checkcaller() then
        if Method == "fireServer" and Self == Instances.ACRemote then
            if ARGS[1] and tostring(ARGS[1]):find("AC") then
                if ARGS[2] and type(ARGS[2]) == "table" then
                    if HANDSHAKE_ARGS == nil or not HANDSHAKE_ARGS then
                        HANDSHAKE_ARGS = ARGS[2]
                        if (DEBUG_MODE) then
                            print('Set Handshake Arguments!')
                        end
                    end
                end
            end
        end
    end

    return Hooks.__namecall(Self, ...)
end));

--> Wait for HANDSHAKE ARGS
while (not HANDSHAKE_ARGS) do
    task.wait()
end

--> DEBUG_MODE CHECK
if (DEBUG_MODE and HANDSHAKE_ARGS and HANDSHAKE_ARGS ~= nil) then
    print('Got HANDSHAKE ARGUMENTS!')
end

--> Allow table.clone to be fired on HANDSHAKE_ARGS
getrawmetatable(HANDSHAKE_ARGS).__metatable = nil

if (DEBUG_MODE) and (getrawmetatable(HANDSHAKE_ARGS).__metatable == nil) then
    print('Stripped Metatables Of Args[2]!')
end

--> Grab Shuffle Function
for Index, Function in pairs(getgc()) do
    if type(Function) == 'function' and debug.getinfo(Function).source:find("PlayerModule.LocalScript") then
        if debug.getinfo(Function).numparams == 6 then
            if not ShuffleFunction then
                ShuffleFunction = Function
                if (DEBUG_MODE) then
                    warn('Retrieved Shuffle Function.')
                end
            end
        end
    end
end

--> Hook Shuffle Function.
if ShuffleFunction then
    local Old
    Old = hookfunction(ShuffleFunction, function(p1, p2, p3, p4, p5, p6)
        if (
            (p1 ~= 660 and p2 ~= 759 and p3 ~= 751 and p4 ~= 863 and p5 ~= 771) or
            (p1 ~= 665 and p2 ~= 775 and p3 ~= 724 and p4 ~= 633 and p5 ~= 891) or
            (p1 ~= 760 and p2 ~= 760 and p3 ~= 771 and p4 ~= 665 and p5 ~= 898)
        ) 
        then
            return warn('Blocked Possible Automatic Ban.')
        end

        return Old(p1, p2, p3, p4, p5, p6)
    end)

else
    warn('Shuffle Function is nil.')
end


--> Replicate Handshake.
task.spawn(function()
    while task.wait(0.3) do
        if (HANDSHAKE_ARGS) and (HANDSHAKE_ARGS ~= nil) then
            Instances.ACRemote:fireServer("AC\226\154\156\239\184\143", HANDSHAKE_ARGS, nil)

            if (DEBUG_MODE) then
                print('Replicated handshake.')
            end
        end
    end
end);
