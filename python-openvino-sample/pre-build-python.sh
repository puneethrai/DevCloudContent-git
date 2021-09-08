#! /bin/sh

source /opt/intel/openvino_2021/bin/setupvars.sh
tar -xvf omz-2021.4.tar.gz

set INTEL_OPENVINO_DIR = /opt/intel/openvino_2021
cd open_model_zoo-2021.4/demos/face_detection_mtcnn_demo/python
python3 ${INTEL_OPENVINO_DIR}/deployment_tools/open_model_zoo/tools/downloader/downloader.py --list models.lst && \
python3 ${INTEL_OPENVINO_DIR}/deployment_tools/open_model_zoo/tools/downloader/converter.py --list models.lst
