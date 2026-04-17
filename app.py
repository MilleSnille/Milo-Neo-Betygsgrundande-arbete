from flask import Flask, request, jsonify, render_template, session
from flask_cors import CORS
import os
import mysql.connector  # den här modulen behövs för att skapa en databasanslutning
from mysql.connector import Error
from werkzeug.security import generate_password_hash, check_password_hash
from flask_jwt_extended import JWTManager, create_access_token, jwt_required, get_jwt_identity, get_jwt

app = Flask(__name__)
CORS(app)

app.secret_key = "supersecretkey"

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
    return render_template('index.html')

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
        return render_template('index.html', username=username)  
      
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

        return jsonify({'message': 'Thread created successfully'}), 201
        return render_template('index.html', username=session['username'])  # Skicka tillbaka användarnamnet till index.html

    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to create thread'}), 500

    finally:
        if connection:
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
        return render_template('index.html', username=username)
    
    except Error as e:
        print(f"Database error: {e}")
        return jsonify({'error': 'Failed to login'}), 500
    
    finally:
        if connection:
            connection.close()

@app.route('/logout', methods=['GET'])
def logout():
    session.clear()  # Rensa sessionen när användaren loggar ut
    return render_template('index.html')

if __name__ == "__main__": 
    app.run(debug=True, port=3000) 