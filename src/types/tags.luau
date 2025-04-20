return {
-- stylua: ignore start
  Door            = "DoorRelated",
  SlidingDoor     = "SlidingDoor",
  DoubleDoor      = "DoubleDoor",
  DoorMat         = "DoorMat",
  Teleport        = "TeleportZone",
  Restaurant      = "Restaurant",
  Store           = "Store",
  StoreNoInterior = "StoreNoInterior",
  House           = "House",
  Interior        = "Interior",
  Exterior        = "Exterior",
  HouseOwner      = "HouseOwner",


	-- Only DialogueConfiguration contains this tag. But basically it means that any instance
	-- that owns this configuration is interactable. We should first verify on runtime that
	-- we have added required properties for it and then add to world
  Dialogue        = "Dialogue",

	-- stylua: ignore end
}
