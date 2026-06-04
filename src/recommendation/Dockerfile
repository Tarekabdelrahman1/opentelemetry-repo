
FROM python:3.12-slim-bookworm

WORKDIR /usr/src/app

RUN pip install --upgrade pip

COPY requirements.txt .

RUN pip install -r requirements.txt

COPY . .

# 7. نقطة الانطلاق لتشغيل التطبيق الرئيسي
ENTRYPOINT ["python", "recommendation_server.py"]