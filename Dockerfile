FROM python:3.10.5-slim-buster

# Prevents Python from writing pyc files.
ENV PYTHONDONTWRITEBYTECODE=1

# Keeps Python from buffering stdout and stderr to avoid situations where
# the application crashes without emitting any logs due to buffering.
ENV PYTHONUNBUFFERED=1

# Set working directory
WORKDIR /app

ENV FLASK_APP=app.py
ENV FLASK_RUN_HOST=0.0.0.0

# Create a non-privileged user that the app will run under.
# See https://docs.docker.com/develop/develop-images/dockerfile_best-practices/#user
ARG UID=10001
RUN adduser \
    --disabled-password \
    --gecos "" \
    --home "/nonexistent" \
    --shell "/sbin/nologin" \
    --no-create-home \
    --uid "${UID}" \
    appuser

RUN --mount=type=cache,target=/root/.cache/pip \
    --mount=type=bind,source=requirements.txt,target=requirements.txt \
    python -m pip install -r requirements.txt

RUN --mount=type=secret, id=kaggle_token, env=KAGGLE_TOKEN

RUN mkdir -p ../root/.config/kaggle

RUN chmod 600 ../root/.config/kaggle/kaggle.json

RUN echo ${KAGGLE_TOCKEN} > ../root/.config/kaggle/kaggle.json

RUN kaggle kernels output aziz0220/mastere/best_model_MobileNet_3.keras -p model.keras

COPY ./dataset/image.png .

RUN --mount=type=bind, source=app.py , target=app.py

RUN --mount=type=bind, source=dataset/real.png target=real.png

RUN --mount=type=bind, source=test.py target=test.py

RUN pytest test.py --maxfail=2 --disable-warnings

EXPOSE 8000

CMD python app.py
