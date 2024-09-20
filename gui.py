import tkinter as tk
from tkinter import ttk, messagebox, filedialog
import subprocess
import os
import threading

class FileIntegrityCheckerApp:
    def __init__(self, root):
        self.root = root
        self.root.title("File Integrity Checker")

        # Configure the black theme
        self.configure_dark_theme()

        # Create widgets
        self.create_widgets()

    def configure_dark_theme(self):
        # Set window background
        self.root.configure(bg='#1e1e1e')

        # Configure the ttk style for a dark theme
        style = ttk.Style()
        style.theme_use("clam")

        style.configure("TFrame", background="#1e1e1e")
        style.configure("TButton", background="#333333", foreground="white", borderwidth=0, padding=6)
        style.map("TButton",
                  background=[('active', '#555555')],
                  foreground=[('active', 'white')])

        style.configure("TLabel", background="#1e1e1e", foreground="white")
        style.configure("TProgressbar", troughcolor='#333333', background='#44aaff')

    def create_widgets(self):
        frame = ttk.Frame(self.root, padding="20 20 20 20")
        frame.pack(fill="both", expand=True)

        # Progress Bar (hidden by default)
        self.progress = ttk.Progressbar(frame, mode='indeterminate')

        # Create Baseline Button
        self.create_baseline_button = ttk.Button(frame, text="Create Baseline", command=self.create_baseline)
        self.create_baseline_button.pack(pady=10)

        # Run Check Button
        self.run_check_button = ttk.Button(frame, text="Run Check", command=self.run_check)
        self.run_check_button.pack(pady=10)

        # Generate Report Button
        self.generate_report_button = ttk.Button(frame, text="Generate Report", command=self.generate_report)
        self.generate_report_button.pack(pady=10)

        # Exit Button
        self.exit_button = ttk.Button(frame, text="Exit", command=self.root.quit)
        self.exit_button.pack(pady=10)

        # Progress bar at the bottom
        self.progress.pack(pady=10, fill='x')

    def show_loading(self, status):
        if status:
            self.progress.start()
            self.progress.pack(pady=10, fill='x')
        else:
            self.progress.stop()
            self.progress.pack_forget()

    def run_in_background(self, func, *args):
        # Threading function to prevent GUI freezing
        thread = threading.Thread(target=func, args=args)
        thread.start()

    def create_baseline(self):
        dir_path = filedialog.askdirectory(title="Select Directory for Baseline")
        if dir_path:
            self.show_loading(True)
            self.run_in_background(self._create_baseline_task, dir_path)

    def _create_baseline_task(self, dir_path):
        result = subprocess.run(['bash', './baselineCreate.sh', dir_path], capture_output=True, text=True)
        self.show_loading(False)
        messagebox.showinfo("Result", result.stdout)

    def run_check(self):
        ans = messagebox.askyesno("Warning", "Running a check will destroy any data stored in temp_Report.txt. Do you wish to continue?")
        if ans:
            dir_path = filedialog.askdirectory(title="Select Directory to Check")
            if dir_path:
                self.show_loading(True)
                self.run_in_background(self._run_check_task, dir_path)

    def _run_check_task(self, dir_path):
        result = subprocess.run(['bash', './Check.sh', dir_path], capture_output=True, text=True)
        self.show_loading(False)
        messagebox.showinfo("Result", result.stdout)

    def generate_report(self):
        report_name = filedialog.asksaveasfilename(defaultextension=".txt", filetypes=[("Text files", "*.txt")], title="Save Report As")
        if report_name:
            self.show_loading(True)
            self.run_in_background(self._generate_report_task, report_name)

    def _generate_report_task(self, report_name):
        result = subprocess.run(['bash', './Report.sh', './Reports/temp_Report.txt'], capture_output=True, text=True)
        with open(report_name, 'w') as f:
            f.write(result.stdout)
        self.show_loading(False)
        messagebox.showinfo("Result", f"Report generated at {report_name}")

if __name__ == "__main__":
    root = tk.Tk()
    app = FileIntegrityCheckerApp(root)
    root.mainloop()

