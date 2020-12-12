#!/bin/bash

if [[ $# != 2 ]]; then
  echo "Sposób uzytkowania: $0 <ścieżka/do/folderu/z/testami> <ścieżka/do/fodleru/z/projektem> " >&2
  exit 1
fi

tests=$(realpath "$1")
project=$(realpath "$2")
threshold=${3:-1}

if ! [[ -d "$tests" ]]; then
  echo "Podany folder z testami nie istnieje"
  exit 1
fi

if ! [[ -d "$project" ]]; then
  echo "Podany folder z projektem nie istnieje"
  exit 1
fi

total=0
correct=0
leaked=0

function traverse_folder() {
  folder="$1"
  shopt -s nullglob
  for f in "$folder"/*.in; do
    randfloat=$(printf '0%s\n' $(echo "scale=8; $RANDOM/32768" | bc ))
    if (( $(echo "$randfloat < $threshold" |bc -l) )); then
      run_test "$f"
    fi
  done

  shopt -s nullglob
  for d in "$folder"/*/; do
    echo "$d"
    traverse_folder "$(realpath "$d")"
  done
}

RED='\033[0;31m'
GREEN='\033[0;32m'
NOCOLOR='\033[0m'

function run_test() {
  input_file="$1"
  output_file=${input_file//.in/.out}

  ((total++))
  echo -e "\e[1mTest $f \e[0m"

  cat "$input_file" | ./app  1>"$temp_out"

    if cmp -s "$output_file" "$temp_out" ; then
        echo -ne "${GREEN}stdout ok${NOCOLOR}\n"
    else
        echo -ne "${RED}stdout nieprawidlowe${NOCOLOR}\n"
        diff -d "$output_file" "$temp_out"

    fi
  }
​
temp_out=$(mktemp)
trap 'rm -f "$temp_out"' INT TERM HUP EXIT
​
./compile
​
traverse_folder "$tests"