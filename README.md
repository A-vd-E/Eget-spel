# DD1349 Multiplayer Platformer

This is a project for the course DD1349. It is a multiplayer platformer game made using the Godot game engine and written in GDScript. 

The project has evolved from a basic single-player prototype into a client-server multiplayer game where players can join a host, move around the map, and fight enemies.

## 🎮 How to Play & Test

### Downloading the Game
1. Go to the **[Releases](../../releases)** tab on the right side of this GitHub page.
2. Download the latest `.zip` file for your operating system.
3. Extract the folder and run the executable file to start the game.

*(Alternatively, you can clone this repository and open the `project.godot` file in Godot 4 to run it from the editor).*

### Testing Locally (On the same computer)
To test the multiplayer features by yourself:
1. Open two separate instances of the game.
2. On **Instance 1**, click the **Host** button. This window is now the server and Player 1.
3. On **Instance 2**, leave the IP field blank (it will default to `localhost:42069`) and click **Join**. This window is now Player 2.

### Playing over the Internet
If you want to play with friends across the internet, the **Host** will need to set up their network to allow incoming connections.

**Option A: Port Forwarding (Traditional)**
1. The Host must log into their router settings and **Port Forward** port `42069` (UDP).
2. The Host finds their Public IP address (by googling "What is my IP").
3. The Host gives this IP to the client.
4. The Client types `[Host_Public_IP]:42069` into the IP box and clicks **Join**.

**Option B: Using Tunnels (Recommended for quick testing)**
If you cannot port forward, you can use a tunneling service like [playit.gg](https://playit.gg/) or [ngrok](https://ngrok.com/).
1. The Host runs the game and clicks **Host**.
2. The Host starts the tunneling service and routes it to `localhost:42069`.
3. The tunneling service will provide a custom address (e.g., `orange-tree.playit.gg:54321`).
4. The Client types that exact address into the IP box and clicks **Join**.

## 🛠️ Troubleshooting

* **I clicked Join, but nothing happened!**
  * Ensure the Host has successfully started the server before the Client tries to connect.
  * Check your firewall. Windows Defender or your antivirus might be blocking the game. A pop-up usually appears the first time you run the game, make sure to click **Allow Access**.
* **My friend can't connect to my public IP!**
  * Double-check that you port-forwarded correctly to the local IPv4 address of the computer actually running the Host instance.
  * Ensure your internet service provider (ISP) allows port forwarding (some use CGNAT, which blocks this. If so, use Option B above).
* **The players or enemies are teleporting wildly!**
  * If the connection is unstable or your ping is extremely high, the server's anti-desync logic (which snaps the player back into place) will kick in. A wired ethernet connection is recommended for the host!

---

## Features

* Multiplayer Networking: Client-server architecture where the host manages the game state, hit detection, and enemy AI, while clients sync to the server and predict local input.
* Player Mechanics: Walking, jumping, dashing, and attacking.
* Combat System: Custom hitbox and hurtbox logic with health tracking, damage, and knockback stun mechanics.
* Enemy AI: Enemies feature state machines with patrol and chase behaviors, including edge and wall detection.

## Key Technologies and Components

Instead of relying on external libraries, this project utilizes Godot 4's built-in nodes and systems to handle game logic and networking. Here are the core components used:

* **GDScript**: The python-like scripting language built into Godot, used for all game logic.
* **ENetMultiplayerPeer**: The underlying networking protocol used to create the server and connect clients. It handles the raw data transmission over specific ports.
* **MultiplayerSynchronizer**: A networking node that synchronizes variables across connected peers. We use it to sync player inputs from the client to the server, and to broadcast positions, velocity, and health from the server back to the clients.
* **MultiplayerSpawner**: Automatically handles the replication of dynamically spawned objects. When the server spawns a player, an enemy, or an attack hitbox, this node ensures it appears on all clients.
* **CharacterBody2D**: The base physics node used for the player and enemies. It provides built-in functions for moving, sliding against walls, and applying gravity.

## Development Tools

To help with the development process, AI tools such as GitHub Copilot and ChatGPT are used to assist with problem-solving, logic structuring, and code generation.
