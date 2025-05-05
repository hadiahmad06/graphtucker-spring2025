# Directories
GRAPH_TUCKER_DIR = GraphTucker
DATA_DIR = $(GRAPH_TUCKER_DIR)/data
PROCESSED_DATA_DIR = $(GRAPH_TUCKER_DIR)/processed_data
RESULTS_DIR = $(GRAPH_TUCKER_DIR)/res

# Default target
all: run_custom_data

# Run GraphTucker on CustomData
run_custom_data: setup
	@echo "Running GraphTucker on CustomData..."
	cd $(GRAPH_TUCKER_DIR) && matlab -batch "run('GraphTucker.m'); exit"

# Run GraphTucker on BRCA1 using tutorial
run_mosta: setup
	@echo "Running GraphTucker on MOSTA_9.5..."
	cd $(GRAPH_TUCKER_DIR) && matlab -batch "run('GraphTucker_tutorial1.m'); exit"

# Run GraphTucker on BRCA1 using tutorial
run_brca1: setup
	@echo "Running GraphTucker on BRCA1..."
	cd $(GRAPH_TUCKER_DIR) && matlab -batch "run('GraphTucker_tutorial2.m'); exit"

# Clean up results
clean:
	rm -rf $(RESULTS_DIR)/*

# Create necessary directories
setup:
	mkdir -p $(RESULTS_DIR)
	mkdir -p $(PROCESSED_DATA_DIR)

# Help target
help:
	@echo "Available targets:"
	@echo "  all              - Run GraphTucker on CustomData"
	@echo "  run_custom_data  - Run GraphTucker on CustomData"
	@echo "  run_brca1        - Run GraphTucker on BRCA1 dataset using tutorial"
	@echo "  clean           - Remove results"
	@echo "  setup           - Create necessary directories"
	@echo "  help            - Show this help message"

.PHONY: all run_custom_data run_brca1 clean setup help
