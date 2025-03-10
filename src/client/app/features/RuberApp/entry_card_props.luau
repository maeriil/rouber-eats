--[[
    no matter what card variant we use (EntryCard, EntryCardExpanded or Minimal), we still
    want to provide same information props so that it can choose to display what kind of
    information it needs to dispay
]]

-- luau issue
export type OrderType = "grocery" | "delivery"

export type EntryCardDetails = {
	order_id: string,
	type: OrderType,
	delivery_rating: number,
	payment: number,
	time: number,
	distance: number,
	reputation_points: number,

	-- restaurant details
	restaurant_name: string,
	restaurant_address: string,
	dist_to_restaurant: number,
	time_to_restaurant: number,
	orders: {
		{
			order_receipt_id: number,
			order_details: string,
		}
	},

	-- destination details
	dest_address: string,
	dist_to_dest_from_restaurant: number,
	time_to_dest_from_restaurant: number,
	expected_tips: number,
	additional_instructions: { string },
}

return 0
