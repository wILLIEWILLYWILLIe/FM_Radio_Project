# =============================================================
# FM Radio Project Submission Makefile
# =============================================================
# This Makefile automates the packaging of design files, 
# simulation scripts, reports, and data files for submission.
# =============================================================

PROJECT_NAME = team_6_final_project
SUBMIT_DIR   = $(PROJECT_NAME)
ZIP_FILE     = $(PROJECT_NAME).zip

# List of files and directories to include in the submission
# Requirements: SV design, FIFOs, UVM, sim.do, wave.do, data files, report.
FILES_TO_INCLUDE = \
	FM_Radio/imp/sv/*.sv \
	FM_Radio/imp/sim/*.do \
	FM_Radio/imp/sim/run_simulation \
	FM_Radio/imp/uvm/*.sv \
	FM_Radio/test/small \
	report/team_6_final_report.pdf \


.PHONY: all clean zip prepare

all: zip

prepare:
	@echo "Creating submission directory: $(SUBMIT_DIR)"
	@mkdir -p $(SUBMIT_DIR)
	@mkdir -p $(SUBMIT_DIR)/sv
	@mkdir -p $(SUBMIT_DIR)/sim
	@mkdir -p $(SUBMIT_DIR)/syn
	@mkdir -p $(SUBMIT_DIR)/uvm
	@mkdir -p $(SUBMIT_DIR)/test
	
	@echo "Copying RTL files to sv/..."
	@cp -r FM_Radio/imp/sv/* $(SUBMIT_DIR)/sv/
	
	@echo "Copying specific Simulation files to sim/..."
	@cp FM_Radio/imp/sim/fm_sim.do \
		FM_Radio/imp/sim/fm_uvm_sim.do \
		FM_Radio/imp/sim/fm_uvm_wave.do \
		FM_Radio/imp/sim/run_uvm_simulation \
		$(SUBMIT_DIR)/sim/
	
	@echo "Copying Synthesis project to syn/..."
	@cp FM_Radio/imp/syn/fm_radio.prj $(SUBMIT_DIR)/syn/
	
	@echo "Copying UVM files to uvm/..."
	@cp -r FM_Radio/imp/uvm/* $(SUBMIT_DIR)/uvm/
	
	@echo "Copying test data files (small dataset) to test/..."
	@cp -r FM_Radio/imp/test/* $(SUBMIT_DIR)/test/
	
	@echo "Copying report to root..."
	@cp report/team_6_final_report.pdf $(SUBMIT_DIR)/

zip: prepare
	@echo "Creating zip archive: $(ZIP_FILE)"
	@zip -r $(ZIP_FILE) $(SUBMIT_DIR)
	@echo "Submission package ready: $(ZIP_FILE)"

clean:
	@echo "Cleaning up..."
	@rm -rf $(SUBMIT_DIR)
	@rm -f $(ZIP_FILE)
	@echo "Clean complete."

help:
	@echo "FM Radio Submission Makefile"
	@echo "Usage:"
	@echo "  make zip     - Creates the submission folder and zips it"
	@echo "  make clean   - Deletes the temporary submission folder and zip file"
	@echo "  make prepare - Only creates the submission folder without zipping"
