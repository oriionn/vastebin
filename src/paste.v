module main

pub fn (app &App) paste_exists(paste_id int) bool {
	if paste_id == 0 {
		return false
	}

	pastes := sql app.database {
		select from Paste where id == paste_id
	} or {
		return false
	}

	return pastes.len != 0
}