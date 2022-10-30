#!/bin/sh
MODEL=${1:-${MODEL_PATH:-"/s3/unet_kits19.xml"}}
OUTPUT_DIR=${5:-${OUTPUT:-"/mount_folder"}}

benchmark_app -m ${MODEL} -report_folder ${OUTPUT_DIR} -report_type detailed_counters
