# Declare phony targets so Make always runs them as commands
.PHONY: all clean 

# List of all generated figures from R script
FIGURES = figures/plot1.png \
          figures/plot2.png \
          figures/plot3.png \
          figures/plot4.png \
          figures/plot5.png \
          figures/plot6.png 

# Generate all the figures and render report
all: cheese.html $(FIGURES)

# making fig directory
figures/:
	mkdir -p figures

# For making all the figures in cheese.R
$(FIGURES): cheese.R figures/
	Rscript cheese.R

# Render RMarkdown report (depends on all figures)
cheese.html: cheese.Rmd $(FIGURES)
	Rscript -e "rmarkdown::render('cheese.Rmd', output_file = 'cheese.html', output_format = 'html_document')"

# Clean generated files
clean:
	rm -f cheese.html
	rm -rf figures

# make a shiny app	
shiny:
	Rscript -e "shiny::runApp('shinyapp.R', launch.browser = TRUE)"


