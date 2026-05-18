from flask import Flask, redirect, request, jsonify, render_template, session
from flask_cors import CORS
import os
import mysql.connector  # den här modulen behövs för att skapa en databasanslutning
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity, get_jwt
from flask_socketio import SocketIO, emit

app = Flask(__name__)
CORS(app)
socketio = SocketIO(app)
app.secret_key = "supersecretkey"

@socketio.on('connect')
def handle_connect():
    print('Client connected', request.sid)
    emit("user_connected", broadcast=True)

@socketio.on('disconnect')
def handle_disconnect():
    print(f"User disconnected")
    emit("user_disconnected", broadcast=True)

db_config = {
    'host': 'localhost',
    'user': 'root',
    'password': '',
    'database': 'betygsgrundande' # Ändra namnet så det passar din databasserver
} 

def get_db_connection():
    """Get a database connection"""
    try:
        connection = mysql.connector.connect(**db_config)
        return connection
    except Error as e:
        print(f"Error connecting to MySQL: {e}")
        return None
    
@app.route('/')
def index():
    # session.clear()  # Rensa sessionen när användaren besöker startsidan
    # if request.method == "POST":
    #     username = request.form.get('username')
    #     password = request.form.get('password')
    #     for user in users:
    #         if user['username'] == username and user['password'] == password:
    #             session['username'] = username
    #             return render_template('index.html', username=username)
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500
    try:
        cursor = connection.cursor(dictionary=True)
        sql = """
        SELECT threads.thread_id,
            threads.title,
            threads.created_at,
            users.username
        FROM threads
        JOIN users ON threads.user_id = users.user_id
        """
        cursor.execute(sql)
        threads = cursor.fetchall()
    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to fetch threads'}), 500
    finally:
        if connection:
            connection.close()
            
    if 'username' in session:
        return render_template('index.html', username=session.get('username'), threads=threads)  # Skicka användarnamnet och trådar till index.html om det finns i sessionen
    return redirect('/login')  # Om användaren inte är inloggad, omdirigera till login-sidan

@app.route("/register", methods=['GET'])
def register_page():
    return render_template('register.html')

@app.route('/register', methods=['POST'])
def register():
    username = request.form.get('username')
    password = request.form.get('password')
    
    if not username or not password:
        return jsonify({'error': 'Username and password are required'}), 400
    
    # Hash the password
    hashed_password = generate_password_hash(password)
    
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = connection.cursor()
        
        # Check if user already exists
        sql_check = "SELECT * FROM users WHERE username = %s"
        cursor.execute(sql_check, (username,))
        if cursor.fetchone():
            return jsonify({'error': 'User already exists'}), 409
        
        # Insert new user
        sql_insert = "INSERT INTO users (username, password) VALUES (%s, %s)"
        cursor.execute(sql_insert, (username, hashed_password))
        connection.commit()
        
        session['username'] = username 
        session['role'] = 'user'  # Sätt standardrollen till 'user'
        session['user_id'] = cursor.lastrowid  # Spara det nya user_id i sessionen
        return redirect('/')  # Omdirigera till startsidan efter registrering
      
    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to create user'}), 500
    
    finally:
        if connection:
            connection.close()

@app.route('/create_thread', methods=['POST'])
def create_thread():
    if 'username' not in session:
        return jsonify({'error': 'Unauthorized'}), 401

    title = request.form.get('title')

    if not title:
        return jsonify({'error': 'Title is required'}), 400

    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    try:
        cursor = connection.cursor()

        # Hämta user_id från username
        cursor.execute("SELECT user_id FROM users WHERE username = %s", (session['username'],))
        user = cursor.fetchone()

        if not user:
            return jsonify({'error': 'User not found'}), 404

        user_id = user[0]

        sql_insert = """
        INSERT INTO threads (title, user_id)
        VALUES (%s, %s)
        """
        cursor.execute(sql_insert, (title, user_id))
        connection.commit()

        return redirect('/')  # Omdirigera till startsidan efter att tråden har skapats

    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to create thread'}), 500

    finally:
        if connection:
            connection.close()

@socketio.on("new_thread")
def handle_new_thread(data):
    title = data["title"]
    username = data["username"]

    connection = get_db_connection()

    if not connection:
        return

    try:
        cursor = connection.cursor()

        cursor.execute(
            "SELECT user_id FROM users WHERE username = %s",
            (username,)
        )

        user = cursor.fetchone()

        if not user:
            return

        user_id = user[0]

        cursor.execute("""
            INSERT INTO threads (title, user_id)
            VALUES (%s, %s)
        """, (title, user_id))

        connection.commit()

        thread_id = cursor.lastrowid

        emit("receive_thread", {
            "thread_id": thread_id,
            "title": title,
            "username": username
        }, broadcast=True)

    finally:
        if connection:
            connection.close()

@app.route('/thread/<int:thread_id>', methods=['GET'])
def view_thread(thread_id):

    if 'username' not in session:
        return jsonify({'error': 'Unauthorized'}), 401

    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = connection.cursor(dictionary=True)
        
        # Hämta trådinformation
        sql_thread = "SELECT * FROM threads WHERE thread_id = %s"
        cursor.execute(sql_thread, (thread_id,))
        thread = cursor.fetchone()

        if not thread:
            return jsonify({'error': 'Thread not found'}), 404

        # Hämta inlägg i tråden
        sql_posts = """
        SELECT posts.post_id, posts.user_id, posts.content, posts.created_at, users.username 
        FROM posts 
        JOIN users ON posts.user_id = users.user_id 
        WHERE posts.thread_id = %s
        """
        cursor.execute(sql_posts, (thread_id,))
        posts = cursor.fetchall()
        return render_template('thread.html', thread=thread, posts=posts, username=session['username'], role=session['role'], user_id=session['user_id'])
    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to fetch thread data'}), 500
    
@app.route('/create_post/<int:thread_id>', methods=['POST'])
def create_post(thread_id):
    if 'username' not in session:
        return jsonify({'error': 'Unauthorized'}), 401

    content = request.form.get('content')

    if not content:
        return jsonify({'error': 'Content is required'}), 400

    connection = get_db_connection()

    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    try:
        cursor = connection.cursor()

        # Hämta user_id från username
        cursor.execute(
            "SELECT user_id FROM users WHERE username = %s",
            (session['username'],)
        )

        user = cursor.fetchone()

        if not user:
            return jsonify({'error': 'User not found'}), 404

        user_id = user[0]

        # Lägg till posten
        sql_insert = """
        INSERT INTO posts (thread_id, user_id, content)
        VALUES (%s, %s, %s)
        """

        cursor.execute(sql_insert, (thread_id, user_id, content))
        connection.commit()

        return redirect(f'/thread/{thread_id}')

    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to create post'}), 500

    finally:
        if connection:
            connection.close()

@socketio.on("new_post")
def handle_new_post(data):

    thread_id = data["thread_id"]
    username = data["username"]
    content = data["content"]

    connection = get_db_connection()
    cursor = connection.cursor()

    # hämta user_id
    cursor.execute(
        "SELECT user_id FROM users WHERE username = %s",
        (username,)
    )

    user = cursor.fetchone()

    if not user:
        return

    user_id = user[0]

    # spara post
    cursor.execute("""
        INSERT INTO posts (thread_id, user_id, content)
        VALUES (%s, %s, %s)
    """, (thread_id, user_id, content))

    connection.commit()

    # skicka till alla clients
    emit("receive_post", {
        "thread_id": thread_id,
        "username": username,
        "content": content
    }, broadcast=True)

    connection.close()

@app.route("/login", methods=['GET'])
def login_page():
    return render_template('login.html')

@app.route('/login', methods=['POST'])
def login():
    username = request.form.get('username')
    password = request.form.get('password')
    
    
    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500
    
    try:
        cursor = connection.cursor(dictionary=True)
        sql = "SELECT * FROM users WHERE username = %s"
        cursor.execute(sql, (username,))
        user = cursor.fetchone()

        if not user or not check_password_hash(user['password'], password):
            return jsonify({'error': 'Invalid username or password'}), 401
        
        if 'password' in user: # ta bort password innan vi skickar tillbaka user info
            del user['password']

        session ['username'] = username  
        session["role"] = user["role"]
        session["user_id"] = user["user_id"]
        return redirect('/')  # Omdirigera till startsidan efter inloggning
    
    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to login'}), 500
    
    finally:
        if connection:
            connection.close()

@app.route('/logout', methods=['GET'])
def logout():
    session.clear()  # Rensa sessionen när användaren loggar ut
    return redirect('/login')  # Omdirigera till login-sidan efter utloggning

@app.route("/delete_post/<int:post_id>/<int:thread_id>", methods=['POST'])
def delete_post(post_id, thread_id):
    if 'username' not in session:
        return jsonify({'error': 'Unauthorized'}), 401

    connection = get_db_connection()
    if not connection:
        return jsonify({'error': 'Database connection failed'}), 500

    try:
        cursor = connection.cursor()

        # Hämta postens information
        cursor.execute("SELECT user_id FROM posts WHERE post_id = %s", (post_id,))
        post = cursor.fetchone()

        if not post:
            return jsonify({'error': 'Post not found'}), 404

        post_user_id = post[0]

        # Kontrollera om den inloggade användaren är ägaren av posten eller en admin
        if session['user_id'] != post_user_id and session['role'] != 'admin':
            return jsonify({'error': 'Forbidden'}), 403

        # Radera posten
        cursor.execute("DELETE FROM posts WHERE post_id = %s", (post_id,))
        connection.commit()

        return redirect(f'/thread/{thread_id}')

    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to delete post'}), 500

    finally:
        if connection:
            connection.close()
if __name__ == "__main__": 
    socketio.run(app, debug=True, port=3000) 