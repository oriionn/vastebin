module main

pub fn (app &App) logger(mut ctx Context) bool {
	println("[veb] ${ctx.req.method} ${ctx.req.url}")
	return true
}
