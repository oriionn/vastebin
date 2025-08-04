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
    	return ctx.custom_error(http.Status.internal_server_error, "Internal server error")
    }

    if users.len != 0 {
    	return ctx.custom_error(http.Status.conflict, "Username is already taken")
    }

    hash_password := bcrypt.generate_from_password(body.password.bytes(), bcrypt_cost) or {
    	return ctx.custom_error(http.Status.internal_server_error, "Internal server error")
    }

    mut user := User{
	    username: body.username
		password: hash_password
    }

    sql app.database {
    	insert user into User
    } or {
    	return ctx.custom_error(http.Status.internal_server_error, "Internal server error")
    }

    users = sql app.database {
    	select from User where username == body.username limit 1
    } or {
    	return ctx.custom_error(http.Status.internal_server_error, "Internal server error")
    }

    user = users[0]
    session := app.create_session(user.id, ctx.ip()) or {
    	return ctx.custom_error(http.Status.internal_server_error, "Internal server error")
    }

	return ctx.json(BaseResponse{
		status: int(http.Status.ok),
		message: session
	})
}
