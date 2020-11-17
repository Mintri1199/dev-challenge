from random import choice
from flask import Flask, request
from flask_socketio import SocketIO, send, join_room, leave_room, emit


app = Flask(__name__)
app.config['SECRET_KEY'] = 'INSERT_SECRET_HERE'
socketio = SocketIO(app)
room_instances = {}


class Room:
    
    def __init__(self, name: str, file_name: str):
        self.room_name = name
        self.file_name = file_name
        self.clients = {}


@socketio.on("createRoom")
def handle_create_room(data):
    print(data)
    room_name = data['room']
    client_id = request.sid
    if room_name in room_instances:
        # Trigger Error
        emit("duplicate_room_name", room=client_id)
        return
    
    username = data['nickName']
    file_name = data['fileName']
    join_room(room_name)
    
    room_instance = Room(room_name, file_name)
    room_instance.clients[client_id] = [username, True]
    room_instances[room_name] = room_instance
    send(username + 'has create the room.', room=room_name)
    emit("changeLeader", room=client_id)
    send(username + 'has become the leader of the room.', room=room_name)
    print(room_instances)


@socketio.on('prepareToJoin')
def give_require_file_name(data):
    client_id = request.sid
    room_name = data['room']
    file_name = room_instances[room_name].file_name
    emit("require_file_name", {'file_name': file_name}, room=client_id)

@socketio.on("join")
def join_existing_room(data):
    username = data['nickName']
    room_name = data['room']
    client_id = request.sid
    
    if room_name not in room_instances:
        socketio.emit('room_nonexistence', room=client_id)
    else:
        room_instance = room_instances[room_name]
        room_instance.clients[client_id] = username
        join_room(room_name)
        print(username + ' has joined room: ' + room_name)
        send(username + 'has join the room.', room=room_name)


@socketio.on('leave')
def on_leave(data):
    client_id = request.sid
    username = data['nickName']
    room_name = data['room']
    leave_room(room_name)
    print(username + ' has left the room.')
    send(username + ' has left the room.', room=room_name)
    
    room_instance = room_instances[room_name]
    was_leader = room_instance[client_id][1]
    
    del room_instance.clients[client_id]
    
    if not bool(room_instance.clients):
        del room_instances[room_name]
    # Check if the person left was the leader of the room
    elif was_leader:
        next_leader = choice(room_instance.clients)
        emit("changeLeader", room=client_id)
        emit("broadcast", {'message': next_leader[0] + 'has become the leader of the room'}, room=room_name)
    
@socketio.on('play')
def play():
    send("play", broadcast=True)


@socketio.on('pause')
def pause():
    send("pause", broadcast=True)


@socketio.on('reset')
def reset():
    send("reset", broadcast=True)


if __name__ == "__main__":
    socketio.run(app)
