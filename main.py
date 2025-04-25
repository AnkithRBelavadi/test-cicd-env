from fastapi import FastAPI
from config import APP_NAME

app = FastAPI(title=APP_NAME)

@app.get("/")
def read_root():
    return {"message": f"Welcome too {APP_NAME}!"}
