import json

class Player():
    def __init__(self, websocket):
        self.websocket = websocket
        self.dict = {
            'username': 'bot',
            'position': {
                'x':0,
                'y':0
            },
            'selected': 'wood',
            'rotation': 0
        }
    def update(self, data):
        self.dict = data