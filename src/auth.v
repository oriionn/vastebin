module main

import net.http
import time

pub fn (app &App) auth(mut ctx Context) bool {
	now := time.now().local_to_utc()

	sessions := sql app.database {
		select from Session where expire_at < now
	} or {
		ctx.auth = false
		return true
	}

	for session in sessions {
		app.delete_session(session.id)
	}

	mut session := ctx.get_header(http.CommonHeader.authorization) or {
		ctx.auth = false
		return true
	}

	if !session.starts_with("Bearer ") {
		ctx.auth = false
		return true
	}

	session = session[7..]

	session_db := sql app.database {
		select from Session where value == session
	} or {
		ctx.auth = false
		return true
	}

	if session_db.len == 0 {
		ctx.auth = false
		return true
	}

	ctx.auth = true
	return true
}
