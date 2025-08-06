module main

import net.http
import json
import veb
import os

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

pub fn (mut ctx Context) internal_err() veb.Result {
	return ctx.custom_error(http.Status.internal_server_error, "Internal Server Error")
}

pub fn (mut ctx Context) error_page(status http.Status) veb.Result {
	path := os.join_path(__dirname, 'pages', 'error.html')

	mut content := os.read_file(path) or {
		return ctx.text("Internal Server Error")
	}
	content = content.replace("{code}", int(status).str())
	content = content.replace("{error}", status.str())
	return ctx.html(content)
}