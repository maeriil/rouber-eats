--[[
  The purpose of this file is to ensure that client has completed the setup before the server
  sends other details that depend on those setups.

  For example:
    We want the server to only figure out a proper vacant house

]]

type RequestStatus = {
	server_sent: boolean,
	client_completed: boolean,
}

type Config = {
	loaded_in: RequestStatus,
	restaurant_setup: RequestStatus,
	house_setup: RequestStatus,
	map_setup: RequestStatus,
	order_setup: RequestStatus,
}

return {} :: { [Player]: Config }
