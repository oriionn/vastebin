module main

import veb
import os
import db.sqlite
import net.http
import v.embed_file
import flag

const __dirname = os.dir(os.executable())

pub struct Context {
	veb.Context
	pub mut:
		auth bool
		user int
}

pub struct App {
	veb.Middleware[Context]
	mut:
		database sqlite.DB
		disable_sign_up bool
}

const create_paste_html = $embed_file("pages/create_paste.html")
const dashboard_html = $embed_file("pages/dashboard.html")
const index_html = $embed_file("pages/index.html")
const signin_html = $embed_file("pages/signin.html")
const signup_html = $embed_file("pages/signup.html")
const view_paste_html = $embed_file("pages/view_paste.html")
const delete_html = $embed_file("pages/delete.html")
const password_html = $embed_file("pages/change_password.html")

pub fn (mut ctx Context) render(file embed_file.EmbedFileData, id ?int) veb.Result {
	current_id := id or { 0 }

	if current_id == 0 {
		return ctx.html(file.to_string())
	}

	mut content := file.to_string()
	content = content.replace("{id}", current_id.str())
	return ctx.html(content)
}

@[get]
pub fn (app &App) index(mut ctx Context) veb.Result {
	enabled_sign_up := !app.disable_sign_up
	mut content := index_html.to_string()
	content = content.replace("{enabled}", enabled_sign_up.str())
	return ctx.html(content)
}

@["/sign-in"; get]
pub fn (app &App) signin(mut ctx Context) veb.Result {
	return ctx.render(signin_html, none)
}

@["/sign-up"; get]
pub fn (app &App) signup(mut ctx Context) veb.Result {
	if app.disable_sign_up {
		return ctx.error_page(http.Status.not_found)
	}
	return ctx.render(signup_html, none)
}

@["/dashboard"; get]
pub fn (app &App) dashboard(mut ctx Context) veb.Result {
	return ctx.render(dashboard_html, none)
}

@["/dashboard/password"]
pub fn (app &App) password(mut ctx Context) veb.Result {
	return ctx.render(password_html, none)
}

@["/create"; get]
pub fn (app &App) create(mut ctx Context) veb.Result {
	return ctx.render(create_paste_html, none)
}

@["/paste/:id"; get]
pub fn (app &App) view_paste(mut ctx Context, id int) veb.Result {
	if app.paste_exists(id) == false {
		return ctx.error_page(http.Status.not_found)
	}
	return ctx.render(view_paste_html, id)
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

	sql app.database {
		update Paste set views = views + 1 where id == paste_id
	} or {
		ctx.internal_err()
	}

	return ctx.text(paste[0].content)
}

@["/actions/delete"]
pub fn (app &App) delete_paste(mut ctx Context) veb.Result {
	return ctx.render(delete_html, none)
}

@["/not_found"; get] 
pub fn (app &App) custom_not_found(mut ctx Context) veb.Result {
	return ctx.error_page(http.Status.not_found)
} 

fn main() {
	mut fp := flag.new_flag_parser(os.args)
	fp.application("vastebin")
	fp.description("A lightweight pastebin alternative written in V")
	fp.version("1.0.0")
	fp.skip_executable()

	port := fp.int("port", `p`, 8080, "Listening port for web server")
	disable_sign_up := fp.bool("disable-sign-up", `d`, false, "Disable sign up")
	fp.finalize() or {
        eprintln(err)
        println(fp.usage())
        return
    }

	db := init_db() or {
		println(err)
		println("Error occurred when the database connection was initializing")
		exit(1)
	}

	mut app := &App{
		database: db
		disable_sign_up: disable_sign_up
	}

	app.use(handler: app.auth)
	app.use(handler: app.logger)

	veb.run[App, Context](mut app, port)
}