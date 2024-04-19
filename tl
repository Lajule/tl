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
		printf '%dw %dd %dh %dm %ds\n' ${weeks} ${days} ${hours} ${minutes} ${seconds}
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

declare -A logs

readarray -t lines <data

previous="$(date +%s)"

for (( i=0; i<${#lines[@]}; i++ )); do
	IFS=' ' read -r label timestamp <<< "${lines[$i]}"

	value=$(( previous - timestamp ))

	old=${logs[${label}]}
	if [[ -n ${old} ]]; then
		logs[${label}]=$(( old + value ))
  else
		logs[${label}]=$(( value ))
	fi

	previous=${timestamp}
done

while getopts ':smhwH' opt; do
  case ${opt} in
    s)
			for label in "${!logs[@]}"; do
				printf '%s\t%s\n' "${label}" "$(seconds "${logs[${label}]}")"
			done
			;;
    m)
			for label in "${!logs[@]}"; do
				printf '%s\t%s\n' "${label}" "$(minutes "${logs[${label}]}")"
			done
			;;
    h)
			for label in "${!logs[@]}"; do
				printf '%s\t%s\n' "${label}" "$(hours "${logs[${label}]}")"
			done
			;;
    w)
			for label in "${!logs[@]}"; do
				printf '%s\t%s\n' "${label}" "$(weeks "${logs[${label}]}")"
			done
			;;
    H)
			for label in "${!logs[@]}"; do
				printf '%s\t%s\n' "${label}" "$(humanize "${logs[${label}]}")"
			done
			;;
    ?)
      echo "Invalid option: -${OPTARG}."
      exit 1
      ;;
  esac
done

shift $((OPTIND-1))

if (( $# > 0 )); then
	printf '%s %d\n%s' "$1" "$(date +%s)" "$(cat data)" >data
fi
