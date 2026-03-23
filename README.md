# 📦 Modern Old-Time Phonebook

**Version:** 2.1 **Creator:** Nikos Georgousis (Original concept by Scott Brodsky) **Environment:** Windows (PowerShell 5.1+)

## 1. Overview and Architecture

This tool is a lightweight, zero-dependency, self-contained contact management system. It operates through a modern, color-coded Command Line Interface (CLI) inspired by the Linux "Nala" package manager.

The ecosystem relies on three core files:

-   `pb.bat` **(The Launcher):** A tiny batch file that safely acts as a bridge. It bypasses Windows execution policies and routes your commands seamlessly to the PowerShell engine.
    
-   `pb.ps1` **(The Engine):** The main PowerShell script. It contains the interactive application loop, search filters, database manipulation, and UI rendering logic.
    
-   `notes.txt` **(The Database):** A plain-text file acting as the raw database. It is strictly encoded in **UTF-8 with BOM** to natively support Greek characters and advanced symbols without corruption.
    

## 2. Operation Modes

The script dynamically detects how you launch it and adapts its behavior:

-   **Interactive App Mode:** Triggered by double-clicking `pb.bat` or typing `pb` without arguments. The window stays open, provides a `pb>` prompt, and redraws the UI continuously as you interact with it.
    
-   **One-Shot CLI Mode:** Triggered by typing `pb <command>` directly into an existing Windows command prompt. It executes the single command, prints the result, and immediately exits back to your standard prompt.
    

## 3. Command Reference

These commands can be used either as arguments (`pb -init`) or typed directly into the interactive `pb>` prompt.

-   `<search_term>`: Simply type any keyword (e.g., `Raktas` or `6944`). The script performs a case-insensitive substring match across Names, Phones, and Groups.
    
-   `-add "Name Phone #Group !Color"`: Appends a new contact to the database. (Quotes are recommended but handled intelligently if forgotten).
    
-   `-del "Name"`: Safely removes any contact matching the string.
    
-   `-init`: Generates a fresh, instruction-filled `notes.txt` template. Contains a safety lock: it will abort if `notes.txt` already exists to prevent data loss.
    
-   `n`: Opens the raw `notes.txt` database in Windows Notepad for manual editing.
    
-   `e`: Opens the directory housing the script in Windows File Explorer.
    
-   `q` / `exit` / `quit`: Closes the interactive application loop.
    

## 4. Database Formatting & Syntax (`notes.txt`)

The engine uses a highly resilient Regex (Regular Expression) parser to interpret the raw text file.

### Separation Rule (CRITICAL)

The script determines where a Name ends and a Phone number begins by detecting **two or more consecutive spaces (or tabs)**.

-   **Valid:** `Raktas Kostas 6999 767574` (Multiple spaces trigger the split).
    
-   **Invalid:** `Raktas Kostas 6999 767574` (Only one space; the script will think the entire line is just a Name).
    

### Advanced Flags

You can append special tags anywhere on a line to trigger advanced UI features. The parser silently strips these tags out before displaying the text.

-   **Grouping (`#Name`):** Adding a hashtag (e.g., `#Work`, `#VIP`, `#Family`) pulls the contact out of the default list and groups them under a dedicated, color-coded header. If omitted, the contact defaults to the "GENERAL" group.
    
-   **Highlighting (`!Color`):** Adding an exclamation point followed by a standard PowerShell color (e.g., `!Red`, `!Cyan`, `!Yellow`, `!Magenta`, `!Green`) overrides the default alternating gray/white row stripes and forces the row to display in that specific color.
    

### Ignored Data (Comments & Legacy)

The parser is designed to ignore "junk" data so your UI remains perfectly clean. It automatically skips:

-   Empty/blank lines.
    
-   Legacy header elements (lines starting with `---`, `Info:`, `/HELP`, or `=`).
    
-   **Developer Comments:** Any line starting with `//` is treated as a hidden comment. You can use this to write instructions or notes inside `notes.txt` that will never appear in the UI.
    

## 5. Safety & Self-Healing Mechanisms

-   **UTF-8 Enforcement:** The script forces `[Console]::OutputEncoding = [System.Text.Encoding]::UTF8` at runtime, ensuring Greek language inputs and outputs are never scrambled.
    
-   **Auto-Backup:** Before the script executes an `-add` or `-del` command, it silently triggers a `Copy-Item` command to create `notes.txt.bak`. If a deletion goes wrong, your previous state is instantly recoverable.
    
-   **Dynamic Padding:** The script calculates the character length of the longest name in your current search results and dynamically aligns the "Phone" column based on that variable (`$maxLen`), ensuring perfect vertical alignment regardless of screen size.
