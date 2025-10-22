\===================================================================

### **DEVELOPMENT GUIDELINES (Branches, Commits & PR Title)**

\===================================================================

1\. BRANCHING STRATEGY:  
Please create your branch using the following structure:  
developer\_name/ticket\_number/short\_description  
**Example:** nash/IT-1-create-project

2\. COMMIT & PR TITLE STRUCTURE:  
Please use this structure for both your individual commit messages  
and the final Pull Request title.  
Structure: type: \[TICKET-NUMBER\] clear description  
PR Title Example: feat: \[IT-27\] add swift linter  
Commit Example: fix: \[IT-29\] correct validation logic  
**\--- Commit Types \---**

* **feat**: A new feature  
* **fix**: A bug fix  
* **docs**: Documentation only changes  
* **style**: Changes that do not affect the meaning of the code (white-space, formatting, etc)  
* **refactor**: A code change that neither fixes a bug nor adds a feature  
* **test**: Adding missing tests or correcting existing tests  
* **chore**: Changes to the build process or auxiliary tools and libraries

**Bad Title Example:** "Fixes" or "Ticket progress"

\===================================================================  
(This instruction section will not appear in the final PR)  
\--\>

## **Description**

\<\!-- A clear and concise summary of what these changes do. \--\>

## **Related Issue(s)**

\<\!-- Link the tickets or issues that this PR resolves or is related to. \--\>

\<\!-- Ex: "Resolves IT-27", "Related to IT-45" \--\>

## **Type of Change**

\<\!-- Mark with an 'x' all boxes that apply. \--\>

* \[ \] 🐛 **Bug Fix**: (A non-breaking change that fixes an issue)  
* \[ \] ✨ **New Feature**: (A non-breaking change that adds functionality)  
* \[ \] 💥 **Breaking Change**: (A fix or feature that would cause existing functionality to not work as expected)  
* \[ \] ♻️ **Refactor**: (Code reorganization, no functional changes)  
* \[ \] 📚 **Documentation**: (Updates to documentation)  
* \[ \] ⚙️ **CI/CD**: (Changes to continuous integration configuration files)  
* \[ \] chore: (Other tasks like updating dependencies)

## **How Has This Been Tested?**

\<\!-- Describe in detail the steps the reviewer must follow to verify your changes. \--\>

**Steps to test:**

1. Go to the branch (e.g., nash/IT-1/create-project)  
2. Run npm install (if dependencies were added)  
3. Start the application (npm run dev)  
4. Navigate to section X and verify that Y works as expected.  
5. ...

**Evidence (Screenshots, GIFs, Videos):**

\<\!-- A picture is worth a thousand words\! \--\>

\[Insert your evidence here\]

## **Self-Review Checklist**

\<\!-- Review this before requesting your teammates' review. \--\>

* \[ \] My code follows the style guidelines of this project.  
* \[ \] I have performed a self-review of my own code.  
* \[ \] I have commented my code, particularly in hard-to-understand areas.  
* \[ \] I have made corresponding changes to the documentation (if applicable).  
* \[ \] My changes do not generate new warnings or errors.  
* \[ \] I have added tests (unit, integration) that prove my fix is effective or that my feature works.  
* \[ \] New and existing tests pass locally with my changes.