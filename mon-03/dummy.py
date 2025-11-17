# dummy.py
import json
import random
import time

messages = [
    ("info", "Hello there!!"),
    ("warning", "Hmmm....something strange"),
    ("error", "OH NO!!!!!!"),
    ("exception", "this is exception"),
]

while True:
    level, text = random.choice(messages)
    event = {"level": level, "message": text}
    print(json.dumps(event), flush=True)
    time.sleep(1)
