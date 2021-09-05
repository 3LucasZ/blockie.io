//distance player moves per update function
const double SPEED = 2;
const double TILE_SIZE = 50;
const double SELECTED_OFFSET = 40;
const double PLAYER_SIZE = 50;
// the game send its data 1 out of 4 updates.
// update function called 60 times a second.
// Therefore 15 updates a second
const int UPDATE_INTERVAL = 4;
const int SNAPSHOT_LENGTH = 500;
const int SNAPSHOT_HEIGHT = 500;
