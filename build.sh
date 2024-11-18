#!/bin/bash

# Path to the input file
input_file="$1"
ZL="$2"
if [ -z "$ZL" ]; then
  ZL=17
fi

# Maximum number of parallel jobs
MAX_JOBS=$3
if [ -z "$MAX_JOBS" ]; then
  MAX_JOBS=4
fi


# Function to execute the Python command
run_command() {
  part1="$1"
  part2="$2"
  ZL="$3"
  python3 Ortho4XP.py "$part1" "$part2" BI "$ZL"
  ditto Tiles/zOrtho4XP_"$part1$part2" ./zOrtho4XP_For_AO
  rm -rf Tiles/zOrtho4XP_"$part1$part2"
}

# Read each line from the input file
while IFS=',' read -ra value; do
  echo $value
    # Extract the first and second part
  part1="${value:0:3}"
  part2="${value:3}"

  # Run the command in the background
  run_command "$part1" "$part2" "$ZL" &

  # Wait if the number of background jobs reaches the limit
  while [ "$(jobs | wc -l)" -ge "$MAX_JOBS" ]; do
    sleep 1
  done
done < "$input_file"

# Wait for all background jobs to complete
wait

echo "All tasks completed."