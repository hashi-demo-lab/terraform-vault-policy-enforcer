import base64
from cryptography.hazmat.primitives.ciphers.aead import AESGCM
from cryptography.exceptions import InvalidTag

# The exported key in base64 format (from your export command)
exported_key_base64 = "dJVPKVX48uKzWS6LLYAnC9g6QuOsM4b3PyBOSJ8UlI4="

# Base64 decode the key
key = base64.b64decode(exported_key_base64)
print(f"Decryption Key: {key.hex()}")

# The ciphertext returned from Vault during encryption, without the 'vault:v1:' prefix
ciphertext_base64 = "Qs5ZJP9GWzsRXOaAiPFlAI/GotwwUdorvucs7Dm45+F64U8RN9w/13BL"

# Decode the base64-encoded ciphertext
ciphertext = base64.b64decode(ciphertext_base64)
print(f"Ciphertext: {ciphertext.hex()}")

# Extract the nonce (first 12 bytes) and the encrypted data (remaining bytes)
nonce = ciphertext[:12]
encrypted_data = ciphertext[12:]

print(f"Nonce: {nonce.hex()}")
print(f"Encrypted Data: {encrypted_data.hex()}")

# Check if encrypted data is empty
if not encrypted_data:
    print("Error: Encrypted data is missing or corrupted.")
else:
    # Use the AES-GCM algorithm to decrypt
    aesgcm = AESGCM(key)
    try:
        decrypted_data = aesgcm.decrypt(nonce, encrypted_data, None)
        print("Decrypted Data:", decrypted_data.decode('utf-8'))
    except InvalidTag:
        print("Decryption failed: Invalid authentication tag")
