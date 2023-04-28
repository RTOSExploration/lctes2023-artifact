#!/usr/bin/env bash

rm -f summary.txt

echo "name #apps #macro TP FP FN TN" >> summary.txt
for d in */ ; do
  #echo -n "$d " >> summary.txt
  numapps=$(find "$d" -name "*.analysis" | wc -l)
  find "$d" -name "*.analysis" | xargs grep -E '^(Non-)?HAL:' --no-filename \
    | sed 's_mbed-os-example-.*mbed-os/__' \
    | sort -u -k 3,3 | sort > "$d/summary.txt"
  awk -v app="$d" -v numapps="$numapps" \
  'BEGIN { cnt_macro=0; cnt_tp=0; cnt_fp=0; cnt_tn=0; cnt_fn=0 }
    ($7 == "1") {cnt_macro++ }
    ($7 == "0" && $5 == "1" && $6 == "1") {cnt_tp++ }
    ($7 == "0" && $5 == "1" && $6 == "0") {cnt_fp++ }
    ($7 == "0" && $5 == "0" && $6 == "0") {cnt_tn++ }
    ($7 == "0" && $5 == "0" && $6 == "1") {cnt_fn++ }
  END { print app, numapps, cnt_macro, cnt_tp, cnt_fp, cnt_fn, cnt_tn }' \
  "$d/summary.txt" >> summary.txt
done
