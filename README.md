# Copmito - Isekai Top-Down Pixel RPG (Starter)

This repository contains a lightweight starter project for a top-down isekai pixel RPG.
You asked for: top-down RPG isekai, demon king boss, pixel style, open world starter, rules, periodic testing, and explicit bug/reporting guidance.

What I added now (starter):
- Godot 4.x project files (project.godot, Main.tscn, icon)
- scripts/: GameManager.gd, Player.gd, Enemy.gd, NPC.gd
- Minimal world layout generated at runtime
- Player movement, melee attack, basic HP and signals
- Enemies with patrol and Demon King boss (chase)
- HUD showing HP and quest status

How to open
1. Install Godot 4.x (recommended 4.3+).
2. Clone this repo: git clone https://github.com/dodosadventure46-cell/Copmito-godot.git
3. Open the folder in Godot (Import/Open project) and press Play (F5).

Gameplay notes (starter):
- Movement: WASD / Arrow keys
- Attack: Space / Enter (melee around player)
- Restart: R (after death or quest complete)
- Goal: Defeat the Demon King (a boss enemy named "DemonKing")

Development rules & workflow (as requested)
- Test regularly: after any change, run the scene and smoke-test player movement, combat, and NPC interactions.
- When you find a bug: create a GitHub issue in this repo with steps to reproduce, Godot version, console output, and which platform.
- If I (assistant) am unsure about a requirement, I'll ask clarifying questions before making changes.
- If you are unsure or there's missing info, please state it; I'll ask follow-ups.

Testing checklist (manual)
- [ ] Player can move in 8 directions smoothly.
- [ ] Player can attack and damage nearby enemies.
- [ ] Enemies patrol and boss chases the player.
- [ ] HUD updates HP and quest status correctly.
- [ ] Restart works with R key.

Bug reporting template (suggested)
Title: Short description
Steps to reproduce:
1. 
2. 
3. 
Expected result:
Actual result:
Godot version:
Platform (Windows/macOS/Linux):
Console/Output logs (if any):

If you want, I can also:
- Add a proper pixel art Tileset and sprite sheets (you can attach images or I can produce placeholders).
- Implement saving, inventory, dialogue system, quest log, and more.
- Integrate periodic automated tests (basic unit tests for some logic) — Godot's unit testing is limited but we can use scene tests or external scripts.

Next steps I suggest:
1. Try opening the project in Godot and run Main.tscn.
2. Play around and report any bugs using the template above by opening an issue.
3. Tell me which feature to implement next (e.g., inventory, dialogue tree, map transitions, pixel sprites, sound).

If anything is unclear: I will ask. If you see a bug: report it and I'll prioritize fixes.
