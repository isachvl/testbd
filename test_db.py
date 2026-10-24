import os
from datetime import datetime

import psycopg


def test_db_connection():
    with psycopg.connect(
        host=os.getenv("DB_HOST", "localhost"),
        port=os.getenv("DB_PORT", "5432"),
        dbname=os.getenv("DB_NAME", "intern_db"),
        user=os.getenv("DB_USER", "intern"),
        password=os.getenv("DB_PASSWORD", "intern123"),
        connect_timeout=5,
    ) as connection:
        with connection.cursor() as cursor:
            cursor.execute("SELECT now()")
            result = cursor.fetchone()

    assert result is not None
    assert isinstance(result[0], datetime)
