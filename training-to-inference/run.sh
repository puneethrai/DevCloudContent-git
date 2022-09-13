#!/bin/sh
MOUNT=${1:-${MOUNT_PATH:-"/s3"}}
REPO=${2:-${GITREPO:-"https://github.com/openvinotoolkit/openvino_notebooks.git"}}
NOTEBOOK_PATH=${3:-${NOTEBOOK_LOCATION:-"openvino_notebooks/notebooks/210-ct-scan-live-inference"}}
NOTEBOOK_NAME=${4:-${FILE:-"210-ct-scan-live-inference.ipynb"}}
OUTPUT_DIR=${5:-${OUTPUT:-${NOTEBOOK_PATH}}}
UTIL_FILE=${5:-${UTIL_FILE:-"openvino_notebooks/notebooks/utils/notebook_utils.py"}}
PY_EXTENSION="py"
INFERENCE_FILE=$(echo "$NOTEBOOK_NAME" | sed "s/ipynb/$PY_EXTENSION/")

echo "Git Repo to be cloned: ${REPO}"
echo "Notebook to be used: ${NOTEBOOK_PATH}/${NOTEBOOK_NAME}"
echo "Inference Output: ${OUTPUT_DIR}"
echo "Volume Mount path: ${MOUNT}"
echo "Inference file to be used: ${INFERENCE_FILE}"
echo "Util file to be modified: ${UTIL_FILE}"
cd ${MOUNT}
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
sed -e "s/display_handle = showarray(result, display_handle)/display_handle=showarray(result, display_handle);cv2.imwrite(str(next_frame_id_to_show) + '_inference.jpeg', result)/" ${UTIL_FILE} > "${UTIL_FILE}_temp"
sed -e "s/fps = len(image_paths) \/ duration/fps = len(image_paths)\/duration;Path('\/mount_folder\/FP16').mkdir(parents=True, exist_ok=True);f = open('\/mount_folder\/FP16\/performance.txt', 'w');f.write(f'Throughput: {fps:.2f} FPS\\\\nLatency: {duration:.2f} s');f.close()/" "${UTIL_FILE}_temp" > "${UTIL_FILE}_temp2"
rm -rf "${UTIL_FILE}_temp"
mv "${UTIL_FILE}_temp2" ${UTIL_FILE}
cd ${NOTEBOOK_PATH}
jupyter nbconvert --to script ${NOTEBOOK_NAME}
ipython ${INFERENCE_FILE}