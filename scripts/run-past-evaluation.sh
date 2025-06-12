#!/bin/bash

# loop over 150 times with a 10 second delay
for i in {1..150}
do
  echo "Iteration $i"
  
  # Run the evaluation script
  ./get-transcript.sh

  sleep 10
done