module main

import net.http
import json
import veb

struct BaseResponse {
	status int
	message string
}

pub fn (mut ctx Context) custom_error(status http.Status, message string) veb.Result {
	ctx.res.set_status(status)

	body := BaseResponse{
		status: int(status),
		message: message
	}

	return ctx.json(json.encode(body))
}
