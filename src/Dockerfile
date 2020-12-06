FROM python:3.6
LABEL maintainer="kylemclaren@protonmail.com"
COPY . /app
WORKDIR /app
RUN pip install -r requirements.txt
ENTRYPOINT ["python"]
CMD ["app.py"]
