Cheese is more than just a food – it’s a global obsession. From gooey pizza and quesadillas to creamy fondue and spicy cheese tteokbokki, this project explores the world of cheese in all its flavors and forms.

There are thousands of cheese varieties produced across the world. Each cheese varies in milk type (cow, goat, sheep, or even plant-based), texture (soft, semi-soft, hard), rind style (washed, cloth-wrapped, natural), flavor and aroma (nutty, rich, tangy), and nutritional content (fat and calcium content). The goal of this project is to analyze global cheese diversity and uncover patterns in cheese production. Using an extra cheesy dataset from [🧀 cheese.com](https://www.cheese.com/), we will explore questions such as:
- Which countries produce the most unique cheese types?
- How do milk types vary by country?
- Are there patterns in cheese family, texture, or flavor across regions?
- Can we predict the origin of a cheese based on its characteristics?

Through this analysis, we aim to provide both data-driven insights into the global cheese landscape and practical visualizations to communicate trends in cheese production, composition, and diversity.
This directory includes all files necessary to reproduce all outputs for my bios611 clustering HW assignment. It contains:

(1) Dockerfile  
(2) clustering.R  
(3) clustering.Rmd  
(4) clustering.html  
(5) /figures  
(6) start.sh  
(7) Makefile  
(8) And lastly this README.md of course..  

First, download this entire repo to your desktop and then run start.sh to build the Docker image and then run the Docker container. You can do this by chmod+x start.sh and then run ./start.sh

Then, connect to the local host http://localhost:8787 and log into the rstudio server. I have included the results already in this directory but you can use the R terminal to reproduce the entire analysis. 

First, make sure you are in the /home/rstudio/work directory. Then, to delete everything and start from scratch, type make clean in the R terminal. Then type, make in the terminal. Through make, all final figures and documents will be rendered.

Thank you for reading me! 

