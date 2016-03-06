--[[

  The autospec module introduces the following:
  - Users are put to spec if they are in the (almost) exact same position after a predefined time 

]]--

local iterators, vec3 = require("std.iterators"), require("utils.vec3")

local TIME_BETWEEN_CHECKS = 1000*30 -- how many milliseconds between each position check
local DELTA = 0.2 -- if the position difference between checks is lower than this value, put client to spec

-- Called every TIME_BETWEEN_CHECKS milliseconds.
local function updateClientPosition()
  for ci in iterators.players() do
    if not ci.extra.curPos then
      ci.extra.curPos = vec3()
    end
    
    local curVec, oldVec = vec3(ci.state.o), vec3(ci.extra.curPos)
    
    if curVec:dist(oldVec) < DELTA then
      server.forcespectator(ci)
      engine.writelog(("autospec %d(%s)"):format(ci.clientnum, ci.name))
    end
    
    ci.extra.curPos = curVec
  end
end 

spaghetti.addhook("changemap", function(info)
  spaghetti.latergame(TIME_BETWEEN_CHECKS, updateClientPosition, true)
end)


