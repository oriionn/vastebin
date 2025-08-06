module main

import veb
import os
import db.sqlite
import net.http

const __dirname = os.dir(os.executable())

pub struct Context {
	veb.Context
	pub mut:
		auth bool
		user int
}

pub struct App {
	veb.StaticHandler
	veb.Middleware[Context]
	mut:
		database sqlite.DB
}

pub fn (mut ctx Context) render(page string, id ?int) veb.Result {
	current_id := id or { 0 }

	path := os.join_path(__dirname, 'pages', page + '.html')
	if current_id == 0 {
		return ctx.file(path)
	}

	mut content := os.read_file(path) or {
		return ctx.error_page(http.Status.internal_server_error)
	}
	content = content.replace("{id}", current_id.str())
	return ctx.html(content)
}

@[get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	return ctx.render('index', none)
}

@["/sign-in"; get]
pub fn (app &App) signin(mut ctx Context) veb.Result {
	return ctx.render('signin', none)
}

@["/sign-up"; get]
pub fn (app &App) signup(mut ctx Context) veb.Result {
	return ctx.render('signup', none)
}

@["/dashboard"; get]
pub fn (app &App) dashboard(mut ctx Context) veb.Result {
	return ctx.render('dashboard', none)
}

@["/create"; get]
pub fn (app &App) create(mut ctx Context) veb.Result {
	return ctx.render('create_paste', none)
}

@["/paste/:id"; get]
pub fn (app &App) view_paste(mut ctx Context, id int) veb.Result {
	if app.paste_exists(id) == false {
		return ctx.error_page(http.Status.not_found)
	}
	return ctx.render('view_paste', id)
}

@["/raw/:id"; get]
pub fn (app &App) raw_paste(mut ctx Context, paste_id int) veb.Result {
	if app.paste_exists(paste_id) == false {
		return ctx.error_page(http.Status.not_found)
	}
	paste := sql app.database {
		select from Paste where id == paste_id
	} or {
		return ctx.error_page(http.Status.not_found)
	}

	return ctx.text(paste[0].content)
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
	app.use(handler: app.auth)
	app.use(handler: app.logger)

	// Pass the App and context type and start the web server on port 8080
	veb.run[App, Context](mut app, 8080)
}
