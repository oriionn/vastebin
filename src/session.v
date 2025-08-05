module main

import rand
import time

pub fn (app &App) create_session(user_id int, ip string) !string {
	uuid := rand.uuid_v4()

	expire_at := time.now().add_days(3).local_to_utc()

	session := Session{
		user_id: user_id
		value: uuid
		ip: ip,
		expire_at: expire_at
	}

	sql app.database {
		insert session into Session
	}!

	return uuid
}

pub fn (app &App) delete_session(session_id int) bool {
	sql app.database {
		delete from Session where id == session_id
	} or {
		return false
	}
	return true
}
