import discord
import ssl
import certifi
import aiohttp
import asyncio
import os
from dotenv import load_dotenv
load_dotenv()

TOKEN = os.getenv("DISCORD_TOKEN")
RASA_URL = "http://localhost:5005/webhooks/rest/webhook"

intents = discord.Intents.default()
intents.message_content = True
client = discord.Client(intents=intents)

ssl_context = ssl.create_default_context(cafile=certifi.where())

@client.event
async def on_ready():
    print(f"✅ Bot zalogowany jako {client.user}")

@client.event
async def on_message(message):
    if message.author == client.user:
        return

    print(f"📨 Otrzymano wiadomość: '{message.content}'")

    payload = {"sender": str(message.author.id), "message": message.content}
    print(f"📤 Wysyłam do Rasa: {payload}")

    try:
        async with aiohttp.ClientSession(connector=aiohttp.TCPConnector(ssl=ssl_context)) as session:
            async with session.post(RASA_URL, json=payload) as resp:
                print(f"📥 Status odpowiedzi: {resp.status}")
                text = await resp.text()
                print(f"📥 Treść odpowiedzi: {text}")

                if resp.status == 200:
                    import json
                    responses = json.loads(text)
                    for r in responses:
                        print(f"📦 Wysyłam do Discorda: {r.get('text')}")
                        await message.channel.send(r.get("text", "🤖 (brak odpowiedzi)"))
                else:
                    await message.channel.send("❌ Błąd po stronie Rasa.")
    except Exception as e:
        print(f"❌ Błąd: {e}")
        await message.channel.send("⚠️ Wystąpił błąd podczas komunikacji z Rasa.")



client.run(TOKEN)

