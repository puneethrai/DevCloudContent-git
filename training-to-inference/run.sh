#!/bin/sh
MOUNT=${1:-${MOUNT_PATH:-"/s3"}}
REPO=${2:-${GITREPO:-"https://github.com/openvinotoolkit/openvino_notebooks.git"}}
NOTEBOOK_PATH=${3:-${NOTEBOOK_LOCATION:-"openvino_notebooks/notebooks/110-ct-segmentation-quantize"}}
NOTEBOOK_NAME=${4:-${FILE:-"110-ct-scan-live-inference.ipynb"}}
OUTPUT_DIR=${5:-${OUTPUT:-"/mount_folder"}}
UTIL_FILE=${5:-${UTIL_FILE:-"openvino_notebooks/notebooks/110-ct-segmentation-quantize/110-ct-scan-live-inference.py"}}
PY_EXTENSION="py"
INFERENCE_FILE=$(echo "$NOTEBOOK_NAME" | sed "s/ipynb/$PY_EXTENSION/")
PERFORMANCE_OUTPUT=${OUTPUT_DIR}/output/FP16
INFERENCE_OUPUT=${OUTPUT_DIR}/output/inference

echo "Git Repo to be cloned: ${REPO}"
echo "Notebook to be used: ${NOTEBOOK_PATH}/${NOTEBOOK_NAME}"
echo "Inference Output: ${OUTPUT_DIR}"
echo "Volume Mount path: ${MOUNT}"
echo "Inference file to be used: ${INFERENCE_FILE}"
echo "Util file to be modified: ${UTIL_FILE}"
cd ${OUTPUT_DIR}
cat <<EOT >> requirements.txt
openvino-dev[onnx]==2022.1.0
gdown
pytube
yaspin
# PyTorch/ONNX notebook requirements
fastseg
ipywidgets

torch>=1.5.1,<=1.7.1; sys_platform == 'darwin'
torchvision>=0.6.1,<=0.8.2; sys_platform == 'darwin'
--find-links https://download.pytorch.org/whl/torch_stable.html
torch>=1.5.1+cpu,<=1.7.1+cpu; sys_platform =='linux' or platform_system == 'Windows'
torchvision>=0.6.1+cpu,<=0.8.2+cpu; sys_platform =='linux' or platform_system == 'Windows'
torchmetrics==0.6.2

# CT scan training/inference requirements
monai<=0.9.0
pytorch_lightning
opencv-python

EOT

pip install -r requirements.txt
git clone ${REPO}

cd ${NOTEBOOK_PATH}
jupyter nbconvert --to script ${NOTEBOOK_NAME}
cd ${OUTPUT_DIR}
sed -e "s#display.display(i)#display.display( i );Path('$INFERENCE_OUPUT').mkdir(parents=True, exist_ok=True);global count;count = (count + 1 if 'count' in globals() else 0);cv2.imwrite('$INFERENCE_OUPUT' + '/' + str(count) + '_inference.jpeg', frame)#" ${UTIL_FILE} > "${UTIL_FILE}_temp"
sed -e "s#time_per_frame = 1 / fps#time_per_frame=1/fps;Path('$PERFORMANCE_OUTPUT').mkdir(parents=True, exist_ok=True);f = open('$PERFORMANCE_OUTPUT/performance.txt', 'w');f.write(f'Throughput: {fps:.2f} FPS\\\\nLatency: {time_per_frame:.2f} s');f.close()#" "${UTIL_FILE}_temp" > "${UTIL_FILE}_temp2"
rm -rf "${UTIL_FILE}_temp"
mv "${UTIL_FILE}_temp2" ${UTIL_FILE}
cd ${NOTEBOOK_PATH}
ipython ${INFERENCE_FILE}
