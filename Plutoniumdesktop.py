import tkinter as tk
from tkinter import messagebox
from time import strftime

class PlutoniumOS:
    def __init__(self, root):
        self.root = root
        self.root.title("PlutoniumOS v1.0")
        self.root.geometry("1000x600")
        
        # Cores do Sistema
        self.bg_color = "#0d0d0d"      # Fundo quase preto
        self.accent_color = "#00ff41"  # Verde "Matrix"
        self.taskbar_color = "#1a1a1a" # Cinza escuro
        
        # --- Área de Trabalho ---
        self.desktop = tk.Frame(self.root, bg=self.bg_color)
        self.desktop.pack(fill="both", expand=True)

        # --- Barra de Tarefas ---
        self.taskbar = tk.Frame(self.root, bg=self.taskbar_color, height=40)
        self.taskbar.pack(side="bottom", fill="x")

        # Botão Iniciar
        self.start_btn = tk.Button(self.taskbar, text="☢ PLUTONIUM", 
                                   bg=self.accent_color, fg="black",
                                   font=("Courier", 10, "bold"),
                                   command=self.toggle_menu,
                                   relief="flat", padx=10)
        self.start_btn.pack(side="left", padx=5, pady=5)

        # Relógio na Barra de Tarefas
        self.clock_label = tk.Label(self.taskbar, bg=self.taskbar_color, 
                                    fg=self.accent_color, font=("Courier", 12))
        self.clock_label.pack(side="right", padx=15)
        self.update_clock()

        # --- Ícones (Simulados com Botões) ---
        self.create_icon("Terminal", 20, 20, self.open_terminal)
        self.create_icon("System Info", 20, 100, self.open_info)

        # --- Menu Iniciar (Escondido por padrão) ---
        self.menu_visible = False
        self.menu_frame = tk.Frame(self.root, bg=self.taskbar_color, 
                                   highlightbackground=self.accent_color, highlightthickness=1)

    def update_clock(self):
        string = strftime('%H:%M:%S')
        self.clock_label.config(text=string)
        self.root.after(1000, self.update_clock)

    def create_icon(self, text, x, y, command):
        icon = tk.Button(self.desktop, text=f"📂\n{text}", 
                         bg=self.bg_color, fg="white", 
                         font=("Courier", 9), relief="flat",
                         activebackground=self.accent_color,
                         command=command, cursor="hand2")
        icon.place(x=x, y=y, width=80, height=70)

    def toggle_menu(self):
        if not self.menu_visible:
            self.menu_frame.place(x=0, y=self.root.winfo_height()-240, width=200, height=200)
            tk.Label(self.menu_frame, text="APPLICATIONS", bg=self.taskbar_color, 
                     fg=self.accent_color, font=("Courier", 10, "bold")).pack(pady=10)
            tk.Button(self.menu_frame, text="Shutdown", bg="#ff4444", fg="white", 
                      command=self.root.quit).pack(side="bottom", fill="x", padx=10, pady=10)
            self.menu_visible = True
        else:
            self.menu_frame.place_forget()
            self.menu_visible = False

    # --- Funções dos "Apps" ---
    def open_terminal(self):
        win = tk.Toplevel(self.root)
        win.title("Plutonium Terminal")
        win.geometry("400x300")
        win.configure(bg="black")
        
        txt = tk.Label(win, text="root@plutonium:~# ", bg="black", 
                       fg=self.accent_color, font=("Courier", 10))
        txt.pack(anchor="nw", padx=5, pady=5)
        
        entry = tk.Entry(win, bg="black", fg="white", insertbackground="white", borderwidth=0)
        entry.pack(fill="x", padx=5)
        entry.focus_set()

    def open_info(self):
        messagebox.showinfo("PlutoniumOS", "Version 1.0.0\nKernel: Python 3.x\nStatus: Radioactive")

if __name__ == "__main__":
    root = tk.Tk()
    app = PlutoniumOS(root)
    root.mainloop()
