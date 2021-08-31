# Feature extraction: to extract feature linspeciv, melspeciv, linspecgcc, melspecgcc
FEATURE_CONFIG=./dataset/configs/tnsse2021_feature_config.yml
FEATURE_TYPE=linspeciv

.phony: feature
feature:
	PYTHONPATH=$(shell pwd) python dataset/feature_extraction.py --data_config=$(FEATURE_CONFIG) \
	--feature_type=$(FEATURE_TYPE)


# SALSA feature extraction
SALSA_CONFIG=./dataset/configs/tnsse2021_salsa_feature_config.yml

.phony: salsa
salsa:
	PYTHONPATH=$(shell pwd) python dataset/salsa_feature_extraction.py --data_config=$(SALSA_CONFIG)


# Training and inference
CONFIG_PATH=./experiments/configs/
CONFIG_NAME=seld_test.yml
OUTPUT=./outputs
EXP_SUFFIX=
RESUME=False
GPU_NUM=0

.phony: train
train:
	PYTHONPATH=$(shell pwd) CUDA_VISIBLE_DEVICES="${GPU_NUM}" python experiments/train.py --exp_config="${CONFIG_PATH}${CONFIG_NAME}" --exp_group_dir=$(OUTPUT) --exp_suffix=$(EXP_SUFFIX) --resume=$(RESUME)

.phony: inference
train-joint:
	PYTHONPATH=$(shell pwd) CUDA_VISIBLE_DEVICES="${GPU_NUM}" python experiments/inference_all_splits.py --exp_config="${CONFIG_PATH}${CONFIG_NAME}" --exp_group_dir=$(OUTPUT) --exp_suffix=$(EXP_SUFFIX)


# Evaluate
OUTPUT_DIR=/outputs/crossval/mic/salsa/seld_test/outputs/submissions/original/mic_test
GT_ROOT_DIR=/data/dcase2021/task3/
IS_EVAL_SPLIT=False

.phony: evaluate
evaluate:
	PYTHONPATH=$(shell pwd) python experiments/evaluate_seld.py  --output_dir=$(OUTPUT_DIR) --gt_meta_root_dir=$(GT_ROOT_DIR) --is_eval_split=$(IS_EVAL_SPLIT)