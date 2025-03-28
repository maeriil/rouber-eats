local ReplicatedStorage = game:GetService("ReplicatedStorage")
local jecs = require(ReplicatedStorage.pkg.jecs)
local types = require(ReplicatedStorage.types)
local world = require(ReplicatedStorage.common.ecs.world)
local pair = jecs.pair

local c = {
	DialogueChoice = world:entity() :: types.Entity,
	DialogueChoiceContainer = world:entity() :: types.Entity,
	DialogueResponse = world:entity() :: types.Entity,
	DialogueCallback = world:component() :: types.Entity<() -> ()>,
	DialogueIf = world:component() :: types.Entity<() -> ()>,
	DialogueSuccess = world:entity() :: types.Entity,
	DialougeFailure = world:entity() :: types.Entity,
	DialougeGoto = world:entity() :: types.Entity,
	DialogueText = world:component() :: types.Entity<string>,
	DialogueKey = world:component() :: types.Entity<string>,
	Next = world:entity() :: types.Entity,
	Parent = world:component() :: types.Entity<types.Entity>,
}

-- We can add a constraint like this
-- Ever entity will have a single pair(Next, ) unless it is a choice
local root = world:entity()
local r1 = world:entity()
world:set(root, c.DialogueKey, "dialogue_id")
world:add(root, pair(c.Next, r1))

local cmajor1 = world:entity()

world:set(r1, c.Parent, root)
world:add(r1, c.DialogueResponse)
world:set(r1, c.DialogueText, "response_1")
world:add(r1, pair(c.Next, cmajor1))

local c1 = world:entity()
local c2 = world:entity()
local c3 = world:entity()

world:set(cmajor1, c.Parent, r1)
world:add(cmajor1, c.DialogueChoiceContainer)
world:add(cmajor1, pair(c.Next, c1))
world:add(cmajor1, pair(c.Next, c2))
world:add(cmajor1, pair(c.Next, c3))

local c1r2 = world:entity()

world:set(c1, c.Parent, cmajor1)
world:set(c1, c.DialogueText, "choice_1_text")
world:add(c1, c.DialogueChoice)
world:add(c1, pair(c.Next, c1r2))

world:set(c2, c.Parent, cmajor1)
world:set(c2, c.DialogueText, "choice_2_text")
world:add(c2, c.DialogueChoice)

local c3con1 = world:entity()

world:set(c3, c.Parent, cmajor1)
world:set(c3, c.DialogueText, "choice_2_text")
world:add(c3, c.DialogueChoice)
world:add(c3, pair(c.Next, c3con1))

local c1r3 = world:entity()

world:set(c1r2, c.Parent, c1)
world:add(c1r2, c.DialogueResponse)
world:set(c1r2, c.DialogueText, "response text 2 here")
world:add(c1r2, pair(c.Next, c1r3))

local c1cal1 = world:entity()

world:set(c1r3, c.Parent, c1r2)
world:add(c1r3, c.DialogueResponse)
world:set(c1r3, c.DialogueText, "response text 3 here")
world:add(c1r3, pair(c.Next, c1cal1))

local c1g1 = world:entity()
world:set(c1cal1, c.Parent, c1r3)
world:set(c1cal1, c.DialogueCallback, function() end)
world:add(c1cal1, pair(c.Next, c1g1))

world:set(c1g1, c.Parent, c1cal1)
world:set(c1g1, c.DialougeGoto)
world:set(c1g1, c.DialogueKey, "one")

-- At this point, the Choice 1 tree from the start is completed
-- Choice 2 doesn't contain any nodes, so I will ignore it
-- Now we traverse through choice 3's nodes and build the tree

-- NOTE, this function will be yieldable, what we will do is future it, and then
-- spawn a seperate entity that evaluates the poll (itwill timeout in 5 seconds max), once that
-- poll completed, we traverse to either Success, or Failure
local success1 = world:entity()
local failure1 = world:entity()

world:set(c3con1, c.DialogueIf, function() end)
world:set(c3con1, c.DialogueText, "text-to-display-while-condition-yields")
world:add(c3con1, pair(c.DialogueSuccess, success1))
world:add(c3con1, pair(c.DialougeFailure, failure1))

local success_r1 = world:entity()

world:set(success1, c.Parent, c3con1)
world:add(success1, c.DialogueSuccess)
world:set(success1, pair(c.Next, success_r1))

world:set(success_r1, c.Parent, success1)
world:add(success_r1, c.DialogueResponse)
world:set(success_r1, c.DialogueText, "after success response text here")

-- Done with that tree, now we move on to failure tree
local failure_callback1 = world:entity()

world:set(failure1, c.Parent, c3con1)
world:add(failure1, c.DialougeFailure)
world:set(failure1, pair(c.Next, failure_callback1))

local choicecontainer2 = world:entity()

world:set(failure_callback1, c.Parent, failure1)
world:set(failure_callback1, c.DialogueCallback, function() end)
world:set(failure_callback1, pair(c.Next, choicecontainer2))

local c4 = world:entity()
local c5 = world:entity()

world:set(choicecontainer2, c.Parent, failure_callback1)
world:set(choicecontainer2, c.DialogueChoiceContainer)
world:add(choicecontainer2, pair(c.Next, c4))
world:add(choicecontainer2, pair(c.Next, c5))

world:set(c4, c.Parent, choicecontainer2)
world:add(c4, c.DialogueChoice)
world:set(c4, c.DialogueText, "choice 4 text")

world:set(c5, c.Parent, choicecontainer2)
world:add(c5, c.DialogueChoice)
world:set(c5, c.DialogueText, "choice 5 text")
