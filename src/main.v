module main

import veb
import os
import db.sqlite

const __dirname = os.dir(os.executable())

pub struct Context {
	veb.Context
}

pub struct App {
	veb.StaticHandler
	mut:
		database sqlite.DB
}

pub fn render(mut ctx Context, page string) veb.Result {
	return ctx.file(os.join_path(__dirname, 'pages', page + '.html'))
}

@[get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	return render(mut ctx, 'index')
}

@["/sign-in"; get]
pub fn (app &App) signin(mut ctx Context) veb.Result {
	return render(mut ctx, 'signin')
}

@["/sign-up"; get]
pub fn (app &App) signup(mut ctx Context) veb.Result {
	return render(mut ctx, 'signup')
}

fn main() {
	db := init_db() or {
		println(err)
		println("Error occurred when the database connection was initializing")
		exit(1)
	}

	mut app := &App{
		database: db
	}

	app.mount_static_folder_at(os.join_path(__dirname, 'public'), '/public')!

	// Pass the App and context type and start the web server on port 8080
	veb.run[App, Context](mut app, 8080)
}
