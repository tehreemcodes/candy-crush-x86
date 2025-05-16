# Candy Crush Game in x86 Assembly

🎮 A graphical console-based **Candy Crush clone** implemented in **x86 Assembly Language**, using **MS-DOS interrupts** for graphics, text input/output, and file handling.

---

## 👨‍💻 Authors

- **Tehreem Zafar** (22i-1630)  
- **Umar Murtaza** (22i-7431)  
- **Course:** CY-A — Computer Organization & Assembly Language  
- **Project:** Final Semester Project

---

## 🚀 Features

- Welcome screen and player name input
- Multi-level gameplay (3 levels with increasing difficulty)
- Graphical display of colorful candies:
  - Square (Yellow)
  - Rectangle (Blue)
  - Heart (Pink)
  - Triangle (Purple)
  - Diamond (Light Blue)
  - Color Bombs and Blockers
- Real-time cursor-based interaction via mouse
- Score calculation based on candy type and matches
- Basic animations and effects (like “Sweet” and “Crushing” messages)
- File logging of player names (`players.txt`)
- Modular code using procedures for clarity and reuse

---

## 🕹️ How to Play

1. Launch the program in a DOSBox environment.
2. Enter your name.
3. Choose a level (1, 2, or 3).
4. Use your mouse to click two adjacent candies to swap them.
5. Form combinations of **3 or more same candies** to crush and score points.
6. Achieve the target score in 15 moves to pass the level.

---

## 💾 Requirements

- **DOSBox** or any x86 emulator supporting:
  - BIOS and DOS interrupts (`INT 10h`, `INT 21h`, `INT 33h`)
  - Real-mode execution
- TASM (Turbo Assembler) or MASM (Microsoft Assembler)
- 16-bit x86 environment

---

## 🔧 How to Compile & Run

1. Assemble and link using TASM:

   ```bash
   tasm PROJECT.ASM
   tlink PROJECT.OBJ
2. Run using DOSBox:
      ```bash
   dosbox PROJECT.EXE

## 📂 File Structure
📦 CandyCrush-x86
├── PROJECT.ASM        # Main source code (x86 Assembly)
└── README.md          # Project documentation

## 📌 Notes
- Color codes and candy shapes are drawn using pixel manipulation via INT 10h graphics mode (mode 13h).
- Color Bomb and Blockers are special candies introduced in levels 2 and 3.
- Project was developed for educational purposes and demonstrates advanced assembly programming with graphical logic.

## 📜 License
This project is intended for educational use. Feel free to fork or modify for your learning purposes. Attribution appreciated.
