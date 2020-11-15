from flask import Flask
from flask_socketio import SocketIO, send, join_room, leave_room, rooms


app = Flask(__name__)
app.config['SECRET_KEY'] = 'INSERTSECRET_HERE'
socketio = SocketIO(app)


@socketio.on('message')
def handleMessage(msg):
    print('Message: ' + msg)
    send(msg, broadcast=True)

@socketio.on("createRoom")
def handle_create_room(data):
    room = data['room']
    username = data['username']
    join_room(room)
    print(username + 'has create the room.')
    send(username + 'has create the room.', room=room)

@socketio.on('leave')
def on_leave(data):
    username = data['username']
    room = data['room']
    leave_room(room)
    print(username + ' has left the room.')
    send(username + ' has left the room.', room=room)

@socketio.on("join")
def join_existing_room(data):
    room_name = data['room']
    all_rooms = rooms()
    print(all_rooms)
    
    print('Does room ' + room_name + ' existed? ' + str(room_name in all_rooms))
@socketio.on('play')
def play():
    send("play", broadcast=True)


@socketio.on('pause')
def pause():
    send("pause", broadcast=True)


@socketio.on('reset')
def pause():
    send("reset", broadcast=True)


if __name__ == "__main__":
    socketio.run(app)
