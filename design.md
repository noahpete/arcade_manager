# Arcade Manager 2D: Design & Plan

*Living document. Update it whenever a decision is made. Unsorted ideas go in the Parking Lot, not the main sections.*

---

## 1. Overview

A 2D management game where you run a small arcade and grow it by buying more machines. Most of the time is spent inside the arcade, but short side tasks pull you out into a small town: trips to the bank, events around town, and more. Each arcade machine you own has its own minigame (pinball, skeeball, and many others).

### Pillars

1. **The arcade is home.** Most play time is spent inside it, and growing it should always feel rewarding.
2. **Minigames are the fun.** Machines aren't just income numbers; they're games worth playing.
3. **Town trips add variety, not friction.** Errands should be short and break up the routine.
4. **Small and cozy.** A compact town and a compact arcade, tuned for polish over scale.

### Current State

- Basic animated player that can walk around
- Basic tilemap with a floor
- Everything else is blank

---

## 2. Core Loop

**Earn money → buy a machine → place it → machines get used → earn more money → expand.**

Layered on top:

- **Daily loop:** open the arcade, serve customers, run errands, close, review the day, spend money.
- **Long-term loop:** expand the space, unlock new machine types, unlock town locations and events.

> Rule: if this loop isn't fun with placeholder rectangles, new content won't fix it.

---

## 3. Feature List

### Arcade (core)
- [X] Player movement and interaction (interact key near objects)
- [ ] Tile-based arcade floor with grid placement
  - --> TODO: convert Modes to state machine
- [ ] Machine placement, moving, and selling
- [ ] Machine data: price, payout, popularity, size, minigame
- [ ] Customers who walk in, pick a machine, play, and pay
- [ ] Money system and HUD
- [ ] Day/time cycle with open and closed hours
- [ ] End-of-day summary
- [ ] Shop/catalog for buying machines
- [ ] Arcade expansion (more floor space)
- [ ] Upgrades (machine upgrades, decor, staff)

### Minigames
- [ ] Shared minigame interface (start, finish, return a score)
- [ ] Skeeball
- [ ] Pinball
- [ ] Additional machines (see Parking Lot)
- [ ] Rewards for the player (tickets, bonus cash, high scores)

### Town
- [ ] Town map and transitions between arcade and town
- [ ] Bank (deposit cash, possibly loans)
- [ ] Events around town
- [ ] Other locations (suppliers, shops, etc.)
- [ ] Player's own plot of land where the arcade expands

### Systems and Polish
- [ ] Save/load
- [ ] Settings and input remapping
- [ ] Audio (music and machine sound effects)
- [ ] Tutorial/onboarding
- [ ] Final art pass

---

## 4. Game Outline

1. **Start:** a tiny, nearly empty arcade with a little cash and one or two basic machines.
2. **Early game:** learn the loop. Buy machines, serve a few customers, make first trips to the bank.
3. **Mid game:** the arcade fills up. More machine variety, town events appear, upgrades matter.
4. **Late game:** expand the building and land, juggle many machines and errands, chase high scores and goals.
5. **Open questions:** is there an ending, or is it endless? See "Things to Think About."

---

## 5. Implementation Plan (in order)

Keep the game **playable at all times**. Use placeholder art until the core loop is fun.

### Phase 1: Foundation
1. **Interaction system.** Interact key, detect nearby interactables, show a prompt.
2. **Money autoload and HUD.** Global money value, updates through signals.
3. **Generic machine scene.** Price, payout, "play" timer, interactable by the player.

### Phase 2: The loop
4. **Customers, version zero.** Spawn, walk to a free machine, wait, pay, leave.
5. **Shop and placement.** Buy a machine and place it on the tilemap grid.
6. **Day/time cycle.** Opening hours, closing, end-of-day summary.
7. **Save/load.** Do this early; it's harder to add later.

### Phase 3: Minigames
8. **Minigame interface.** A base contract every minigame follows (start, end, score).
9. **First minigame: skeeball.** Simplest to build and defines the pattern.
10. **Second minigame: pinball.** Tests whether the interface holds up.
11. **Player rewards.** Tickets, bonuses, or high scores for playing machines yourself.

### Phase 4: The town
12. **Scene transition** between arcade and town.
13. **Bank.** One reason to go (e.g. deposit register cash).
14. **Events.** One simple event to prove the system.
15. **More locations** as needed.

### Phase 5: Progression and content
16. Upgrades, expansion, unlocks
17. More machines and minigames
18. Balancing the economy

### Phase 6: Polish
19. Audio, art pass, tutorial, settings, bug fixing

---

## 6. Things to Think About

### Design
- **Who plays the machines?** Customers generating passive income, the player playing for bonuses, or both?
- **Are town trips mandatory or optional?** Mandatory errands can feel like chores unless they're short or add risk/reward (e.g. carrying a lot of cash).
- **Is there a failure state?** Bankruptcy, rent, upkeep costs, or purely relaxed?
- **Win condition or endless?**
- **How fast does time pass?** This affects every system's pacing.
- **Customer variety.** Do customers have preferences or moods?

### Technical (Godot)
- **Grid or free placement?** Grid makes placement and pathfinding much simpler.
- **Scene switching.** How the player and shared state persist between arcade and town (autoloads vs. re-instancing).
- **Data-driven machines.** Use Resources so adding a new machine means adding data, not rewriting code.
- **Customer pathfinding.** Navigation regions, AStarGrid2D, or simple steering.
- **Minigame isolation.** Should each minigame be its own scene that is loaded on top of the arcade, or played in-world?
- **Save format.** Decide what gets saved before adding many systems.

### Scope
- Cap the active task list at 3-5 items.
- Prefer a few polished machines over many shallow ones.
- Add content only after the loop feels good.

---

## 7. Parking Lot (unsorted ideas)

*Drop ideas here without committing to them.*

- Minigame ideas: pinball, skeeball, claw machine, whack-a-mole, air hockey, racing cabinet, rhythm game, basketball hoops, fighting-game cabinet
- Town event ideas: festival, fair, competition, tournament
- Staff to hire (cashier, mechanic)
- Machine breakdowns and repairs
- Cosmetic customization (decor, posters, flooring)
- Reputation or star rating for the arcade
- Seasonal changes in town
-

---

## 8. Decision Log

*Record decisions here with the date and the reason, so you don't re-debate them later.*

| Date | Decision | Reason |
|------|----------|--------|
|      |          |        |

---

## 9. Next Up

*Always end a work session by writing the very next task.*

1. Interaction system
2. Money autoload and HUD
3. Generic machine scene


## Misc

- Player can play own machines to get tickets
  - Use tickets to buy the prizes (from their own stock) they've purchased stock of online
- Upgrades
  - Can buy bigger bags for larger hauls from bank of coins
  - Services to fill coins for you

- Polish
  - Particles: add shines around prizes, frustration/emotes above characters, etc.
