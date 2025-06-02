# 💠 Solana Devnet Token Generator

This project automates the full lifecycle of creating an SPL token on **Solana Devnet** using CLI tools. It:

- Generates two keypairs (for funding and minting)
- Airdrops SOL to the funder
- Creates a new token with metadata
- Mints 1000 tokens to the generated mint account

> ⚠️ For **testing purposes only** on Solana Devnet. No real value is associated.

---

## 🛠 Prerequisites

- [Solana CLI](https://docs.solana.com/cli/install-solana-cli)
- [SPL Token CLI](https://spl.solana.com/token)
- Internet connection

---

## 📁 Project Structure

```bash
.
├── keys/                    # Contains generated keypairs
├── metadata/                # Contains metadata.json for your token
├── token-create.sh          # Main automation script
└── README.md                # This file
```

## Usage

```bash
chmod +x create-and-mint-token.sh
./create-and-mint-token.sh
```
