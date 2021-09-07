#!/bin/bash
#mkdir -p ~/results

source /opt/intel/openvino_2021/bin/setupvars.sh && \
    ./open_model_zoo-2021.4/demos/intel64/Release/crossroad_camera_demo \
    -i ./people-detection.mp4 \
    -m ./open_model_zoo-2021.4/demos/crossroad_camera_demo/cpp/intel/person-vehicle-bike-detection-crossroad-0078/FP16-INT8/person-vehicle-bike-detection-crossroad-0078.xml \
    -m_pa ./open_model_zoo-2021.4/demos/crossroad_camera_demo/cpp/intel/person-attributes-recognition-crossroad-0230/FP16-INT8/person-attributes-recognition-crossroad-0230.xml \
    -m_reid ./open_model_zoo-2021.4/demos/crossroad_camera_demo/cpp/intel/person-reidentification-retail-0287/FP16-INT8/person-reidentification-retail-0287.xml \
    -d CPU \
    -no_show \
    -o /data/cpp-test-result-210813.mp4
