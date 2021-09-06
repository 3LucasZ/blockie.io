import asyncio
import websockets
import json
import PlayerModule
import random

class GameState():
    def __init__(self):
        self.fps = 4
        self.playerSet = set()
        self.dict = {
            'players':[],
            'tiles':[],
            'meta': {
                'x': 0,
                'y': 0
            }
        }
        tileChoices = ['grass', 'wood']

        for y in range(50):
            yList = []
            for x in range(50):
                yList.append(tileChoices[0])
            self.dict['tiles'].append(yList)
    
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
                    print('recved', newData['data'])
                elif newData['type'] == 'newTile':
                    x = newData['data']['position']['x']
                    y = newData['data']['position']['y']
                    self.dict['tiles'][y][x] = newData['data']['tile']
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
                await self.send_snapshot(player)
            except:
                playersToRemove.add(player)
                print("A player disconnected")

        for player in playersToRemove:
            self.remove_player(player)

    def add_player(self, player):
        self.playerSet.add(player)
    
    def remove_player(self, player):
        self.playerSet.remove(player)

    async def send_snapshot(self, player):
        cx = int(player.dict['position']['x'] // 50)
        cy = int(player.dict['position']['y'] // 50)
        snapshot = dict(self.dict)
        snapshot['tiles'] = [tileRow[cx-8:cx+9] for tileRow in snapshot['tiles'][cy-8:cy+9]]
        snapshot['meta']['x'] = cx-8
        snapshot['meta']['y'] = cy-8
        print('sent')
        await player.websocket.send(json.dumps(snapshot))
    