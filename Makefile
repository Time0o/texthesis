TEX_DIR:=../tex
BIB_DIR:=../bib
OUT_DIR:=out
PDF_DIR:=pdf
TEMPLATE_DIR:=templates

define run_pdflatex
	@2>&1 pdflatex -shell-escape \
	               -halt-on-error -interaction=nonstopmode \
	               -output-directory=$(OUT_DIR) -jobname=$(1) \
	               $(TEX_DIR)/$(1).tex > /dev/null; \
	if [ $$? -ne 0 ]; then 2>&1 echo "pdflatex failed"; exit 1; fi;
	@mv $(OUT_DIR)/$(1).pdf $(PDF_DIR)/$(1).pdf
endef

define run_bibtex
	@cp $(BIB_DIR)/bibliography.bib $(OUT_DIR)
	@(cd $(OUT_DIR); \
	  2>&1 bibtex $(1) > /dev/null; \
	  if [ $$? -ne 0 ]; then 2>&1 echo "bibtex failed"; exit 1; fi)
	@rm $(OUT_DIR)/bibliography.bib
endef

all: report_full

report_noref: $(PDF_DIR)/report.pdf

report_bib: report_noref $(OUT_DIR)/report.bbl

report_full: report_bib
	@echo "correcting report references..."
	$(call run_pdflatex,report)
	$(call run_pdflatex,report)

$(PDF_DIR)/report.pdf: $(TEX_DIR)/report.tex
	@echo "building report..."
	$(call run_pdflatex,report)

$(OUT_DIR)/report.bbl: $(BIB_DIR)/bibliography.bib
	@echo "building report bibliography..."
	$(call run_bibtex,report)

.PHONY: init clean

init:
	@mkdir -p $(TEX_DIR) $(BIB_DIR)
	@cp $(TEMPLATE_DIR)/report.tex $(TEX_DIR)
	@cp $(TEMPLATE_DIR)/bibliography.bib $(BIB_DIR)

clean:
	rm -rf $(OUT_DIR)/* $(OUT_DIR)/$(TEX_DIR) $(PDF_DIR)/*
