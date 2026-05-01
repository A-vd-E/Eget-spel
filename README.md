# DD1349 Multiplayer Platformer

This is a project for the course DD1349. It is a multiplayer platformer game made using the Godot game engine and written in GDScript. 

The project has evolved from a basic single-player prototype into a client-server multiplayer game where players can join a host, move around the map, and fight enemies.

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
