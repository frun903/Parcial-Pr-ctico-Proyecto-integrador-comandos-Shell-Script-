import tkinter as tk
from tkinter import messagebox
import subprocess
import os

# Ruta absoluta al script bash
SCRIPT_PATH = os.path.abspath("integrador.sh")

def ejecutar_opcion(opcion):
    if not os.path.exists(SCRIPT_PATH):
        messagebox.showerror("Error", f"No se encontró el script:\n{SCRIPT_PATH}")
        return

    try:
        subprocess.run(["gnome-terminal", "--", "bash", "-c", f'"{SCRIPT_PATH}" {opcion}; exec bash'])
    except Exception as e:
        messagebox.showerror("Error al ejecutar", str(e))

ventana = tk.Tk()
ventana.title("Gestor de Directorios - GUI")
ventana.geometry("400x300")

tk.Label(ventana, text="Gestor de Directorios (Proyecto Integrador)", font=("Arial", 12, "bold")).pack(pady=10)

tk.Button(ventana, text="Listar directorios", command=lambda: ejecutar_opcion("--listar"), width=30, bg="lightblue").pack(pady=5)
tk.Button(ventana, text="Crear directorio", command=lambda: ejecutar_opcion("--crear"), width=30, bg="lightgreen").pack(pady=5)
tk.Button(ventana, text="Borrar directorio", command=lambda: ejecutar_opcion("--borrar"), width=30, bg="tomato").pack(pady=5)
tk.Button(ventana, text="Ver errores", command=lambda: ejecutar_opcion("--errores"), width=30, bg="orange").pack(pady=5)

tk.Button(ventana, text="Salir", command=ventana.destroy, width=30).pack(pady=20)

ventana.mainloop()
