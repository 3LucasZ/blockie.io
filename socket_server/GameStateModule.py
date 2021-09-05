import asyncio
import websockets
import json
import PlayerModule
import random

class GameState():
    def __init__(self):
        self.fps = 15
        self.playerSet = set()
        self.dict = {
            'players':[],
            'tiles':[]
        }
        tileChoices = ['grass', 'wood']

        for r in range(10):
            cList = []
            for c in range(10):
                cList.append(tileChoices[0])
            self.dict['tiles'].append(cList)
    
    async def handle_connections(self, websocket, path):
        #setup new connection
        print('new connection:', websocket)
        player = PlayerModule.Player(websocket)
        self.add_player(player)

        #send current game state
        await player.websocket.send(json.dumps(self.dict))

        #create a listener for the connection
        while True:
            try:
                newJsonData = await player.websocket.recv()
                newData = json.loads(newJsonData)
                if newData['type'] == 'playerState':
                    player.update(newData['data'])
                    print(newData['data'])
                elif newData['type'] == 'newTile':
                    r = newData['data']['position']['x']
                    c = newData['data']['position']['y']
                    self.dict['tiles'][r][c] = newData['data']['tile']
            except:
                continue

    async def forever_update_game(self):
        while True:
            self.update_dict()
            await self.update_game()
            await asyncio.sleep(1/self.fps)

    def update_dict(self):
        #collect game state
        self.dict['players'] = []
        for player in self.playerSet:
            self.dict['players'].append(player.dict)
    
    async def update_game(self):
        #send game state to all clients
        #remove non-receiving clients
        playersToRemove = set()
        for player in self.playerSet:
            try:
                await player.websocket.send(json.dumps(self.dict))
            except:
                playersToRemove.add(player)
                print("A player disconnected")

        for player in playersToRemove:
            self.remove_player(player)

    def add_player(self, player):
        self.playerSet.add(player)
    
    def remove_player(self, player):
        self.playerSet.remove(player)
    