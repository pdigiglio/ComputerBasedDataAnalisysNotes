#
# Easy Makefile to compile notes.tex
#

.PHONY: clean distclean dist help

LaTeX=latexmk
# Check if latexmk is installed
isNotInstalled = $(shell which $(LaTeX) 2> /dev/null; echo $$?)
ifeq ($(isNotInstalled),1)

# If latexmk is not installed
# 1. Print a warning
$(info WARNING >> $(LaTeX) is not installed, using latex)

# 2. Sets compiler to 'latex' and checks if it's installed
LaTeX=latex
isNotInstalled = $(shell which $(LaTeX) 2> /dev/null; echo $$?)
ifeq ($(isNotInstalled),1)

# If neither latex is installed, prints an error and exits
$(error ERROR >> $(LaTeX) is not installed, exiting)

endif
endif


# default format is -pdf
ifndef format
format=pdf
else
# TODO implement a stop
#ifneq($(format),dvi)
#@echo "a"
#endif
endif

OPTIONS=-$(format) -shell-escape -recorder

# Track data file in data/ folder
dataFolder   = $(wildcard data/*.tab)
# Track data file in backmatter/ folder
backFolder   = $(wildcard backmatter/*.tex)
backFolder  += $(wildcard backmatter/*.bib)
# Track data file in frontmatter/ folder
frontFolder  = $(wildcard frontmatter/*.tex)
# Track data file in mainmatter/ folder
mainFolder   = $(wildcard mainmatter/*.tex)
# Track data file in config/ folder
configFolder = $(wildcard configs/*.tex)
configFolder+= $(wildcard configs/*.sty)
# Track data file in fig/ folder
figFolder    = $(wildcard images/*.tex)
figFolder    = $(wildcard images/*.pgf)

MAIN=notes
$(MAIN).$(format): $(MAIN).tex AUTHORS $(dataFolder) $(backFolder) $(frontFolder) $(mainFolder) $(configFolder) $(figFolder) Makefile
	@echo "`tput bold`$(LaTeX)`tput sgr0`"\
		"`tput setaf 1`$(OPTIONS)`tput sgr0`"\
		"`tput setaf 2`$<`tput sgr0`"
	@$(LaTeX) $(OPTIONS) $< -f

clean:
	@echo "`tput bold`rm`tput sgr0`"\
		"`tput setaf 1`--recursive --force --verbose`tput sgr0`"\
		"`tput setaf 2`*.toc *.log *.out *.aux *.fls *.i{nd,dx,lg} *-blx.bib *.b{bl,cf,lg}"\
		" *.ist *.a{cn,cr,lg} *.g{lg,lo,ls} *.run.xml *.fdb_latexmk *-plot.table *-plot.gnuplot`tput sgr0`"
	@rm --recursive --force --verbose *.toc *.log *.out *.aux *.fls *.ind *.idx *.ilg *-blx.bib *.bbl *.bcf *.blg *.ist *.acn *.acr *.alg *.glg *.glo *.gls *.run.xml *.fdb_latexmk *-plot.table *-plot.gnuplot

distclean: clean
	@echo "`tput bold`rm`tput sgr0`"\
		"`tput setaf 1`--recursive --force --verbose`tput sgr0`"\
		"`tput setaf 2`*.pdf *.dvi`tput sgr0`"
	@rm --recursive --force --verbose *.pdf *.dvi

thisFolder = $(shell basename $$(pwd))
now        = $(shell date "+%G-%m-%d_at_%H-%M-%S")
dist: $(MAIN).$(format) clean
	@cd ..; tar -cvzf $(thisFolder)_of_$(now).tar.gz --exclude-vcs $(thisFolder)/

#	echo $(thisFolder) at $(now)

help:
	@echo -e \
		"`tput setaf 1`>> Options available`tput sgr0`\n"\
		"`tput bold`make`tput sgr0`           "\
		"Builds `tput setaf 2`\"$(MAIN).tex\"`tput sgr0` trying to use latexmk (if it's not installed, uses latex). Calls the default `tput bold`$(MAIN).$(format)`tput sgr0` rule\n"\
		"`tput bold`make help`tput sgr0`      "\
		"Prints this help\n"\
		"`tput bold`make clean`tput sgr0`     "\
		"Removes `tput setaf 2`*.log *.out *.aux *.fls *.fdb_latexmk`tput sgr0` files\n" \
		"`tput bold`make distclean`tput sgr0` "\
		"Calls `tput bold`clean`tput sgr0` and removes `tput setaf 2`*.pdf *.dvi`tput sgr0` files\n" \
		"`tput bold`make dist`tput sgr0`      "\
		"Calls `tput bold`$(MAIN).$(format)`tput sgr0` and `tput bold`clean`tput sgr0` and creates a `tput setaf 2`.tar.gz`tput sgr0` archive of source files in ../\n" \
