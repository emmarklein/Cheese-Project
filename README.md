Cheese is more than just a food... it’s a global obsession! From gooey pizza and quesadillas to creamy fondue and spicy cheese tteokbokki, this project explores the world of cheese in all its flavors and forms.

There are thousands of cheese varieties produced across the world. Each cheese varies in milk type (cow, goat, sheep, or even plant-based), texture (soft, semi-soft, hard), rind style (washed, cloth-wrapped, natural), flavor and aroma (nutty, rich, tangy), and nutritional content (fat and calcium content). The goal of this project is to analyze global cheese diversity and uncover patterns in cheese production. Using an extra cheesy dataset from [cheese.com](https://www.cheese.com/), we will explore questions such as:
- Which countries produce the most unique cheese types?
- How do milk types vary by country?
- Are there patterns in cheese family, texture, or flavor across regions?
- Can we predict the origin of a cheese based on its characteristics?

This repo includes all files necessary to reproduce all outputs. It contains:

(1) Dockerfile: ​​defines the environment aka the recipe that tells Docker how to build the container
(2) cheese.R: main R script with fun cheese data analysis
(3) cheese.Rmd: Rmarkdown file that includes more commentary and can be knitted to a pdf or html for the final report
(4) cheese.html: rendered output from cheese.Rmd with complete data analysis results
(5) /figures: a directory storing all generated plots and images
(6) start.sh: shell script to build and run the Docker container
(7) Makefile: my personal favorite, this file defines workflows and dependencies, allowing us to automate running analyses or generating outputs with a single command!
(8) And lastly this README.md of course..  


First, download this entire repo to your desktop and then run start.sh to build the Docker image and then run the Docker container. You can do this by chmod+x start.sh and then run ./start.sh

Then, connect to the local host http://localhost:8787 and log into the rstudio server. I have included the results already in this directory but you can use the R terminal to reproduce the entire analysis. 

First, make sure you are in the /home/rstudio/work directory. Then, to delete everything and start from scratch, type make clean in the R terminal. Then type, make in the terminal. Through make, all final figures and documents will be rendered.

Thank you for reading me! 

