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
   Defines the environment for reproducible analysis. Includes R, RStudio server, and required packages. Tells Docker how to build the container.

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
   Automates the workflow, runs scripts and generates outputs with a single command.

8. **`README.md`**  
   This file! Provides an overview of the project.

---

## **Usage**

### **1. Clone the repository**
```bash
git clone https://github.com/emmarklein/Cheese-Project.git
cd Cheese-Project
```

### **2. Start the Docker container**
Make the script executable once, then run it:
```bash
chmod +x start.sh
./start.sh
```

The script will automatically:
- Build the Docker image (docker build . -t cheese)
- Run the container and launch RStudio server on http://localhost:8787
- Provide login credentials
  - Username: rstudio
  - Password: cheese

### **3. Open RStudio in your browser**

Go to http://localhost:8787 and log in with the credentials above. All project files are available inside RStudio.

### **4. Generate the report from scratch**

Inside RStudio terminal, run:
```bash
make clean
make cheese.html
```
