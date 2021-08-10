#!/usr/bin/env bash

# ENV: OUT_PNG

dir="$(dirname "$(readlink -f "$0")")"

find . -name '*.gp' ! -name header.gp ! -name footer.gp -print0 | 
	while read -r -d '' file; do
		filename=$(basename -- "$file")
		spath="$(dirname "$(readlink -f "$file")")"
		code="$(basename -s .gp "$filename")"
		pushd "$spath" || exit 1
			gnuplot "$filename"
			if [ -n "$OUT_PNG" ]; then 
				pdftoppm "${code}.pdf" "${dir}/${code}" -png -f 1 -singlefile
			fi
		popd
	done

