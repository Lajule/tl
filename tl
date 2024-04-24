#!/usr/bin/env bash
# -*- mode: sh; tab-width: 2; -*-

me="${0##*/}"
abort() {
	printf '%s: %s\n' "$me" "$*" >&2
	exit 1
}

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
	weeks=$(( $1 / 604800 ))
	local -i days
	days=$(( ($1 / 86400) - (($1 / 604800) * 7) ))
	local -i hours
	hours=$(( ($1 / 3600) - (($1 / 86400) * 24) ))
	local -i minutes
	minutes=$(( ($1 / 60) - (($1 / 3600) * 60) ))
	local -i seconds
	seconds=$(( $1 - (($1 / 60) * 60) ))
	if (( weeks > 0 )); then
		printf '%dw %dd %dh %dm %ds\n' ${weeks} ${days} ${hours} ${minutes} \
			${seconds}
	elif (( days > 0 )); then
		printf '%dd %dh %dm %ds\n' ${days} ${hours} ${minutes} ${seconds}
	elif (( hours > 0 )); then
		printf '%dh %dm %ds\n' ${hours} ${minutes} ${seconds}
	elif (( minutes > 0 )); then
		printf '%dm %ds\n' ${minutes} ${seconds}
	else
		printf '%ds\n' ${seconds}
	fi
}

data="${TLFILE:-.tl}"
silent=0
reset=0
func='humanize'

while getopts ':srSmhdwH' flag; do
	case "${flag}" in
		s) silent=1;;
		r) reset=1;;
		S) func='seconds';;
		m) func='minutes';;
		h) func='hours';;
		d) func='days';;
		w) func='weeks';;
		H) func='humanize';;
		?) abort "invalid option: -${OPTARG}.";;
	esac
done

shift $((OPTIND-1))

if ! hash bc >&/dev/null; then
	abort "bc could not be found, please install it to use this script."
fi

if (( reset == 1 )); then
	rm -f "${data}"
fi

if (( $# > 0 )); then
	if [[ ! "$1" =~ ^[[:alnum:]]+$ ]]; then
		abort "invalid label: $1."
	fi

	if [[ ! -f "${data}" ]]; then
		touch "${data}"
	fi

	printf '%s %d\n%s' "$1" "$(date +%s)" "$(cat "${data}")" >"${data}"
fi

if [[ -f "${data}" ]] && (( silent == 0 )); then
	declare -A logs
	readarray -t lines <"${data}"
	previous="$(date +%s)"

	for (( i=0; i<${#lines[@]}; i++ )); do
		IFS=' ' read -r label timestamp <<< "${lines[$i]}"
		value=$(( previous - timestamp ))
		old="${logs[${label}]}"
		if [[ -n "${old}" ]]; then
			logs[${label}]=$(( old + value ))
		else
			logs[${label}]=$(( value ))
		fi
		previous="${timestamp}"
	done

	for label in "${!logs[@]}"; do
		printf '%s %s\n' "${label}" "$($func "${logs[${label}]}")"
	done
fi
