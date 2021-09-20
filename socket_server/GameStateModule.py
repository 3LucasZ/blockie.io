import asyncio
import websockets
import json
import PlayerModule
import random
import utils

config = utils.get_config()

class GameState():
    def __init__(self):
        self.fps = config['GAME_CONFIG']['FPS']
        self.playerSet = set()
        self.playersData = {
            'type': 'playersData',
            'data': {
                'players': {
                }
            }
        }
        self.objectsData = {
            'type': 'objectsData',
            'data': {
                'objects': []
            }
        }
        self.playerIdIndex = 1
        self.objectIdIndex = 1
    
    async def handle_connections(self, newWebsocket, path):
        print('new connection:', newWebsocket)
        self.playerIdIndex += 1
        #broadcast new player
        await self.broadcast({
            'type': 'newPlayer',
            'data': self.playerIdIndex
        })
        #send starting data to new player
        await newWebsocket.send(json.dumps({
            'type': 'startingData',
            'data': {
                'id': self.playerIdIndex,
                'id_array': [player.id for player in self.playerSet],
                'objects': self.objectsData['data']['objects']
            }
        }))
        #setup new player
        newPlayer = PlayerModule.Player(id=self.playerIdIndex, websocket=newWebsocket)
        self.add_player(newPlayer)
        #create a listener for the connection
        await self.listen_on(newPlayer)
        
    async def listen_on(self, player):
        while True:
            try:
                newJsonData = await player.websocket.recv()
                newData = json.loads(newJsonData)
                if newData['type'] == 'playerState':
                    player.update(newData['data'])
                    print('recved', newData['data'])
                elif newData['type'] == 'newObject':
                    print('recved', newData['data'])
                    self.objectIdIndex += 1
                    newData['data']['id'] = self.objectIdIndex
                    self.objectsData['data']['objects'].append(newData['data'])
                    await self.broadcast(newData)
                else:
                    print('the received json data is unsupported.')
            except:
                continue
            print("Listening on player:", player.id)

    async def forever_update_game(self):
        while True:
            #collect player states
            for player in self.playerSet:
                self.playersData['data']['players'].update(player.dict)
            await self.broadcast(self.playersData)
            await asyncio.sleep(1/self.fps)

    def add_player(self, player):
        self.playerSet.add(player)
    
    def remove_player(self, player):
        del self.playersData['data']['players'][str(player.id)]
        self.playerSet.remove(player)

    async def broadcast(self, data):
        jsonData = json.dumps(data)
        #send json to all clients
        #remove non-receiving clients
        playersToRemove = set()
        for player in self.playerSet:
            try:
                await player.websocket.send(jsonData)
            except:
                playersToRemove.add(player)
                print("A player disconnected")
        for player in playersToRemove:
            self.remove_player(player)
        print('broadcasted:', jsonData)