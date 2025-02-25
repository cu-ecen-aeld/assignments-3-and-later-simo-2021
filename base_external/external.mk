<<<<<<< HEAD
include $(sort $(wildcard $(BR2_EXTERNAL_project_base_PATH)/package/*/*.mk))
=======
# external.mk
BASE_EXTERNAL_TOP_DIR := $(call select_from_repo,$(BR2_EXTERNAL_PROJECT_BASE_PATH),$(CURDIR))

BASE_EXTERNAL_PKGS_DIR := $(BASE_EXTERNAL_TOP_DIR)/package
BASE_EXTERNAL_CONFIG_DIR := $(BASE_EXTERNAL_TOP_DIR)/configs

# Inclusion des règles de construction pour les paquets
include $(sort $(wildcard $(BASE_EXTERNAL_PKGS_DIR)/*/*.mk))
>>>>>>> ac5bd35 (add buildroot and some files(build.sh))
