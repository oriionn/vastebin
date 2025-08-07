all: compile

test:
	v run src/

compile:
	v src/ -o vastebin -prod