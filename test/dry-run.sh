#!/bin/bash
# Dry-run test helper script
# Usage: ./test/dry-run.sh <playbook-name>
# Example: ./test/dry-run.sh youtube-sync

PLAYBOOK=$1
TIMESTAMP=$(date +%Y%m%d-%H%M%S)
LOG_DIR="test/logs"
LOG_FILE="${LOG_DIR}/${PLAYBOOK}-dryrun-${TIMESTAMP}.log"

# Create log directory if it doesn't exist
mkdir -p "$LOG_DIR"

# Print usage if no playbook specified
if [ -z "$PLAYBOOK" ]; then
    echo "Usage: $0 <playbook-name>"
    echo "Example: $0 youtube-sync"
    echo ""
    echo "Available playbooks:"
    ls -1 playbooks/*.yml | xargs -n1 basename | sed 's/\.yml$//'
    exit 1
fi

# Check if playbook exists
if [ ! -f "playbooks/${PLAYBOOK}.yml" ]; then
    echo "Error: playbooks/${PLAYBOOK}.yml not found"
    exit 1
fi

echo "Running dry-run for: ${PLAYBOOK}"
echo "Log file: ${LOG_FILE}"
echo "Enter sudo password when prompted..."
echo "---"

# Run ansible-playbook with dry-run and save to log
ansible-playbook "playbooks/${PLAYBOOK}.yml" --check --diff -K 2>&1 | while IFS= read -r line; do
    echo "$line"  # Display to terminal
    echo "$line" >> "$LOG_FILE"  # Save to file
done

echo "---"
echo "Dry-run complete! Log saved to: ${LOG_FILE}"
echo "Latest log symlink: test/logs/latest.log"

# Create symlink to latest log
ln -sf "$(basename "$LOG_FILE")" "${LOG_DIR}/latest.log"