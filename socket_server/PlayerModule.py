import json

class Player():
    def __init__(self, id, websocket):
        self.websocket = websocket
        self.id = id
        self.dict = {
                str(self.id): {
                    'username': 'bot',
                    'position': {
                        'x':0,
                        'y':0
                    },
                    'object': 'wood',
                    'angle': 0,
                    'health': 100
                }
            }
    def update(self, data):
        self.dict = data