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
            .format(type(id)));
    assert(
        type(duration) == "number",
        ("Bad argument #3 to `AcquireTimer' (expected number, got %q).")
            .format(type(duration)));
    assert(
        type(callback) == "function",
        ("Bad argument #4 to `AcquireTimer' (expected function, got %q)")
            .format(type(callback)));
    assert(
        self.timers[id] == nil,
        ("Attempting to acquire a timer with an id that already exists (id: %s).")
            .format(tostring(id)));
    
    self.timers[id] = {
        elapsed  = 0,
        duration = duration,
        callback = callback,
    };
end

function Timer:ReleaseTimer(id)
    assert(
        type(id) == "string" or type(id) == "number",
        ("Bad argument #2 to `ReleaseTimer' (expected string or number, got %q).")
            .format(type(id)));
    assert(
        self.timers[id] ~= nil,
        ("Attempting to release a timer with an id that doesn't exist (id: %s).")
            .format(tostring(id)));
    
    self.timers[id] = nil;
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
