-- stylua: ignore start

--[[
  All the furnishing items that the player owns displayed to the UI
]]
export type BackpackFurnishings = {
  display_name : string,
  model        : Model,
  count        : number,
}

--[[
  All the poses that the player owns displayed to the UI. In future, I think we might
  want to display the pose animation too? Not sure
]]
export type BackpackPoses = {
  display_name : string,
  pose_image   : string,
}

-- stylua: ignore end
return 0
