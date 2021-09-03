import json

class Player():
    def __init__(self, websocket):
        self.websocket = websocket
        self.dict = {
            'position': {
                'x':0,
                'y':0
            },
            'rotation': 3.14
        }
    def update(self, jsonData):
        self.dict = json.loads(jsonData)