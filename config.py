from dotenv import load_dotenv
import os

# Load variables from .env
load_dotenv()

APP_NAME = os.getenv("APP_NAME", "FastAPI App")
DEBUG = os.getenv("DEBUG", "False") == "True"
PORT = int(os.getenv("PORT", 8000))
