# DD1349 Multiplayer Platformer

This is a project for the course DD1349. It is a multiplayer platformer game made using the Godot game engine and written in GDScript. 

The project has evolved from a basic single-player prototype into a client-server multiplayer game where players can join a host, move around the map, and fight enemies.

## Player Controls
The player can move around, jump, dash and attack both with melee and ranged attacks. This is done via keyboard input, and most commands are bound to two keys.
The player can therefore choose which key combination they wish to use. Key binds are as follows:

Movement - 'A' & 'D' and 'Right arrow' & 'Left arrow'
* Jump - 'Space bar' and 'W' and 'Up arrow' 
* Dash - 'Shift' or 'C'
* Melee atttack - J and X
* Ranged attack - K and F


## 🎮 How to Play & Test

**Download:** Get the latest build `.zip` mathcing your OS from the **[Releases](../../releases)** tab (currently supports Linux and Windows), extract, and run the executable. Alternatively you can download the source code or clone the repo and then run the `project.godot` file in Godot 4.

**Play Locally (Same Computer):**
1. Open two game instances.
2. **Instance 1:** Click **Host** (This becomes the server and Player 1).
3. **Instance 2:** Leave the IP field blank (defaults to `localhost:42069`) and click **Join**.

**Play Online:**
The **Host** needs to allow incoming connections via one of these methods:
* **Port Forwarding (Traditional):** Forward UDP port `42069` in your router. Give your Public IP to the client so they can connect (`[Your_IP]:42069`).
* **Tunneling (Easier):** Run a tool like [playit.gg](https://playit.gg/) or[ngrok](https://ngrok.com/) to route traffic to `localhost:42069`. Share the generated custom address with the client.

## 🖥️ Exporting a Dedicated Server Build
To host a standalone, headless server (no player client attached):
1. In Godot, go to **Project > Export**.
2. Create a new export profile (e.g., "Linux server").
3. Under the **Resources** tab, set **Export Mode** to **"Export as dedicated server"**.
4. Under the **Options** tab, check **"Embed PCK"**.
5. Click **Export Project**.
*(Note: Deploying this build to a VPS and setting up the network is left up to you!)*

## 🛠️ Troubleshooting

* **I clicked Join, but nothing happened!** Ensure the Host has successfully started the server. Also check that your firewall/antivirus is not blocking the game (click "Allow Access" if prompted).
* **My friend can't connect to my public IP!** Double-check your IPv4 port forwarding. If your ISP uses CGNAT, port forwarding won't work—use a tunneling service instead.
* **Teleporting players/enemies!** High ping triggers the server's anti-desync logic, snapping entities back to their "true" positions. A wired ethernet connection is recommended for the host.

---

## Features

* **Multiplayer Networking:** Client-server architecture with host-player or dedicated server modes. Includes a dynamic in-game Ping/RTT display and client-side drift correction to ensure smooth movement. Dedicated servers automatically reset the game state when all players leave.
* **Player Mechanics:** Walking, jumping, dashing, animated attacks, and directional facing.
* **Combat System:** Dynamic health tracking with UI health bars, melee attacks, ranged projectile attacks, and environmental hazards. Combat features a knockback stun mechanic that temporarily disables player input and enemy AI.
* **Enemy AI:** Enemies use a state machine to patrol areas, detect edges/walls, and dynamically evaluate targets to chase the closest player within range.

## Key Technologies and Components

Instead of relying on external libraries, this project utilizes Godot 4's built-in nodes and systems to handle game logic and networking:

* **GDScript:** The Python-like scripting language built into Godot, used for all game logic.
* **ENetMultiplayerPeer:** Handles the raw data transmission over specific ports to create the server and connect clients.
* **MultiplayerSynchronizer:** Synchronizes variables across peers. Used to sync player inputs to the server, and to broadcast positions, velocities, and health back to the clients.
* **MultiplayerSpawner:** Automatically handles the replication of dynamically spawned objects (Players, Enemies, Hitboxes, and Projectiles). 
* **CharacterBody2D:** The base physics node used for the player and enemies. Provides built-in functions for moving, sliding against walls, and applying gravity.
* **RPC (Remote Procedure Calls):** Used for lightweight, direct communication between clients and the server (e.g., triggering jump inputs or synchronizing attack animations via `AnimationPlayer`).
* **Feature Tags:** Utilizes `OS.has_feature("dedicated_server")` and command-line arguments (`--server`) to seamlessly boot the game in headless server mode.

## Development Tools

To help with the development process, AI tools such as GitHub Copilot and ChatGPT are used to assist with problem-solving, logic structuring, code generation and documentation.
