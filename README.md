# POLSC-UH2211 - Data Analysis: Political Science 
Lecture notes for course POLSC-UH2211

## Lectures

- [Lecture 1](/lectures/lecture-1.R)
- [Lecture 2](/lectures/lecture-2.R)
- [Lecture 3](/lectures/lecture-3.R)
- [Lecture 4](/docs/lectures/lecture-4.md)

## Homework assignments

- [Homework 1](/docs/homework/homework-1.md)

## Getting started

### Before the first lecture (required)

**Please complete the steps below before coming to the first class.  
Nothing else is required.**

1. Create a free account on [GitHub](https://github.com).
    - You will not be able to change your username later, so choose carefully.
    - Use a permanent email address, so you do not lose access after graduation.

2. Enable [GitHub Education](https://github.com/education).
    - This gives you free access to developer tools used in this course.
    - It also allows you to run R in your browser for about 60 hours per month.
    - This step links your GitHub account to your university email address.
    - If approval is pending, that is fine — you can still follow the first classes.

---

### In class: running R in your browser (we will do this together)

**‼️ Bring your laptop**

Click on the Code (green button) -> Codespaces tab -> Create codespace on main.
    
This will create your own **Codespace**; a virtual machine on the cloud with all the software we need for this course. You can follow along the lecture notes and modify what you want as you see fit. 

**Don't hesitate to change things, you will always be able to discard your changes and go back where the lecture started.** 

To go back to your Codespace, follow the same steps. Click on the Code (green button) -> Codespaces tab. You will now see a machine with a name; that's your own Codespace. Click on it to open it. If it's broken, click the ..., delete it, and create a new one 😉.

---

### Running R on your own computer (advanced)

This step is **not required at the beginning of the course**.

Once you are comfortable with R and GitHub, you may choose to work locally on your own computer.  
We will discuss this option later in the semester.

If you decide to do so, the general steps are:

1. Install Git (e.g., [GitHub Desktop](https://desktop.github.com/))
2. Install [R](https://cran.r-project.org/)
3. Install the IDE of your choice (see pros and cons below): 
    - [RStudio](https://posit.co/download/rstudio-desktop/)
    - [VS Code](https://code.visualstudio.com/)
    - [Positron](https://positron.posit.co/) (recommended)
4. Install [Quarto](https://quarto.org/docs/get-started/), to render lecture notes and assignments.
    - If you want to render PDFs, don't forget to install LaTeX -- instructions [here](https://quarto.org/docs/output-formats/pdf-engine.html)
5. Clone this repository to your computer using GitHub Desktop
6. Open the repository folder in your IDE of choice and start working!

Please come to office hours or talk to me after class if you need help with this step.

#### IDE options: pros and cons

| IDE | Pros | Cons | Who for? |
|----|----|----|----|
| **RStudio** | • First-class support for R<br>• Designed specifically for data analysis<br>• Many students may have used it before<br>• Very simple setup | • Interface feels a bit dated<br>• Only supports R (and a bit of Python)<br>• No AI features | People who have used RStudio before |
| **Visual Studio Code** | • Matches GitHub Codespaces exactly<br>• Industry standard across many fields; support all languages (R, Python, etc.)<br>• Excellent AI support | • R support is less polished and needs some initial configuration (follow tutorial [here](https://code.visualstudio.com/docs/languages/r)) | People who want to replicate the Codespaces experience exactly |
| **Positron** | Built on VS Code, so inherits most same strengths (very similar interface)• Cleaner R experience than VS Code<br>• Better AI support for data analysis<br> | • Newer, so less polished than VS Code | My recommendation for most students |
