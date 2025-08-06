module main

import os
import db.sqlite
import time

@[table: 'users']
struct User {
	id int @[primary; serial]
	username string
	password string
}

@[table: 'sessions']
struct Session {
	id int @[primary; serial]
	user_id int
	value string
	ip string

	created_at time.Time @[default: '(unixepoch())']
	expire_at time.Time
}

@[table: 'pastes']
struct Paste {
	id int @[primary; serial]
	user_id int
	content string
	created_at time.Time @[default: '(unixepoch())']
}

pub fn init_db() !sqlite.DB {
	db_path := os.join_path(__dirname, "vastebin.db")
	db := sqlite.connect(db_path)!

	sql db {
		create table User
		create table Session
		create table Paste
	}!

	return db
}
