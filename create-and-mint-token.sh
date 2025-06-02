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
solana-keygen grind --starts-with bos:1 --ignore-case -n 1 -o BOS.json
BOS_KEYPAIR=$(basename "$(ls bos*.json)" .json)
BOS_ADDRESS=$(solana-keygen pubkey "$BOS_KEYPAIR.json")

cd ..

echo "🔧 Setting Solana config..."
solana config set --keypair "$KEYS_DIR/$BOS_KEYPAIR.json"
solana config set --url https://api.devnet.solana.com

echo "💸 Airdropping $SOL_AMOUNT SOL to BOS wallet..."
solana airdrop "$SOL_AMOUNT" "$BOS_ADDRESS" --url https://api.devnet.solana.com

echo "🔑 Generating MNT keypair..."
cd "$KEYS_DIR" || exit
solana-keygen grind --starts-with mnt:1 --ignore-case -n 1 -o MNT.json
MNT_KEYPAIR=$(basename "$(ls mnt*.json)" .json)
MNT_ADDRESS=$(solana-keygen pubkey "$MNT_KEYPAIR.json")
cd ..

echo "🪙 Creating token using MNT as mint authority..."
TOKEN_MINT=$(spl-token create-token --owner "$KEYS_DIR/$MNT_KEYPAIR.json" --enable-metadata | grep 'Creating token' | awk '{print $3}')
echo "✅ Token Mint Address: $TOKEN_MINT"

echo "📦 Initializing metadata..."
spl-token initialize-metadata "$TOKEN_MINT" "$TOKEN_NAME" "$TOKEN_SYMBOL" "$METADATA_URL" --mint-authority "$KEYS_DIR/$MNT_KEYPAIR.json"

echo "📬 Creating associated token account..."
spl-token create-account "$TOKEN_MINT"

echo "🎉 Token successfully created on Devnet!"
echo "🔗 View on Solana Explorer:"
echo "https://explorer.solana.com/address/$TOKEN_MINT?cluster=devnet"
