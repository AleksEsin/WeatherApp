FROM python:3.6.8

WORKDIR /weather

COPY requirements.txt requirements.txt

RUN pip3 install -r requirements.txt

COPY . weatherapp

CMD [ "python3", "manage.py", "runserver", "0.0.0.0:8000"]
