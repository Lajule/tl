#!/usr/bin/env bash

seconds() {
	printf '%ds\n' "$1"
}

minutes() {
	printf '%sh\n' "$(bc -l <<< "scale=2; $1 / 60")"
}

hours() {
	printf '%sh\n' "$(bc -l <<< "scale=2; $1 / (60 * 60)")"
}

days() {
	printf '%sh\n' "$(bc -l <<< "scale=2; $1 / (60 * 60 * 24)")"
}

humanize() {
	local -i days
	days="$(bc -l <<< "scale=0; $1 / (60 * 60 * 24)")"

	local -i hours
	hours="$(bc -l <<< "scale=0; ($1 / (60 * 60)) - ($days * 24)")"

	local -i reminder
	reminder="$(bc -l <<< "scale=0; $1 / (60 * 60)")"

	local -i minutes
	minutes="$(bc -l <<< "scale=0; ($1 / 60) - ($reminder * 60)")"

	local -i seconds
	reminder="$(bc -l <<< "scale=0; $1 / 60")"
	seconds="$(bc -l <<< "scale=0; $1 - ($reminder * 60)")"

	printf "%dd %dh %dm %ds\n" $days $hours $minutes $seconds
}

seconds $1
minutes $1
hours $1
days $1
humanize $1
