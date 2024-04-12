#!/usr/bin/env bash
# -*- mode: sh; tab-width: 2; -*-

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

weeks() {
	bc -l <<< "scale=2; $1 / 604800"
}


humanize() {
	local -i weeks
	weeks="$(( $1 / 604800 ))"

	local -i days
	days="$(( ($1 / 86400) - (($1 / 604800) * 7) ))"

	local -i hours
	hours="$(( ($1 / 3600) - (($1 / 86400) * 24) ))"

	local -i minutes
	minutes="$(( ($1 / 60) - (($1 / 3600) * 60) ))"

	local -i seconds
	seconds="$(( $1 - (($1 / 60) * 60) ))"

	printf '%dw %dd %dh %dm %ds\n' ${weeks} ${days} ${hours} ${minutes} ${seconds}
}

declare -A logs

readonly now="$(date +%s)"

readarray -t lines <data

for (( i=0; i<${#lines[@]}; i++ )); do
	IFS=' ' read -r label timestamp <<< "${lines[$i]}"

	if (( i == 0 )); then
		logs[${label}]=$(( now - timestamp ))
	else
		logs[${label}]=$(( previous - timestamp ))
  fi

	previous=${timestamp}
done

for label in "${!logs[@]}"; do
	printf '%s\t%s\n' "${label}" "$(humanize "${logs[${label}]}")"
done

