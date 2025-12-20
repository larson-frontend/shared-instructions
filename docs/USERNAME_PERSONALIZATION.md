# Username Personalization for Agent Names

## Overview

All init scripts now support optional username personalization, allowing developers to create personalized agent names instead of using the generic "Custom_Auto" name.

## Usage

### Command-Line Flag

All three init scripts accept a `--username` flag:

```bash
# JetBrains (IntelliJ IDEA)
./shared-instructions/scripts/init-shared-instructions-jetbrains.sh --username "Mario"

# VSCode
./shared-instructions/scripts/init-shared-instructions-vscode.sh --username "Alice"

# Eclipse
./shared-instructions/scripts/init-shared-instructions-eclipse.sh --username "Bob"
```

### Interactive Prompt

If you don't provide the `--username` flag and not running in `--non-interactive` mode, the script will prompt you:

```
Optional: Enter your username to personalize the agent name.
  - Enter a custom name (e.g., 'Mario')
  - Type 'random' for a Mario Bros character
  - Press Enter to use 'Custom_Auto'
Username: random
```

**Result:**
```
🎮 Random character selected: yoshi
Agent name set to: yoshi-custom_agent
```

### Behavior

| Input | Normalized | Agent Name |
|-------|------------|------------|
| `Mario` | `mario` | `mario-custom_agent` |
| `Alice Smith` | `alice_smith` | `alice_smith-custom_agent` |
| `Bob-Dev` | `bob-dev` | `bob-dev-custom_agent` |
| `random` | *(random Mario character)* | `yoshi-custom_agent` 🎮 |
| *(empty)* | *(empty)* | `Custom_Auto` |

**Normalization Rules:**
- Converts to lowercase
- Replaces spaces with underscores
- Preserves hyphens and underscores

**Random Option:**
- Type `random` to get a random Mario Bros character name
- Characters include: mario, luigi, peach, yoshi, bowser, toad, rosalina, and 20+ more!
- Each run selects a different random character
- Characters are stored in `config/mario-names.conf`

## Examples

### Example 1: Random Mario Character 🎮

```bash
cd fasting-service
../shared-instructions/scripts/init-shared-instructions-jetbrains.sh --username random
```

**Output:**
```
Using shared-instructions at: /path/to/shared-instructions
Symlink shared-instructions already correct.
JetBrains setup complete.
🎮 Random character selected: bowser
Agent name set to: bowser-custom_agent

Tip: Log this setup in agent-usage.md:
  ./shared-instructions/scripts/log-agent-usage.sh \
  --agent "bowser-custom_agent" \
  --task setup \
  --model <model> \
  --status primary \
  --desc "Linked IntelliJ IDEA settings to shared-instructions"
```

### Example 2: With Username Flag

```bash
cd fasting-frontend
../shared-instructions/scripts/init-shared-instructions-vscode.sh --username "Alice"
```

**Output:**
```
Using shared-instructions at: /path/to/shared-instructions
Symlink shared-instructions already correct.
settings.json merged successfully.
Setup complete.
Agent name set to: alice-custom_agent

Tip: Log this setup in agent-usage.md (optional):
  ./shared-instructions/scripts/log-agent-usage.sh \
  --agent "alice-custom_agent" \
  --task setup \
  --model <model> \
  --status primary \
  --desc "Linked VS Code settings to shared-instructions"
```

### Example 2: Interactive Mode (Empty Input)

```bash
cd fasting-service
../shared-instructions/scripts/init-shared-instructions-jetbrains.sh
```

**Prompts:**
```
Optional: Enter your username to personalize the agent name.
  - Enter a custom name (e.g., 'Mario')
  - Type 'random' for a Mario Bros character
  - Press Enter to use 'Custom_Auto'
Username: [Enter]
```

**Output:**
```
Agent name: Custom_Auto (default)

Tip: Log this setup in agent-usage.md (optional):
  ./shared-instructions/scripts/log-agent-usage.sh \
  --agent "Custom_Auto" \
  --task setup \
  --model <model> \
  --status primary \
  --desc "Linked IntelliJ IDEA settings to shared-instructions"
```

### Example 4: Non-Interactive Mode (No Username)

```bash
cd fasting-frontend
../shared-instructions/scripts/init-shared-instructions-eclipse.sh --non-interactive
```

**Output:**
```
Using shared-instructions at: /path/to/shared-instructions
Symlink shared-instructions already correct.
Eclipse setup complete.
Agent name: Custom_Auto (default)

Tip: Log this setup in agent-usage.md (optional):
  ./shared-instructions/scripts/log-agent-usage.sh \
  --agent "Custom_Auto" \
  --task setup \
  --model <model> \
  --status primary \
  --desc "Linked Eclipse settings to shared-instructions"
```

## Benefits

### Individual Developer Tracking

Each developer can use their own personalized agent name, making it easier to track contributions in per-repo `.agent-usage.md` files:

**shared-instructions/.agent-usage.md:**
```markdown
| Agent Name | Task | Model | Status | Language | Date | Description |
|------------|------|-------|--------|----------|------|-------------|
| mario-custom_agent | setup | claude-sonnet-4.5 | primary | mixed | 2025-01-30 | Initial setup by Mario |
| alice-custom_agent | setup | claude-sonnet-4.5 | primary | mixed | 2025-01-30 | Initial setup by Alice |
```

### Team Collaboration

When reviewing stats, you can easily see which developer used which agent:

```bash
./shared-instructions/scripts/stats-agent-usage.sh
```

**Output:**
```
╔════════════════════════════════════════════════════════════╗
║                    AGENT USAGE STATS                       ║
╚════════════════════════════════════════════════════════════╝
Total Entries: 15

By Agent:
  mario-custom_agent   ████████░░ 8  (53%)
  alice-custom_agent   ████░░░░░░ 5  (33%)
  Custom_Auto          ██░░░░░░░░ 2  (13%)
```

## Integration with Logging

The personalized agent name is automatically used in the logging tip displayed after setup:

```bash
./shared-instructions/scripts/log-agent-usage.sh \
  --agent "mario-custom_agent" \
  --task setup \
  --model claude-sonnet-4.5 \
  --status primary \
  --desc "Linked VS Code settings to shared-instructions"
```

This ensures consistency between the init script and subsequent logging.

## Scripts Supporting Username Personalization

All three init scripts support the `--username` flag:

1. **`init-shared-instructions-jetbrains.sh`** - JetBrains (IntelliJ IDEA, WebStorm, etc.)
2. **`init-shared-instructions-vscode.sh`** - Visual Studio Code
3. **`init-shared-instructions-eclipse.sh`** - Eclipse IDE

## Testing

### Test Case 1: Username Provided

```bash
# JetBrains
bash init-shared-instructions-jetbrains.sh --username "Mario"
# Expected: Agent name set to: mario-custom_agent

# VSCode
bash init-shared-instructions-vscode.sh --username "Alice"
# Expected: Agent name set to: alice-custom_agent

# Eclipse
bash init-shared-instructions-eclipse.sh --non-interactive --username "Bob"
# Expected: Agent name set to: bob-custom_agent
```

### Test Case 2: Random Mario Character 🎮

```bash
# JetBrains
bash init-shared-instructions-jetbrains.sh --username random
# Expected: 🎮 Random character selected: <character>
# Expected: Agent name set to: <character>-custom_agent

# VSCode
bash init-shared-instructions-vscode.sh --username random
# Expected: 🎮 Random character selected: <character>
# Expected: Agent name set to: <character>-custom_agent

# Eclipse
bash init-shared-instructions-eclipse.sh --non-interactive --username random
# Expected: 🎮 Random character selected: <character>
# Expected: Agent name set to: <character>-custom_agent
```

### Test Case 3: Default Agent Name

```bash
# JetBrains
echo "" | bash init-shared-instructions-jetbrains.sh
# Expected: Agent name: Custom_Auto (default)

# VSCode (non-interactive mode)
bash init-shared-instructions-vscode.sh --non-interactive
# Expected: Agent name: Custom_Auto (default)

# Eclipse (non-interactive mode)
bash init-shared-instructions-eclipse.sh --non-interactive
# Expected: Agent name: Custom_Auto (default)
```

### Test Case 3: Complex Usernames

```bash
# With spaces
bash init-shared-instructions-vscode.sh --username "Alice Smith"
# Expected: Agent name set to: alice_smith-custom_agent

# With hyphens
bash init-shared-instructions-eclipse.sh --username "Bob-Dev"
# Expected: Agent name set to: bob-dev-custom_agent

# Mixed case
bash init-shared-instructions-jetbrains.sh --username "MarioRossi"
# Expected: Agent name set to: mariorossi-custom_agent
```

## Mario Bros Character List 🎮

The random option selects from 28 Mario Bros characters stored in `config/mario-names.conf`:

**Heroes:** mario, luigi, peach, daisy, toad, toadette, yoshi, rosalina, pauline, cappy

**Villains:** bowser, wario, waluigi, king_boo, kamek

**Enemies/NPCs:** koopa, goomba, shy_guy, boo, hammer_bro, lakitu, dry_bones

**Friends:** birdo, donkey_kong, diddy_kong, nabbit, toadsworth, polterpup

You can add more characters by editing `config/mario-names.conf` - just add one name per line!

## Future Enhancements

### Potential Improvements

1. **Global Configuration:**
   - Store username in `~/.config/shared-instructions/username` to avoid re-entering
   - Auto-detect from git config: `git config user.name`

2. **Team Name Support:**
   - Allow team prefixes: `--team "frontend"` → `frontend-mario-custom_agent`
   - Useful for large teams with multiple developers named "Mario"

3. **Validation:**
   - Warn if username contains special characters that might cause issues
   - Suggest alternative normalization (e.g., removing all non-alphanumeric except `-_`)

4. **Stats Filtering:**
   - Filter stats by developer: `stats-agent-usage.sh --user mario`
   - Compare stats between developers: `stats-agent-usage.sh --compare mario,alice`

## See Also

- [Installation Guide](INSTALLATION.md) - General setup instructions
- [Agent Usage Documentation](agent-usage.md) - Per-repo stats and logging
- [Init Scripts](../scripts/) - Source code for all init scripts
