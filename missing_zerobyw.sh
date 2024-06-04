#!/usr/bin/env -S bash

# To check out missed out downloads from Zerobyw.

missing_volumes() {
	declare -a directories

	# Store all lower-level directories in the given path
	while IFS= read -r dir; do
		directories+=("$dir")
	done < <(find -E "$1" -type d -path "./**/*" -prune)

	for dir in "${directories[@]}"; do
		echo -e "\n$dir"
		declare -a volumes

		# Store all volumes in the given path
		while IFS= read -r single; do
			volumes+=("$single")
		done < <(awk '{ print $NF }' <<<"$(/bin/ls -l "$dir"/*.cbz)" |
			xargs -n 1 -I {} bash -c 'basename -s .cbz $(echo "${1##*/}")' _ {} |
			xargs -n 1 -I {} bash -c 'echo "${1//[^[:digit:]]/}"' _ {})

		# Manage missing volumes
		output=()
		for i in $(seq -f "%02g" "$start" "$end"); do
			if [[ ! " ${volumes[*]} " =~ " $i " ]]; then
				if [[ ${i%"${i#?}"} -eq 0 ]]; then
					output+=("${i#?}")
				else
					output+=("$i")
				fi
			fi
		done

		echo "$(
			IFS=','
			echo "${output[*]}"
		)"
		unset volumes
	done
}

while getopts 'l:r:h' opt; do
	case "$opt" in
	l) location="$OPTARG" ;;
	r)
		IFS='-' read -r start end <<<"$OPTARG"
		if [[ -z $start || -z $end ]]; then
			echo -e "\n$(basename "$0"): option -r requires an argument, seperated with a dash.\n" >&2
			echo "eg: 1-20, 6-15" >&2
			exit 1
		fi
		;;
	h | *)
		echo "Usage: $(basename "$0") [-l path/to/folder] [-r arg1-arg2]" >&2
		exit 1
		;;
	esac
done

shift $((OPTIND - 1))

missing_volumes "$location" "$start" "$end"
