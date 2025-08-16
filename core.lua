-- Copyright (C) 2025 Hrvoje 'Hurubon' Žohar
-- See the end of the file for extended copyright information.
local LibStub = PNK_LibStub or LibStub;
local Timer   = LibStub:NewLibrary("PNK_Timer", 3);

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
--[[
The MIT License (MIT)
Copyright (C) 2025 Hrvoje 'Hurubon' Žohar

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM,
DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
OR OTHER DEALINGS IN THE SOFTWARE.
--]]
