# File Integrity Checker

The **File Integrity Checker** is a Bash and Python-based tool that compares system files and directories with their baseline state to detect unauthorized or unexpected changes. The tool uses a baseline snapshot of directories and files and compares them with the current state to report any modifications, deletions, or additions.

## Features

- **Baseline Creation:** Takes a snapshot of a directory and stores file metadata (inode, permissions, owner, etc.) in a baseline file.
- **Integrity Check:** Compares current directory/file state with the stored baseline to detect changes.
- **Report Generation:** Generates a detailed report of detected changes.
- **GUI Support:** Easy-to-use Graphical User Interface built using Tkinter.
- **Dark Theme:** User-friendly GUI with a dark theme for better usability.

## Requirements

- **Bash**: Required for running shell scripts.
- **Python 3.x**: Required for running the GUI.
- **Tkinter**: Python library for building GUI applications.
- **Linux**: The tool is primarily designed for Linux-based systems.

## Installation

 **Clone the repository**:

   ```bash
   git clone https://github.com/your-repo/file-integrity-checker.git
   cd file-integrity-checker
   chmod +x baselineCreate.sh Check.sh Report.sh
   sudo apt-get install python3-tk
   sudo python gui.py
 From GUI: Click the "Create Baseline" button and select the directory.
           Click the "Run Check" button, and select the directory to compare.
           Click the "Generate Report" button, and choose where to save the final report.   
