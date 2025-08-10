local Timer = PNK_LibStub:NewLibrary("PNK_Timer", 1);

if Timer == nil then
    return;
end

--[[---------------------------------------------------------------------------
	End of boilerplate
--]]---------------------------------------------------------------------------
Timer.timers = {};

--[[---------------------------------------------------------------------------
	Member functions
--]]---------------------------------------------------------------------------
function Timer:AcquireTimer(id, duration, callback)
    assert(
        type(id) == "string" or type(id) == "number",
        ("Bad argument #2 to `AcquireTimer' (expected string or number, got %q).")
            :format(type(id)));
    assert(
        type(duration) == "number",
        ("Bad argument #3 to `AcquireTimer' (expected number, got %q).")
            :format(type(duration)));
    assert(
        type(callback) == "function",
        ("Bad argument #4 to `AcquireTimer' (expected function, got %q)")
            :format(type(callback)));
    
    if self.timers[id] == nil then
        self.timers[id] = {
            elapsed  = 0,
            duration = duration,
            callback = callback,
        };
        return true;
    else
        return false;
    end
end

function Timer:ReleaseTimer(id)
    assert(
        type(id) == "string" or type(id) == "number",
        ("Bad argument #2 to `ReleaseTimer' (expected string or number, got %q).")
            :format(type(id)));
    
    if self.timers[id] == nil then
        return false;
    else
        self.timers[id] = nil;
        return true;
    end
end

--[[---------------------------------------------------------------------------
	Event handling
--]]---------------------------------------------------------------------------
local listener = CreateFrame("Frame");
listener:SetScript("OnUpdate", function(self, elapsed)
    for _, timer in next, Timer.timers do
        timer.elapsed = timer.elapsed + elapsed;

        if timer.elapsed >= timer.duration then
            timer.elapsed = timer.elapsed - timer.duration;
            timer.callback();
        end
    end
end);
