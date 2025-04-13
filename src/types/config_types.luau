local t = require(script.Parent)
-- stylua: ignore start

--[[
  Poses category configuration is used for systems to display on UI all the details
  about the category. This include things like the names, what poses it has in this
  category, and more importantly, the hint description.

  Whenever we create an order, we don't want to outright say that an order has
  X preferences, instead we want to use hints to kinda tell UI that these preferences
  are prefered

  As such, we have two descriptions, one for positive, and one for negative. Each owner has like
  like and dislike, and we want to kind hint those to the player
]]
export type rouber_poses_category_config_t = {
  name                      : t.rouber_pose_category_t;
  display_name              : string;
  display_image             : string;
  description               : string;
  list_of_poses             : t.Array<string>;
  positive_hint_description : string;
  negative_hint_description : string;
}

--[[
  Pose configuration file contains the main yieldable_run function which will be used to play the
  cutscene animation when we need to run it. Run is a yieldable function so it is important to run
  it in a new thread

  The animation id is the core animation of the pose. However, the actual cutscene could have
  multiple camera manipulation, as well as halting code until animation completed and etc, which is
  why the function is named yieldable_run
]]
export type rouber_pose_config_t = {
  name          : t.rouber_pose_t;
  display_name  : string;
  rating        : number;
  category      : t.rouber_pose_category_t;
  yieldable_run : () -> ();
  animation_id  : Animation;
  description   : string;
}

--[[
  NPC configuration file. These are essentially npcs that will always exist in the game. This is
  different from NPCs that are created at runtime to "fill up empty spaces". This term basically
  refers to when a player leaves a landspot, and it is vacant, which means we would need to fill it
  up with some runtime NPCs.

  These static NPCs will always have a predefined house types they will have, as well as preferences
  and etc.

  The conditions are basically the additional rewards the NPC provides when we fullfil one of the
  listed conditions while delivering it to them
]]
export type rouber_npc_config_t = {
  name                    : string,
  display_name            : string,
  house_type              : string,
  house_location_id       : string,
  preferred_pose_category : t.rouber_pose_category_t,
  disliked_pose_category  : t.rouber_pose_category_t,
  model                   : Model,
  conditions              : t.Array<t.Entity>,
  conditions_met_rewards  : t.Array<t.Entity>,
  preferred_food_addons   : t.Array<t.Entity>,
  disliked_food_addons    : t.Array<t.Entity>,
  liked_strike_emotion    : t.rouber_emotion_t,
  disliked_strike_emotion : t.rouber_emotion_t,
  neutral_strike_emotion  : t.rouber_emotion_t,
}

--[[
  Emotions are similar to what we see in Work at Pizza place. They can be used for both NPCs
  and for regular players. They are just some ways we can display emotions on the character.
  Something we can additionally choose to conigure later is to show the emotion as a dialogue as
  well. Or some kind of effects that play alongside
]]
export type rouber_emotion_config_t = {
  name          : t.rouber_emotion_t,
  display_name  : string,
  display_image : string,
  animation     : Animation,
}

--[[
  Delivery conditions are some fun little tasks that players can do alongside while doing the
  delivery. They can be thought of like a bunch of checklist. Completing the conditions results
  in more rewards than the base listed rewards.

  Conditions also have some kind of lifecycle, that is, they have a duration where they are
  valid. For example, a condition about delivering food whilst it is hot, would have a start_phase
  of when Pickup occurs, and an end_phase when Drop off occurs. So this condition would be
  "active" during this interval
]]
export type rouber_delivery_conditions_config_t = {
  name                    : t.rouber_delivery_conditions_t,
  display_name            : string,
  description             : string,
  entity_id               : t.Entity,
  start_phase             : t.Entity,
  end_phase               : t.Entity,
  create_order_condition  : (parent_order_id: t.Entity) -> t.Entity,
  is_condition_successful : (ticket_id: t.Entity) -> boolean
}

-- stylua: ignore end

return 0
