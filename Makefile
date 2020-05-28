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

define add_target
$(1)_noref: $(PDF_DIR)/$(1).pdf

$(1)_full: $(PDF_DIR)/$(1).pdf $(OUT_DIR)/$(1).bbl
	@echo "correcting $(1) references..."
	$$(call run_pdflatex,$(1))
	$$(call run_pdflatex,$(1))

$(PDF_DIR)/$(1).pdf: $(TEX_DIR)/$(1).tex
	@echo "building $(1)..."
	$$(call run_pdflatex,$(1))

$(OUT_DIR)/$(1).bbl: $(BIB_DIR)/bibliography.bib
	@echo "building $(1) bibliography..."
	$$(call run_bibtex,$(1))
endef

report: report_full
presentation: presentation_full

$(eval $(call add_target,report))
$(eval $(call add_target,presentation))

.PHONY: init clean

init:
	@mkdir -p $(TEX_DIR) $(BIB_DIR)
	@cp $(TEMPLATE_DIR)/report.tex $(TEX_DIR)
	@cp $(TEMPLATE_DIR)/presentation.tex $(TEX_DIR)
	@cp $(TEMPLATE_DIR)/bibliography.bib $(BIB_DIR)

clean:
	rm -rf $(OUT_DIR)/* $(OUT_DIR)/$(TEX_DIR) $(PDF_DIR)/*
