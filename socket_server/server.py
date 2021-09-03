import asyncio
import websockets
import sys

import GameStateModule

port = 5000
gameState = GameStateModule.GameState()

if __name__ == '__main__':
    try:
        print("Starting the server...")
        loop = asyncio.get_event_loop()
        start_server = websockets.serve(gameState.handle_connections, "", 5000)
        asyncio.ensure_future(start_server)
        asyncio.ensure_future(gameState.forever_update_game())
        loop.run_forever()

    except KeyboardInterrupt:
        sys.exit()