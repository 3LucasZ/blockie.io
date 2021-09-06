import asyncio
import websockets
import sys
#import ssl

import GameStateModule
IP = 'localhost'
PORT = 5000
gameState = GameStateModule.GameState()

if __name__ == '__main__':
    try:
        print("Starting the server...")
        loop = asyncio.get_event_loop()
        start_server = websockets.serve(gameState.handle_connections, IP, PORT)
        asyncio.ensure_future(start_server)
        asyncio.ensure_future(gameState.forever_update_game())
        loop.run_forever()

    except KeyboardInterrupt:
        sys.exit()