# Directories
GRAPH_TUCKER_DIR = GraphTucker
DATA_DIR = $(GRAPH_TUCKER_DIR)/data
PROCESSED_DATA_DIR = $(GRAPH_TUCKER_DIR)/processed_data
RESULTS_DIR = $(GRAPH_TUCKER_DIR)/res
SCRIPT_DIR = $(GRAPH_TUCKER_DIR)/implementation

# MATLAB script
MATLAB_SCRIPT = $(SCRIPT_DIR)/run_graphtucker.m

# Default target
all: run_custom_data

# Run GraphTucker on CustomData
run_custom_data: setup
	@echo "Running GraphTucker on CustomData..."
	matlab -batch "run('$(MATLAB_SCRIPT)'); exit"

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
	@echo "  clean           - Remove results"
	@echo "  setup           - Create necessary directories"
	@echo "  help            - Show this help message"

.PHONY: all run_custom_data clean setup help
