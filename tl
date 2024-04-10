#!/usr/bin/env bash

seconds() {
	echo "$1"
}

minutes() {
        bc -l <<< "scale=2; $1 / 60"
}

hours() {
        bc -l <<< "scale=2; $1 / 3600"
}

days() {
        bc -l <<< "scale=2; $1 / 86400"
}

humanize() {
	local -i days
	days="$(bc -l <<< "scale=0; $1 / 86400")"

	local -i hours
	hours="$(bc -l <<< "scale=0; ($1 / 3600) - ($days * 24)")"

	local -i reminder
	reminder="$(bc -l <<< "scale=0; $1 / 3600")"

	local -i minutes
	minutes="$(bc -l <<< "scale=0; ($1 / 60) - ($reminder * 60)")"

	local -i seconds
	reminder="$(bc -l <<< "scale=0; $1 / 60")"
	seconds="$(bc -l <<< "scale=0; $1 - ($reminder * 60)")"

	printf '%dd %dh %dm %ds\n' $days $hours $minutes $seconds
}

