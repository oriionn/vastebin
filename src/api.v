module main

import veb
import json
import crypto.bcrypt
import net.http

const bcrypt_cost = 12

struct SignInBody {
	mut:
		username string
		password string
}

struct PasteBody {
	mut:
		content string
}

@["/api/sign-up"; post]
pub fn (app &App) api_signup(mut ctx Context) veb.Result {
	raw_body := ctx.req.data
	body := json.decode(SignInBody, raw_body) or {
		return ctx.custom_error(http.Status.bad_request, "Invalid body")
	}

	if body.username == "" || body.password == "" {
		return ctx.custom_error(http.Status.bad_request, "Invalid body")
	}

 	if body.username.contains(" ") {
    	return ctx.custom_error(http.Status.not_acceptable, "Invalid username/password")
    }

    mut users := sql app.database {
    	select from User where username == body.username limit 1
    } or {
    	return ctx.internal_err()
    }

    if users.len != 0 {
    	return ctx.custom_error(http.Status.conflict, "Username is already taken")
    }

    hash_password := bcrypt.generate_from_password(body.password.bytes(), bcrypt_cost) or {
    	return ctx.internal_err()
    }

    mut user := User{
	    username: body.username
		password: hash_password
    }

    user_id := sql app.database {
    	insert user into User
    } or {
    	return ctx.internal_err()
    }

    session := app.create_session(user_id, ctx.ip()) or {
    	return ctx.internal_err()
    }

	return ctx.json(BaseResponse{
		status: int(http.Status.ok),
		message: session
	})
}

@["/api/sign-in"; post]
pub fn (app &App) api_signin(mut ctx Context) veb.Result {
	raw_body := ctx.req.data
	body := json.decode(SignInBody, raw_body) or {
		return ctx.custom_error(http.Status.bad_request, "Invalid body")
	}

	if body.username == "" || body.password == "" {
		return ctx.custom_error(http.Status.bad_request, "Invalid body")
	}

	mut users := sql app.database {
    	select from User where username == body.username limit 1
    } or {
    	return ctx.internal_err()
    }

    if users.len == 0 {
    	return ctx.custom_error(http.Status.not_found, "Invalid username")
    }
    user := users[0]

    bcrypt.compare_hash_and_password(body.password.bytes(), user.password.bytes()) or {
    	return ctx.custom_error(http.Status.forbidden, "Invalid password")
    }

    session := app.create_session(user.id, ctx.ip()) or {
    	return ctx.internal_err()
    }

    return ctx.json(BaseResponse{
		status: int(http.Status.ok),
		message: session
	})
}

@['/api/session'; get]
pub fn (app &App) api_session(mut ctx Context) veb.Result {
	return ctx.json(BaseResponse{
		status: int(http.Status.ok),
		message: ctx.auth.str()
	})
}

@['/api/username'; get]
pub fn (app &App) api_username(mut ctx Context) veb.Result {
	query_username := ctx.query['u'] or {
		return ctx.custom_error(http.Status.bad_request, "Invalid query")
	}

	users := sql app.database {
		select from User where username == query_username
	} or {
		return ctx.internal_err()
	}

	return ctx.json(BaseResponse{
		status: int(http.Status.ok),
		message: (users.len == 0).str()
	})
}

@['/api/paste'; post]
pub fn (app &App) api_paste(mut ctx Context) veb.Result {
	raw_body := ctx.req.data
	body := json.decode(PasteBody, raw_body) or {
		return ctx.custom_error(http.Status.bad_request, "Invalid body")
	}

	if body.content == "" {
		return ctx.custom_error(http.Status.bad_request, "Invalid body")
	}

	if ctx.auth != true {
		return ctx.custom_error(http.Status.forbidden, "No session provided")
	}

	paste := Paste{
		user_id: ctx.user,
		content: body.content
	}

	paste_id := sql app.database {
		insert paste into Paste
	} or {
		return ctx.internal_err()
	}

	return ctx.json(BaseResponse{
		status: int(http.Status.ok),
		message: paste_id.str()
	})
}
