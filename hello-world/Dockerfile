FROM python:3.10.6-buster

RUN pip install --upgrade pip

RUN useradd -ms /bin/bash worker
USER worker

WORKDIR /home/worker
COPY --chown=worker:worker /src /home/worker

RUN pip install --user -r requirements.txt

ENV PATH="/home/worker/.local/bin:${PATH}"

COPY --chown=worker:worker . .

LABEL maintainer="Joaquin Britos <joacup23@gmail.com>" \
      version="1.0.0"

EXPOSE 8080

CMD [ "python", "-u", "hello-world.py" ]