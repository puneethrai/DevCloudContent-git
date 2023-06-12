#!/bin/bash
#mkdir -p ~/results
echo $PWD
FACE_FOLDER=${1:-${FACE_FOLDER:-"~/face-detection.jpg"}}
ls -la
source /opt/intel/openvino/bin/setupvars.sh && \
    python3 ~/open_model_zoo-2021.4/demos/face_detection_mtcnn_demo/python/face_detection_mtcnn_demo.py \
    -i ${FACE_FOLDER} \
    -m_o ~/open_model_zoo-2021.4/demos/face_detection_mtcnn_demo/python/public/mtcnn/mtcnn-o/FP16/mtcnn-o.xml \
    -m_p ~/open_model_zoo-2021.4/demos/face_detection_mtcnn_demo/python/public/mtcnn/mtcnn-p/FP16/mtcnn-p.xml \
    -m_r ~/open_model_zoo-2021.4/demos/face_detection_mtcnn_demo/python/public/mtcnn/mtcnn-r/FP16/mtcnn-r.xml \
    -th 0.7 \
    -d CPU \
    --no_show \
    -o /data/face-result.jpg
