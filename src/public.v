module main

import v.embed_file
import veb

const create_paste_js = $embed_file("public/scripts/create_paste.js")
const dashboard_js = $embed_file("public/scripts/dashboard.js")
const global_js = $embed_file("public/scripts/global.js")
const need_auth_js = $embed_file("public/scripts/need_auth.js")
const no_auth_js = $embed_file("public/scripts/no_auth.js")
const signin_js = $embed_file("public/scripts/signin.js")
const signup_js = $embed_file("public/scripts/signup.js")
const view_paste_js = $embed_file("public/scripts/view_paste.js")
const index_js = $embed_file("public/scripts/index.js")

const dashboard_css = $embed_file("public/styles/dashboard.css")
const error_css = $embed_file("public/styles/error.css")
const global_css = $embed_file("public/styles/global.css")
const index_css = $embed_file("public/styles/index.css")
const paste_css = $embed_file("public/styles/paste.css")
const signin_css = $embed_file("public/styles/signin.css")

pub fn (mut ctx Context) javascript(file embed_file.EmbedFileData) veb.Result {
	return ctx.send_response_to_client("text/javascript; charset=UTF-8", file.to_string())
}

pub fn (mut ctx Context) css(file embed_file.EmbedFileData) veb.Result {
	return ctx.send_response_to_client("text/css; charset=UTF-8", file.to_string())
}

@["/public/scripts/create_paste.js"; get]
pub fn (app &App) create_paste_js(mut ctx Context) veb.Result {
	return ctx.javascript(create_paste_js)
}

@["/public/scripts/dashboard.js"; get]
pub fn (app &App) dashboard_js(mut ctx Context) veb.Result {
	return ctx.javascript(dashboard_js)
}

@["/public/scripts/global.js"; get]
pub fn (app &App) global_js(mut ctx Context) veb.Result {
	return ctx.javascript(global_js)
}

@["/public/scripts/need_auth.js"; get]
pub fn (app &App) need_auth_js(mut ctx Context) veb.Result {
	return ctx.javascript(need_auth_js)
}

@["/public/scripts/no_auth.js"; get]
pub fn (app &App) no_auth_js(mut ctx Context) veb.Result {
	return ctx.javascript(no_auth_js)
}

@["/public/scripts/signin.js"; get]
pub fn (app &App) signin_js(mut ctx Context) veb.Result {
	return ctx.javascript(signin_js)
}

@["/public/scripts/signup.js"; get]
pub fn (app &App) signup_js(mut ctx Context) veb.Result {
	return ctx.javascript(signup_js)
}

@["/public/scripts/view_paste.js"; get]
pub fn (app &App) view_paste_js(mut ctx Context) veb.Result {
	return ctx.javascript(view_paste_js)
}

@["/public/scripts/index.js"; get]
pub fn (app &App) index_js(mut ctx Context) veb.Result {
	return ctx.javascript(index_js)
}

@["/public/styles/dashboard.css"; get]
pub fn (app &App) dashboard_css(mut ctx Context) veb.Result {
	return ctx.css(dashboard_css)
}

@["/public/styles/error.css"; get]
pub fn (app &App) error_css(mut ctx Context) veb.Result {
	return ctx.css(error_css)
}

@["/public/styles/global.css"; get]
pub fn (app &App) global_css(mut ctx Context) veb.Result {
	return ctx.css(global_css)
}

@["/public/styles/index.css"; get]
pub fn (app &App) index_css(mut ctx Context) veb.Result {
	return ctx.css(index_css)
}

@["/public/styles/paste.css"; get]
pub fn (app &App) paste_css(mut ctx Context) veb.Result {
	return ctx.css(paste_css)
}

@["/public/styles/signin.css"; get] 
pub fn (app &App) signin_css(mut ctx Context) veb.Result {
	return ctx.css(signin_css)
}