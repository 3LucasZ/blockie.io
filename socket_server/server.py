import asyncio
import websockets
import sys
import GameStateModule
import utils

config = utils.get_config()
IP = config["WS_SERVER_CONFIG"]["IP"]
PORT = config["WS_SERVER_CONFIG"]["PORT"]

gameState = GameStateModule.GameState()
if __name__ == '__main__':
    try:
        print("Starting the server...")
        loop = asyncio.get_event_loop()
        start_server = websockets.serve(gameState.handle_connections, '', PORT)
        asyncio.ensure_future(start_server)
        asyncio.ensure_future(gameState.forever_update_game())
        loop.run_forever()

    except KeyboardInterrupt:
        sys.exit()