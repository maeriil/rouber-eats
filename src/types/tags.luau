return {
	Door = "DoorRelated",
	SlidingDoor = "SlidingDoor",
	DoorMat = "DoorMat",
	Teleport = "TeleportZone",
	Restaurant = "Restaurant",

	-- Only DialogueConfiguration contains this tag. But basically it means that any instance
	-- that owns this configuration is interactable. We should first verify on runtime that
	-- we have added required properties for it and then add to world
	Dialogue = "Dialogue",
}
