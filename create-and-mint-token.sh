#!/bin/bash

# === Configuration ===
KEYS_DIR="./keys"
TOKEN_NAME="DevT"
TOKEN_SYMBOL="DEVT"
METADATA_URL="https://raw.githubusercontent.com/ARMIN11DSE/new-token/main/metadata/metadata.json"
SOL_AMOUNT="0.5"

mkdir -p "$KEYS_DIR"
cd "$KEYS_DIR" || exit

echo "🔑 Generating BOS keypair..."
solana-keygen grind --starts-with bos:1
BOS_KEYPAIR=$(basename "$(ls bos*.json)")
BOS_ADDRESS=$(solana-keygen pubkey "$BOS_KEYPAIR")
echo "✅ Token Bos Address: $BOS_ADDRESS"

cd ..

echo "🔧 Setting Solana config..."
solana config set --keypair "$KEYS_DIR/$BOS_KEYPAIR"
solana config set --url devnet

echo "💸 Airdropping $SOL_AMOUNT SOL to BOS wallet..."
solana airdrop "$SOL_AMOUNT" "$BOS_ADDRESS" --url https://api.devnet.solana.com

echo "🔑 Generating MNT keypair..."
cd "$KEYS_DIR" || exit
solana-keygen grind --starts-with mnt:1
MNT_KEYPAIR=$(basename "$(ls mnt*.json)")
MNT_ADDRESS=$(solana-keygen pubkey "$MNT_KEYPAIR")
echo "✅ Token Mint Address: $MNT_ADDRESS"

cd ..

echo "🪙 Creating token using MNT as mint authority..."
spl-create-token TokenzQdBNbLqP5VEhdkAS6EPFLC1PHnBqCXEpPxuEb --enable-metadata "$KEYS_DIR/$MNT_KEYPAIR"

echo "📦 Initializing metadata..."
spl-token initialize-metadata "$MNT_ADDRESS" "$TOKEN_NAME" "$TOKEN_SYMBOL" "$METADATA_URL" --mint-authority "$KEYS_DIR/$MNT_KEYPAIR"

echo "📬 Creating associated token account..."
spl-token create-account "$MNT_ADDRESS"

echo "💎 Minting account..."
spl-token mint "$MNT_ADDRESS" 1000

echo "🎉 Token successfully created on Devnet!"
echo "🔗 View on Solana Explorer:"
echo "https://explorer.solana.com/address/$BOS_ADDRESS?cluster=devnet"
echo "https://explorer.solana.com/address/$MNT_ADDRESS?cluster=devnet"