# Say Cheese! 🧀

A fun and reproducible analysis of cheeses from around the world, exploring types, milk sources, flavors, and more. This repository contains all files needed to reproduce the results and visualizations.

---

## **Introduction**

Cheese is more than just a food... it’s a global obsession! From gooey pizza and quesadillas to creamy fondue and spicy cheese tteokbokki, this project explores the world of cheese in all its flavors and forms.

There are thousands of cheese varieties produced across the world. Each cheese varies in milk type (cow, goat, sheep, or even plant-based), texture (soft, semi-soft, hard), rind style (washed, cloth-wrapped, natural), flavor and aroma (nutty, rich, tangy), and nutritional content (fat and calcium content). The goal of this project is to analyze global cheese diversity and uncover patterns in cheese production. Using an extra cheesy dataset from [cheese.com](https://www.cheese.com/), we will explore questions such as:
- Which countries produce the most unique cheese types?
- How do milk types vary by country?
- Are there patterns in cheese family, texture, or flavor across regions?
- Can we predict the origin of a cheese based on its characteristics?

---

## **Repository Structure**

The repository contains:

1. **`Dockerfile`**  
   Defines the environment for reproducible analysis. Includes R, RStudio Server, and required packages. Tells Docker how to build the container.

2. **`start.sh`**  
   Shell script to build and run the Docker container. Launches RStudio server at [http://localhost:8787](http://localhost:8787).  
   - Username: `rstudio`  
   - Password: `cheese`

3. **`cheese.R`**  
   Main R script containing the core data analysis.

4. **`cheese.Rmd`**  
   RMarkdown version of the analysis, with commentary and visualizations. Can be rendered to PDF or HTML.

5. **`cheese.html`**  
   Rendered HTML output of `cheese.Rmd` with full analysis results.

6. **`/figures`**  
   Folder containing all generated plots and images.

7. **`Makefile`**  
   Automates workflows, like running scripts or generating outputs with a single command.

8. **`README.md`**  
   This file! Provides an overview of the project.

---

First, download this entire repo to your desktop and then run start.sh to build the Docker image and then run the Docker container. You can do this by chmod+x start.sh and then run ./start.sh

Then, connect to the local host http://localhost:8787 and log into the rstudio server. I have included the results already in this directory but you can use the R terminal to reproduce the entire analysis. 

First, make sure you are in the /home/rstudio/work directory. Then, to delete everything and start from scratch, type make clean in the R terminal. Then type, make in the terminal. Through make, all final figures and documents will be rendered.

Thank you for reading me! 

